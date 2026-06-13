import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
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

/// Builds a [LibraryItem] from a [PickedMaterial]. `processingStatus` is mocked
/// as `indexed` (no real OCR/indexing yet).
LibraryItem libraryItemForPick({
  required PickedMaterial pick,
  required String userId,
  String? subjectId,
  String? colorHex,
}) => LibraryItem(
  id: const Uuid().v4(),
  userId: userId,
  name: pick.name,
  kind: itemKindForExtension(pick.ext),
  fileSize: pick.sizeBytes,
  uploadedAt: DateTime.now(),
  processingStatus: ProcessingStatus.indexed,
  metadata: pick.path,
  subjectId: subjectId,
  colorHex: colorHex,
);
