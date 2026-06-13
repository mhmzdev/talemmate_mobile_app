import 'package:flutter/material.dart';
import 'package:taleemmate/configs/configs.dart';

/// Public view model for a single subject pill. Keeps [SubjectChips] decoupled
/// from any feature-private draft/model (onboarding maps its `_SubjectDraft`,
/// Library maps its `Subject`).
class SubjectChipData {
  const SubjectChipData({
    required this.id,
    required this.label,
    required this.colorHex,
  });

  final String id;
  final String label;
  final String colorHex;
}

/// A selectable row of subject pills (colored dot + name). Shared across the
/// onboarding flow (add-exam modal, Step 4 material attachment) and the Library.
class SubjectChips extends StatelessWidget {
  const SubjectChips({
    super.key,
    required this.subjects,
    required this.selectedId,
    required this.onSelect,
    this.emptyMessage,
  });

  final List<SubjectChipData> subjects;
  final String? selectedId;
  final ValueChanged<String> onSelect;

  /// Shown when [subjects] is empty. Defaults to a generic message.
  final String? emptyMessage;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    if (subjects.isEmpty) {
      return Text(
        emptyMessage ?? 'No subjects yet.',
        style: AppText.b2.cl(AppTheme.c.subText),
      );
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: subjects.map((s) {
        final selected = selectedId == s.id;
        return GestureDetector(
          onTap: () => onSelect(s.id),
          child: Container(
            padding: Space.a.t08 + Space.h.t04,
            decoration: BoxDecoration(
              color: selected ? AppTheme.c.primary : Colors.transparent,
              borderRadius: 30.radius(),
              border: Border.all(
                color: selected ? AppTheme.c.primary : AppTheme.c.border,
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: .min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: .circle,
                    color: s.colorHex.toColor(),
                  ),
                ),
                Space.x.t08,
                Text(
                  s.label,
                  style: AppText.b1.cl(
                    selected ? AppTheme.c.background : AppTheme.c.text,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
