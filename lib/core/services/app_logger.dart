import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class AppLogger {
  const AppLogger._();

  static Logger create() {
    return Logger(
      filter: kReleaseMode ? ProductionFilter() : DevelopmentFilter(),
      printer: PrettyPrinter(methodCount: kReleaseMode ? 0 : 2),
    );
  }
}

final appLoggerProvider = Provider<Logger>((ref) => AppLogger.create());
