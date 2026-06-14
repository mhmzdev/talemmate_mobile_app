import 'dart:typed_data';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:taleemmate/gen/assets/assets.gen.dart';

/// Low-level, reusable `firebase_ai` (Gemini) wrapper. Owns the configured
/// models the app talks to. Callers get raw text back or a [FirebaseAIException]
/// to convert into a typed `Fault` (see `AiFault`). Piggybacks on the existing
/// `Firebase.initializeApp()` — no separate init.
class AiService {
  AiService._();
  static final AiService ins = AiService._();

  /// Multimodal model used to read text out of documents/images. Flash is the
  /// cheap, fast tier — extraction is a mechanical transcription task.
  static const _extractionModel = 'gemini-2.5-flash';

  GenerativeModel? _extractor;
  String? _extractionInstruction;

  /// Lazily builds the extraction model, loading its system instruction from
  /// the bundled asset (kept out of code so the prompt is editable).
  Future<GenerativeModel> _extractorModel() async {
    final instruction = _extractionInstruction ??= await rootBundle.loadString(
      Assets.libraryExtractionSysPrompt,
    );
    return _extractor ??= FirebaseAI.googleAI().generativeModel(
      model: _extractionModel,
      systemInstruction: Content.system(instruction),
    );
  }

  /// Sends [bytes] of [mimeType] to Gemini and returns the extracted plain
  /// text. Throws [FirebaseAIException] on an AI failure.
  Future<String> extractText(Uint8List bytes, String mimeType) async {
    final model = await _extractorModel();
    final res = await model.generateContent([
      Content.multi([
        const TextPart('Extract all readable text from this file.'),
        InlineDataPart(mimeType, bytes),
      ]),
    ]);
    return res.text ?? '';
  }
}
