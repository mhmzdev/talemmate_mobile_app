import 'package:taleemmate/core/models/schedule/study_window.dart';

/// Canonical catalogue of the study windows the app offers. Single source of
/// truth shared by the onboarding picker (UI) and `PlanRepo` (generation), so a
/// schedule's `enabledWindowIds` always resolves to real times without a
/// UI→repo import. The `StudyWindows` DB table is left unseeded for now — these
/// const values are authoritative.
const kStudyWindowCatalog = <StudyWindow>[
  StudyWindow(
    id: 'afterFajr',
    label: 'After Fajr',
    startTime: '05:30',
    endTime: '07:00',
  ),
  StudyWindow(
    id: 'morning',
    label: 'Morning',
    startTime: '09:00',
    endTime: '12:00',
  ),
  StudyWindow(
    id: 'afternoon',
    label: 'Afternoon',
    startTime: '14:00',
    endTime: '16:00',
  ),
  StudyWindow(
    id: 'evening',
    label: 'Evening',
    startTime: '16:30',
    endTime: '19:00',
  ),
  StudyWindow(
    id: 'afterIsha',
    label: 'After Isha',
    startTime: '21:00',
    endTime: '23:00',
  ),
];
