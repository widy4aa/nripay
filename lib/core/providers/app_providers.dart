import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nirpay/core/config/app_config.dart';

part 'app_providers.g.dart';

@riverpod
AppConfig appConfig(AppConfigRef ref) => currentAppConfig;
