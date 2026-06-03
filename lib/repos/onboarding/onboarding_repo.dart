import 'package:dio/dio.dart';
import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/services/fault/faults.dart';

part 'onboarding_mocks.dart';
part 'onboarding_parser.dart';
part 'onboarding_data_provider.dart';

class OnboardingRepo {
  static final OnboardingRepo _instance = OnboardingRepo._();
  OnboardingRepo._();

  static OnboardingRepo get ins => _instance;

  /// --- repo functions --- ///

  Future<Map<String, dynamic>> save(Map<String, dynamic> values) =>
      _OnboardingProvider.save(values);

  Future<Map<String, dynamic>> complete(Map<String, dynamic> values) =>
      _OnboardingProvider.complete(values);
}
