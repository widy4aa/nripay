import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nirpay/core/router/app_router.dart';
import 'package:nirpay/core/theme/app_theme.dart';

class NirpayApp extends ConsumerWidget {
  const NirpayApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Nirpay',
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}
