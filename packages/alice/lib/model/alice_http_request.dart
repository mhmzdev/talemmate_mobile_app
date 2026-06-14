import 'dart:convert';
import 'dart:io';

import 'package:alice/model/alice_form_data_file.dart';
import 'package:alice/model/alice_from_data_field.dart';

class AliceHttpRequest {
  int size = 0;
  DateTime time = DateTime.now();
  Map<String, dynamic> headers = <String, dynamic>{};
  dynamic body = "";
  String? contentType = "";
  List<Cookie> cookies = [];
  Map<String, dynamic> queryParameters = <String, dynamic>{};
  List<AliceFormDataFile>? formDataFiles;
  List<AliceFormDataField>? formDataFields;

  Map<String, dynamic> toJson() => {
        'time': time.toUtc().toIso8601String(),
        'size': size,
        'contentType': contentType,
        'headers': headers,
        'body': _bodyAsJson(body),
        'queryParameters': queryParameters,
      };

  static dynamic _bodyAsJson(dynamic body) {
    if (body == null || body == '') return null;
    if (body is Map || body is List) return body;
    if (body is String) {
      try {
        return jsonDecode(body);
      } catch (_) {
        return body;
      }
    }
    return body.toString();
  }
}
