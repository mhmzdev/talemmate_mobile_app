part of '../library.dart';

/// Horizontal row of filter pills — "All" plus one per subject. Narrows the
/// visible sections to a single subject (or all). Hidden when no subjects exist.
class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.subjects, required this.selectedId});

  final List<Subject> subjects;
  final String? selectedId;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    if (subjects.isEmpty) return const SizedBox.shrink();

    final state = _ScreenState.s(context);
    final chips = <({String? id, String label})>[
      (id: null, label: 'All'),
      ...subjects.map((s) => (id: s.id, label: s.name)),
    ];

    return SingleChildScrollView(
      scrollDirection: .horizontal,
      padding: Space.b.t04,
      child: Row(
        children: chips
            .asMap()
            .entries
            .expand(
              (e) => [
                if (e.key != 0) Space.x.t08,
                AppChoiceChip(
                  label: e.value.label,
                  selected: selectedId == e.value.id,
                  onTap: () => state.setFilter(e.value.id),
                ),
              ],
            )
            .toList(),
      ),
    );
  }
}
