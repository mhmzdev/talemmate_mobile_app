part of 'library.dart';

/// One rendered section: a subject (or `null` for the Unsorted bucket) and the
/// materials under it.
typedef LibrarySection = ({Subject? subject, List<LibraryItem> items});

/// Pure derivation of the displayed list: applies the in-memory name search and
/// the active subject filter, then groups by subject (ordered by `Subject.order`
/// — already the cubit's order) with the Unsorted bucket last.
List<LibrarySection> groupMaterials({
  required List<LibraryItem> items,
  required List<Subject> subjects,
  required String query,
  required String? subjectFilter,
}) {
  final q = query.trim().toLowerCase();
  final knownIds = subjects.map((s) => s.id).toSet();

  final filtered = items.where((i) {
    final matchesQuery = q.isEmpty || i.name.toLowerCase().contains(q);
    final matchesSubject =
        subjectFilter == null || i.subjectId == subjectFilter;
    return matchesQuery && matchesSubject;
  }).toList();

  final sections = subjects
      .map<LibrarySection>(
        (s) => (
          subject: s,
          items: filtered.where((i) => i.subjectId == s.id).toList(),
        ),
      )
      .where((sec) => sec.items.isNotEmpty)
      .toList();

  final unsorted = filtered
      .where((i) => i.subjectId == null || !knownIds.contains(i.subjectId))
      .toList();
  if (unsorted.isNotEmpty) {
    sections.add((subject: null, items: unsorted));
  }

  return sections;
}
