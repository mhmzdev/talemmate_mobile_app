import 'package:dio/dio.dart';

import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/services/flavor/flavor.dart';
import 'package:taleemmate/services/http/alice.dart';

part 'urls.dart';
part 'endpoints.dart';

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
    if (!AppFlavor.isProdRelease) {
      ins.interceptors.add(AppAlice.ins.getDioInterceptor());
    }
  }
}

class Api extends BaseApi {
  Api() : super(URLs.base);
}
