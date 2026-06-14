import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:taleemmate/core/models/library/library_item.dart';
import 'package:uuid/uuid.dart';

/// A single picked file/photo before it becomes a [LibraryItem].
class PickedMaterial {
  const PickedMaterial({
    required this.name,
    required this.sizeBytes,
    this.path,
    this.ext,
  });

  final String name;
  final int sizeBytes;
  final String? path;
  final String? ext;
}

/// Native file/photo/camera pickers, shared by onboarding Step 4 and the
/// Library "Add new material" path. Returns small value results — callers turn
/// them into [LibraryItem]s via [libraryItemForPick].
class MaterialPicker {
  const MaterialPicker._();

  static Future<List<PickedMaterial>> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result == null) return const []; // user cancelled
    return result.files
        .map(
          (f) => PickedMaterial(
            name: f.name,
            sizeBytes: f.size,
            path: f.path,
            ext: f.extension,
          ),
        )
        .toList();
  }

  static Future<List<PickedMaterial>> pickImages() async {
    final images = await ImagePicker().pickMultiImage();
    if (images.isEmpty) return const [];
    return Future.wait(
      images.map(
        (x) async => PickedMaterial(
          name: x.name,
          sizeBytes: await x.length(),
          path: x.path,
          ext: 'img',
        ),
      ),
    );
  }

  static Future<PickedMaterial?> captureImage() async {
    final shot = await ImagePicker().pickImage(source: ImageSource.camera);
    if (shot == null) return null;
    return PickedMaterial(
      name: shot.name,
      sizeBytes: await shot.length(),
      path: shot.path,
      ext: 'img',
    );
  }
}

/// Maps a file extension to an [ItemKind]. Shared mapping (was onboarding's
/// private `_kindForExtension`).
ItemKind itemKindForExtension(String? ext) =>
    switch ((ext ?? '').toLowerCase()) {
      'pdf' => ItemKind.pdf,
      'jpg' || 'jpeg' || 'png' || 'heic' || 'webp' || 'gif' || 'img' =>
        ItemKind.img,
      'ppt' || 'pptx' || 'key' => ItemKind.slide,
      'mp4' || 'mov' => ItemKind.video,
      'mp3' || 'm4a' || 'wav' => ItemKind.voice,
      _ => ItemKind.note,
    };

/// Copies a freshly-picked file out of the OS temp/cache dir (which iOS purges)
/// into the app's persistent documents dir, so background extraction — and any
/// future read — can rely on it. Returns the stable path, or the original path
/// on failure (extraction will then surface a handled failure). Keyed by [id]
/// so the on-disk name is stable and collision-free.
Future<String?> _persistPickedFile(String id, PickedMaterial pick) async {
  final src = pick.path;
  if (src == null) return null;
  try {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, 'library'));
    if (!await dir.exists()) await dir.create(recursive: true);
    final dest = p.join(dir.path, '$id${p.extension(src)}');
    await File(src).copy(dest);
    return dest;
  } catch (_) {
    return src;
  }
}

/// Builds a [LibraryItem] from a [PickedMaterial], persisting the picked file to
/// stable storage first (see [_persistPickedFile]). Starts as `pending` — the
/// text-extraction pipeline (`MaterialCubit.process`) drives it to
/// `processing → indexed | failed`.
Future<LibraryItem> libraryItemForPick({
  required PickedMaterial pick,
  required String userId,
  String? subjectId,
  String? colorHex,
}) async {
  final id = const Uuid().v4();
  final path = await _persistPickedFile(id, pick);
  return LibraryItem(
    id: id,
    userId: userId,
    name: pick.name,
    kind: itemKindForExtension(pick.ext),
    fileSize: pick.sizeBytes,
    uploadedAt: DateTime.now(),
    processingStatus: ProcessingStatus.pending,
    metadata: path,
    subjectId: subjectId,
    colorHex: colorHex,
  );
}
