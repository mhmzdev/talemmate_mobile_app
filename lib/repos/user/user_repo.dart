import 'package:dio/dio.dart';
import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/core/models/user/user.dart';
import 'package:taleemmate/services/fault/faults.dart';

part 'user_mocks.dart';
part 'user_parser.dart';
part 'user_data_provider.dart';

class UserRepo {
  static final UserRepo _instance = UserRepo._();
  UserRepo._();

  static UserRepo get ins => _instance;

  /// --- repo functions --- ///

  Future<UserData> init() => _UserProvider.init();

  Future<UserData> login(Map<String, dynamic> values) =>
      _UserProvider.login(values);

  Future<UserData> update() => _UserProvider.update();

  Future<UserData> fetch() => _UserProvider.fetch();

  Future<UserData> forgot() => _UserProvider.forgot();

  Future<UserData> logout() => _UserProvider.logout();

  Future<UserData> deleteAccount() => _UserProvider.deleteAccount();
}
