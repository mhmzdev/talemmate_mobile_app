part of '../onboarding.dart';

// Study time windows for step 3 schedule picker.
const _studyWindows = [
  ('afterFajr', 'After Fajr', '05:30-07:00'),
  ('morning', 'Morning', '09:00-12:00'),
  ('afternoon', 'Afternoon', '14:00-16:00'),
  ('evening', 'Evening', '16:30-19:00'),
  ('afterIsha', 'After Isha', '21:00-23:00'),
];

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
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
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
