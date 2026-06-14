import 'package:dio/dio.dart';
import 'package:firebase_performance_dio/firebase_performance_dio.dart';

import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/services/flavor/flavor.dart';
import 'package:taleemmate/services/http/alice.dart';
import 'package:taleemmate/services/logging/app_log.dart';

part 'urls.dart';
part 'endpoints.dart';

part 'interceptors/retry_interceptor.dart';

abstract class BaseApi {
  final String baseUrl;
  late final Dio ins;

  BaseApi(this.baseUrl) {
    ins = Dio(
      BaseOptions(
        contentType: 'application/json',
        connectTimeout: 1.minutes,
        receiveTimeout: 1.minutes,
        baseUrl: baseUrl,
        headers: {
          'accept': 'application/json',
        },
      ),
    );
    ins.interceptors.add(_RetryInterceptor(ins));
    ins.interceptors.add(DioFirebasePerformanceInterceptor());
    if (!AppFlavor.isProdRelease) {
      ins.interceptors.add(AppAlice.ins.getDioInterceptor());
    }
  }
}

class Api extends BaseApi {
  Api() : super(URLs.base);
}
