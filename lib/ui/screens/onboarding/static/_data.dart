part of '../onboarding.dart';

// Study time windows for step 3 schedule picker — derived from the shared
// canonical catalogue (`kStudyWindowCatalog`) so the ids stay in lock-step with
// what `PlanRepo` resolves at generation time. Shape kept as
// (id, label, 'HH:mm-HH:mm') for the picker tiles.
final _studyWindows = kStudyWindowCatalog
    .map((w) => (w.id, w.label, '${w.startTime}-${w.endTime}'))
    .toList();

// Tag colors available when creating a subject.
const _subjectColors = [
  '#6B6B85',
  '#4CAF50',
  '#E05252',
  '#E09A2B',
  '#4A90D9',
  '#9B59B6',
  '#1ABC9C',
];

// Short month abbreviations used for date display.
const _monthAbbr = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

// Mock subject suggestions shown in the "Add subject" modal.
// Returns suggestions tailored to institution + year when available.
List<Map<String, String>> _subjectSuggestions(
  String? institution,
  String? year,
) {
  if (institution == 'NUST' && year == 'Y3') {
    return [
      {
        'code': 'CS-200',
        'name': 'Discrete Mathematics',
        'reason': 'Core CS requirement',
      },
      {
        'code': 'MT-204',
        'name': 'Linear Algebra',
        'reason': 'Engineering maths track',
      },
      {
        'code': 'CS-370',
        'name': 'Database Systems',
        'reason': 'Commonly taken in Y3',
      },
      {
        'code': 'HU-101',
        'name': 'Communication Skills',
        'reason': 'HU elective',
      },
    ];
  }
  return [
    {
      'code': 'CS-101',
      'name': 'Introduction to Programming',
      'reason': 'Core course',
    },
    {'code': 'MT-101', 'name': 'Calculus', 'reason': 'Engineering maths'},
    {
      'code': 'PH-101',
      'name': 'Applied Physics',
      'reason': 'Science requirement',
    },
    {
      'code': 'EE-201',
      'name': 'Circuit Analysis',
      'reason': 'Engineering elective',
    },
  ];
}
