import 'dart:convert';
import 'dart:io';

import 'package:alice/model/alice_http_call.dart';
import 'package:path_provider/path_provider.dart';

class AliceQAExportHelper {
  static const String _fileName = 'alice_qa_export.json';
  static const JsonEncoder _encoder = JsonEncoder.withIndent('  ');

  static Future<void> export(List<AliceHttpCall> calls) async {
    try {
      final dir = Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory();
      if (dir == null) return;

      final completedCalls = calls.where((c) => !c.loading).toList();
      final data = {
        'exportedAt': DateTime.now().toUtc().toIso8601String(),
        'callCount': completedCalls.length,
        'calls': completedCalls.map((c) => c.toJson()).toList(),
      };

      final file = File('${dir.path}/$_fileName');
      await file.writeAsString(_encoder.convert(data));
    } catch (_) {}
  }

  static String get fileName => _fileName;
}
