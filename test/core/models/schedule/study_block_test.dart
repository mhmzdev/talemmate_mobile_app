import 'package:flutter_test/flutter_test.dart';
import 'package:taleemmate/core/models/schedule/study_block.dart';

import '../../../helpers/fixtures.dart';

void main() {
  group('StudyBlock.effectiveStatus', () {
    test('a manual completion (stored done) sticks regardless of the clock',
        () {
      // A block in the future whose stored status is done — the Focus session's
      // "Mark block done" path. The clock would say "upcoming", but the manual
      // completion must win.
      final block = TestBlock.sample(
        date: DateTime(2026, 6, 18),
        startTime: '23:30',
        durationMinutes: 60,
        status: BlockStatus.done,
      );

      final now = DateTime(2026, 6, 18, 10, 0); // well before the block
      expect(block.effectiveStatus(now), BlockStatus.done);
    });

    test('an upcoming block in the future reads upcoming from the clock', () {
      final block = TestBlock.sample(
        date: DateTime(2026, 6, 18),
        startTime: '23:30',
        durationMinutes: 60,
        status: BlockStatus.upcoming,
      );

      final now = DateTime(2026, 6, 18, 10, 0);
      expect(block.effectiveStatus(now), BlockStatus.upcoming);
    });

    test('a block whose window is in progress reads now', () {
      final block = TestBlock.sample(
        date: DateTime(2026, 6, 18),
        startTime: '10:00',
        durationMinutes: 60,
        status: BlockStatus.upcoming,
      );

      final now = DateTime(2026, 6, 18, 10, 30); // inside the window
      expect(block.effectiveStatus(now), BlockStatus.now);
    });

    test('a past window reads done from the clock even when stored upcoming',
        () {
      final block = TestBlock.sample(
        date: DateTime(2026, 6, 18),
        startTime: '10:00',
        durationMinutes: 60,
        status: BlockStatus.upcoming,
      );

      final now = DateTime(2026, 6, 18, 12, 0); // after the window
      expect(block.effectiveStatus(now), BlockStatus.done);
    });
  });
}
