part of 'user_repo.dart';

class _UserProvider {
  static Future<UserData> init() async {
    try {
      final raw = <String, dynamic>{};
      return UserData.fromJson(raw);
    } catch (e, st) {
      if (e is DioException) {
        throw HttpFault.fromDioException(e, st);
      }
      throw UnknownFault('Something went wrong!', st);
    }
  }

  static Future<UserData> login(Map<String, dynamic> values) async {
    try {
      final email = values['email'] as String;
      final password = values['password'] as String;

      final raw = await _UserMocks.login(email: email, password: password);
      return UserData.fromJson(raw);
    } catch (e, st) {
      if (e is Fault) rethrow;
      if (e is DioException) throw HttpFault.fromDioException(e, st);
      throw UnknownFault('Something went wrong!', st);
    }
  }

  static Future<UserData> update() async {
    try {
      final raw = <String, dynamic>{};
      return UserData.fromJson(raw);
    } catch (e, st) {
      if (e is DioException) {
        throw HttpFault.fromDioException(e, st);
      }
      throw UnknownFault('Something went wrong!', st);
    }
  }

  static Future<UserData> fetch() async {
    try {
      final raw = <String, dynamic>{};
      return UserData.fromJson(raw);
    } catch (e, st) {
      if (e is DioException) {
        throw HttpFault.fromDioException(e, st);
      }
      throw UnknownFault('Something went wrong!', st);
    }
  }

  static Future<UserData> forgot() async {
    try {
      final raw = <String, dynamic>{};
      return UserData.fromJson(raw);
    } catch (e, st) {
      if (e is DioException) {
        throw HttpFault.fromDioException(e, st);
      }
      throw UnknownFault('Something went wrong!', st);
    }
  }

  static Future<UserData> logout() async {
    try {
      final raw = <String, dynamic>{};
      return UserData.fromJson(raw);
    } catch (e, st) {
      if (e is DioException) {
        throw HttpFault.fromDioException(e, st);
      }
      throw UnknownFault('Something went wrong!', st);
    }
  }

  static Future<UserData> deleteAccount() async {
    try {
      final raw = <String, dynamic>{};
      return UserData.fromJson(raw);
    } catch (e, st) {
      if (e is DioException) {
        throw HttpFault.fromDioException(e, st);
      }
      throw UnknownFault('Something went wrong!', st);
    }
  }
}
