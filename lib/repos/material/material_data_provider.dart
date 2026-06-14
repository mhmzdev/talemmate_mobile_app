part of 'material_repo.dart';

/// Inline-data ceiling for a single Gemini request (~20 MB). Larger files are
/// surfaced as a handled failure rather than attempted.
const _maxInlineBytes = 20 * 1024 * 1024;

/// Note formats we can read as text directly (no AI call).
const _plainTextExts = {'md', 'txt'};

/// Image extension → Gemini mime type.
const _imageMimes = {
  'png': 'image/png',
  'jpg': 'image/jpeg',
  'jpeg': 'image/jpeg',
  'webp': 'image/webp',
  'heic': 'image/heic',
  'gif': 'image/gif',
};

class _MaterialProvider {
  /// See [MaterialRepo.extract].
  static Future<Map<String, dynamic>> extract(
    Map<String, dynamic> item,
  ) async {
    final id = item['id'] as String;
    final path = item['metadata'] as String?;
    final kind = item['kind'] as String?; // serialized ItemKind name
    final ext = path == null
        ? ''
        : p.extension(path).replaceFirst('.', '').toLowerCase();

    final isPlainText = kind == 'note' && _plainTextExts.contains(ext);
    final supportsAi = kind == 'pdf' || kind == 'img';

    // Unsupported (slide/video/voice, or a non-text note like .docx) — a
    // handled, expected outcome, not an error: mark failed and return.
    if (path == null || (!isPlainText && !supportsAi)) {
      await AppDatabase.ins.markLibraryFailed(id);
      return {...item, 'processingStatus': 'failed'};
    }

    try {
      await AppDatabase.ins.markLibraryProcessing(id);

      final String text;
      final int pageCount;

      if (isPlainText) {
        text = await File(path).readAsString();
        pageCount = 1;
      } else {
        final bytes = await File(path).readAsBytes();
        if (bytes.lengthInBytes > _maxInlineBytes) {
          await AppDatabase.ins.markLibraryFailed(id);
          throw AiFault(
            'This file is too large to read (max 20 MB).',
            StackTrace.current,
          );
        }
        final mime = kind == 'pdf'
            ? 'application/pdf'
            : (_imageMimes[ext] ?? 'image/jpeg');
        text = await AiService.ins.extractText(bytes, mime);
        pageCount = _estimatePages(kind, text.length);
      }

      await AppDatabase.ins.saveMaterialText(
        itemId: id,
        content: text,
        pageCount: pageCount,
        charCount: text.length,
        extractedAt: DateTime.now(),
      );
      await AppDatabase.ins.markLibraryIndexed(id, pageCount);

      return {
        ...item,
        'processingStatus': 'indexed',
        'indexedPageCount': pageCount,
      };
    } on Fault {
      rethrow; // deliberate typed fault (e.g. too-large) — already marked failed
    } on FirebaseAIException catch (e, st) {
      await AppDatabase.ins.markLibraryFailed(id);
      throw AiFault.fromAiException(e, st);
    } catch (e, st) {
      await AppDatabase.ins.markLibraryFailed(id);
      throw UnknownFault(
        'Couldn\'t read this material. Please try again.',
        st,
      );
    }
  }

  /// See [MaterialRepo.textsForSubject].
  static Future<List<Map<String, dynamic>>> textsForSubject(
    String userId,
    String subjectId,
  ) async {
    try {
      return await AppDatabase.ins.materialTextsForSubject(userId, subjectId);
    } catch (e, st) {
      throw UnknownFault('Could not load study material text.', st);
    }
  }

  /// Rough page estimate — images are one "page"; documents are sized from the
  /// extracted character count (Gemini doesn't report source page counts).
  static int _estimatePages(String? kind, int charLen) {
    if (kind == 'img') return 1;
    return charLen <= 0 ? 1 : (charLen / 1800).ceil();
  }
}
