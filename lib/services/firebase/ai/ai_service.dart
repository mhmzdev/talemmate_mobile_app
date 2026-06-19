import 'dart:typed_data';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:taleemmate/services/firebase/ai/agent_tools.dart';
import 'package:taleemmate/services/firebase/ai/system_prompts.dart';

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

  /// Conversational tutor tier — Flash balances cost and latency for chat.
  static const _chatModel = 'gemini-2.5-flash';

  /// Weekly study-plan generator tier — Flash is fast enough for a one-shot,
  /// structured generation at onboarding.
  static const _planModel = 'gemini-2.5-flash';

  /// Single-answer MCQ quiz generator tier — Flash handles a one-shot,
  /// structured generation from a focus session or library material.
  static const _quizModel = 'gemini-2.5-flash';

  GenerativeModel? _extractor;

  GenerativeModel? _chat;

  GenerativeModel? _planner;

  GenerativeModel? _reasoner;

  GenerativeModel? _quiz;

  /// Lazily builds the extraction model, sourcing its system instruction from
  /// [SystemPrompts] (kept out of code so the prompt is editable).
  Future<GenerativeModel> _extractorModel() async {
    final instruction = await SystemPrompts.library();
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

  /// Grounded tutor model: JSON-only structured output ([AgentTools.chatSchema])
  /// with the supplied [systemPrompt] as its system instruction. Built once and
  /// reused — the prompt is a stable bundled asset. Callers send the assembled
  /// conversation `Content` list to `generateContent`.
  GenerativeModel chatModel(String systemPrompt) =>
      _chat ??= FirebaseAI.googleAI().generativeModel(
        model: _chatModel,
        systemInstruction: Content.system(systemPrompt),
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
          responseSchema: AgentTools.ins.chatSchema,
        ),
      );

  /// Structured weekly-plan generator: JSON-only output
  /// ([AgentTools.planSchema]) with the supplied [systemPrompt] as its system
  /// instruction. Built once and reused — the prompt is a stable bundled asset.
  GenerativeModel planModel(String systemPrompt) =>
      _planner ??= FirebaseAI.googleAI().generativeModel(
        model: _planModel,
        systemInstruction: Content.system(systemPrompt),
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
          responseSchema: AgentTools.ins.planSchema,
        ),
      );

  /// Narrow reasoning rewriter: JSON-only output ([AgentTools.reasonSchema])
  /// producing a single fresh "Why this plan" paragraph after a reschedule.
  /// Reuses the Flash plan tier — built once and reused with its bundled prompt.
  GenerativeModel reasonModel(String systemPrompt) =>
      _reasoner ??= FirebaseAI.googleAI().generativeModel(
        model: _planModel,
        systemInstruction: Content.system(systemPrompt),
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
          responseSchema: AgentTools.ins.reasonSchema,
        ),
      );

  /// Structured single-answer MCQ generator: JSON-only output
  /// ([AgentTools.quizSchema]) with the supplied [systemPrompt] as its system
  /// instruction. Built once and reused — the prompt is a stable bundled asset.
  GenerativeModel quizModel(String systemPrompt) =>
      _quiz ??= FirebaseAI.googleAI().generativeModel(
        model: _quizModel,
        systemInstruction: Content.system(systemPrompt),
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
          responseSchema: AgentTools.ins.quizSchema,
        ),
      );
}
