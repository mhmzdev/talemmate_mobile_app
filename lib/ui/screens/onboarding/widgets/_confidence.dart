part of '../onboarding.dart';

// Confidence scale shared by the subject entry and the add-subject modal.
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
