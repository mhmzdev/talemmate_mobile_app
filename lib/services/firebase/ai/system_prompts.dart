import 'package:flutter/services.dart' show rootBundle;
import 'package:taleemmate/gen/assets/assets.gen.dart';

/// Single home for the app's bundled system-instruction prompts. Each asset is
/// loaded from `assets/` once and cached for the process lifetime, so prompt
/// copy stays editable without a recompile and is read at most once per file.
///
/// Add a getter per prompt as new agents land (chat, library extraction, …).
class SystemPrompts {
  SystemPrompts._();

  static final Map<String, String> _cache = {};

  /// Loads [asset] once, then serves it from the in-memory cache.
  static Future<String> _load(String asset) async =>
      _cache[asset] ??= await rootBundle.loadString(asset);

  /// Grounded tutor chat prompt (`assets/chat_sys_prompt.md`).
  static Future<String> chat() => _load(Assets.chatSysPrompt);

  /// Library text-extraction prompt (`assets/library_extraction_sys_prompt.md`).
  static Future<String> library() => _load(Assets.libraryExtractionSysPrompt);

  /// Weekly study-plan generation prompt (`assets/plan_sys_prompt.md`).
  static Future<String> plan() => _load(Assets.planSysPrompt);

  /// Narrow "Why this plan" rewrite prompt
  /// (`assets/plan_reason_sys_prompt.md`), used after a block reschedule.
  static Future<String> reason() => _load(Assets.planReasonSysPrompt);
}
