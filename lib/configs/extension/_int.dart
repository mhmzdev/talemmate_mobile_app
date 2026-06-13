part of '../configs.dart';

extension SuperInt on int {
  double un() => AppUnit.un(this);
  double sp() => AppUnit.sp(this);
  double font() => AppUnit.font(this);

  BorderRadius radius() => BorderRadius.circular(toDouble());
  BorderRadius top() => BorderRadius.vertical(top: Radius.circular(toDouble()));
  BorderRadius bottom() =>
      BorderRadius.vertical(bottom: Radius.circular(toDouble()));

  /// Formats a byte count as a human-readable size (KB → MB → GB).
  String get readableSize {
    final kb = this / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(0)} KB';
    final mb = kb / 1024;
    if (mb < 1024) return '${mb.toStringAsFixed(1)} MB';
    return '${(mb / 1024).toStringAsFixed(1)} GB';
  }
}
