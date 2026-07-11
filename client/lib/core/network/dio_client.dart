import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nirpay/core/config/app_config.dart';
import 'package:nirpay/core/constants/app_constants.dart';
import 'package:nirpay/core/providers/app_providers.dart';
import 'package:nirpay/core/services/app_logger.dart';

class DioClient {
  DioClient._(this.dio);

  final Dio dio;

  factory DioClient.create(AppConfig config, Logger logger) {
    final dio = Dio(
      BaseOptions(
        baseUrl: config.apiBaseUrl,
        connectTimeout: AppConstants.networkTimeout,
        receiveTimeout: AppConstants.networkTimeout,
      ),
    );

    if (kDebugMode && config.enableNetworkLogs) {
      dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          logger.e('Dio error', error: error, stackTrace: error.stackTrace);
          handler.next(error);
        },
      ),
    );

    return DioClient._(dio);
  }
}

final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  final logger = ref.watch(appLoggerProvider);

  return DioClient.create(config, logger).dio;
});
