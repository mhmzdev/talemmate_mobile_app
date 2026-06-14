import 'dart:convert';

class AliceHttpResponse {
  int? status = 0;
  int size = 0;
  DateTime time = DateTime.now();
  dynamic body;
  Map<String, String>? headers;

  Map<String, dynamic> toJson() => {
        'status': status,
        'size': size,
        'time': time.toUtc().toIso8601String(),
        'body': _bodyAsJson(body),
        'headers': headers,
      };

  static dynamic _bodyAsJson(dynamic body) {
    if (body == null) return null;
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
