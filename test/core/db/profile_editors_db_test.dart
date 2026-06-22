import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taleemmate/core/db/database.dart';
import 'package:taleemmate/core/models/library/library_item.dart';

import '../../helpers/fixtures.dart';

/// Exercises the Profile-editor `AppDatabase` Map-wrappers against a real
/// in-memory SQLite (foreign keys ON, per the migration's `beforeOpen`).
void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  Map<String, dynamic> subjectMap({
    String id = 's1',
    String userId = 'u1',
    String name = 'Mathematics',
    double confidence = 0.5,
  }) => {
    'id': id,
    'userId': userId,
    'code': 'MATH',
    'name': name,
    'colorHex': '#4F7A5C',
    'confidenceLevel': confidence,
    'order': 0,
  };

  group('upsertSubject', () {
    test('inserts then updates the same row by id', () async {
      await db.upsertSubject(subjectMap());
      var rows = await db.subjectsForUser('u1');
      expect(rows, hasLength(1));
      expect(rows.single['name'], 'Mathematics');

      await db.upsertSubject(subjectMap(name: 'Maths II', confidence: 0.9));
      rows = await db.subjectsForUser('u1');
      expect(rows, hasLength(1));
      expect(rows.single['name'], 'Maths II');
      expect(rows.single['confidenceLevel'], 0.9);
    });
  });

  group('exam wrappers', () {
    test('upsert then delete an exam', () async {
      await db.upsertSubject(subjectMap());
      await db.upsertExam({
        'id': 'e1',
        'userId': 'u1',
        'subjectId': 's1',
        'date': DateTime(2026, 7, 1).toIso8601String(),
        'label': 'Midterm',
      });
      expect(await db.examsForUser('u1'), hasLength(1));

      await db.deleteExam('e1');
      expect(await db.examsForUser('u1'), isEmpty);
    });
  });

  group('updateSchedule', () {
    test('writes only the supplied columns onto the existing row', () async {
      await db.scheduleDao.upsertSchedule(
        SchedulesCompanion.insert(
          id: 'sch1',
          userId: 'u1',
          dailyTargetHours: 2.0,
          enabledWindowIds: const ['morning'],
          aiReasoning: const Value('keep me'),
        ),
      );

      await db.updateSchedule({
        'id': 'sch1',
        'dailyTargetHours': 3.5,
        'enabledWindowIds': const ['evening'],
      });

      final sched = await db.scheduleForUser('u1');
      expect(sched!['dailyTargetHours'], 3.5);
      expect(sched['enabledWindowIds'], const ['evening']);
      // Untouched columns survive the partial update.
      expect(sched['aiReasoning'], 'keep me');
    });
  });

  group('deleteSubjectCascade', () {
    test('removes the subject + its exams and blocks, keeps materials '
        '(un-assigned)', () async {
      await db.upsertSubject(subjectMap(id: 's2'));
      await db.upsertExam({
        'id': 'e2',
        'userId': 'u1',
        'subjectId': 's2',
        'date': DateTime(2026, 7, 1).toIso8601String(),
        'label': null,
      });
      // A schedule + study block referencing the subject — the FK a bare delete
      // would trip.
      await db.scheduleDao.upsertSchedule(
        SchedulesCompanion.insert(
          id: 'sch1',
          userId: 'u1',
          dailyTargetHours: 2.0,
          enabledWindowIds: const [],
        ),
      );
      await db.replaceStudyBlocks('sch1', [
        TestBlock.sample(subjectId: 's2').toJson()..['scheduleId'] = 'sch1',
      ]);
      // A material attached to the subject — must survive as unsorted.
      await db.saveLibraryItem(
        LibraryItem(
          id: 'lib1',
          userId: 'u1',
          name: 'Notes.pdf',
          kind: ItemKind.pdf,
          fileSize: 1000,
          uploadedAt: DateTime(2026, 6, 1),
          processingStatus: ProcessingStatus.indexed,
          subjectId: 's2',
        ).toJson(),
      );

      await db.deleteSubjectCascade('s2');

      expect(await db.subjectsForUser('u1'), isEmpty);
      expect(await db.examsForUser('u1'), isEmpty);
      expect(await db.watchStudyBlocks('sch1').first, isEmpty);
      final mats = await db.libraryDao.getByUser('u1');
      expect(mats, hasLength(1));
      expect(mats.single.subjectId, isNull);
    });
  });
}
