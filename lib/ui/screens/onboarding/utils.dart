part of 'onboarding.dart';

// Non-widget helpers shared across the onboarding feature.

/// Maps a file extension to a [ItemKind] for picked Step-4 materials.
ItemKind _kindForExtension(String? ext) => switch ((ext ?? '').toLowerCase()) {
  'pdf' => .pdf,
  'jpg' || 'jpeg' || 'png' || 'heic' || 'webp' || 'gif' || 'img' => .img,
  'ppt' || 'pptx' || 'key' => .slide,
  'mp4' || 'mov' => .video,
  'mp3' || 'm4a' || 'wav' => .voice,
  _ => .note,
};

/// Parses a "#RRGGBB" tag-colour string into a [Color].
Color _hexColor(String hex) => Color(int.parse(hex.replaceFirst('#', '0xFF')));

/// Confidence scale shared by the subject entry and the add-subject modal.
String _confidenceLabel(double v) {
  if (v < 0.35) return 'Shaky';
  if (v < 0.7) return 'Getting there';
  return 'Confident';
}

Color _confidenceColor(double v) {
  if (v < 0.35) return const Color(0xFFE05252);
  if (v < 0.7) return const Color(0xFFE09A2B);
  return const Color(0xFF4CAF50);
}

/// Input decoration used by text fields inside the onboarding modals.
InputDecoration _modalInputDec(String hint) => InputDecoration(
  hintText: hint,
  hintStyle: AppText.b1.cl(AppTheme.c.subText),
  filled: true,
  fillColor: AppTheme.c.subBackground,
  border: OutlineInputBorder(
    borderRadius: 10.radius(),
    borderSide: BorderSide(color: AppTheme.c.border),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: 10.radius(),
    borderSide: BorderSide(color: AppTheme.c.border),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: 10.radius(),
    borderSide: BorderSide(color: AppTheme.c.accent),
  ),
  contentPadding: Space.sym(SpaceToken.t12, SpaceToken.t16),
);
