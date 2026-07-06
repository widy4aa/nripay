import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nirpay/features/auth/presentation/pages/login_page.dart';
import 'package:nirpay/features/auth/presentation/pages/register_step1_page.dart';
import 'package:nirpay/features/auth/presentation/pages/register_step2_page.dart';
import 'package:nirpay/features/auth/presentation/pages/register_step3_page.dart';
import 'package:nirpay/features/auth/presentation/pages/register_step4_page.dart';
import 'package:nirpay/features/auth/presentation/pages/register_step5_page.dart';
import 'package:nirpay/features/sync/presentation/pages/status_sync_page.dart';
import 'package:nirpay/features/transaction/presentation/pages/nfc_transfer_page.dart';
import 'package:nirpay/features/transaction/presentation/pages/receive_money_page.dart';
import 'package:nirpay/features/transaction/presentation/pages/send_money_page.dart';
import 'package:nirpay/features/wallet/presentation/pages/device_status_page.dart';
import 'package:nirpay/features/wallet/presentation/pages/home_page.dart';

class AppRoutePaths {
  static const String wallet = '/wallet';
  static const String sendMoney = '/send-money';
  static const String nfcTransfer = '/nfc-transfer';
  static const String receiveMoney = '/receive-money';
  static const String statusSync = '/status-sync';
  static const String settings = '/settings';
  static const String deviceStatus = '/device-status';
  static const String login = '/login';
  static const String registerStep1 = '/register-step-1';
  static const String registerStep2 = '/register-step-2';
  static const String registerStep3 = '/register-step-3';
  static const String registerStep4 = '/register-step-4';
  static const String registerStep5 = '/register-step-5';

  const AppRoutePaths._();
}

class AppRouteNames {
  static const String wallet = 'wallet';
  static const String sendMoney = 'sendMoney';
  static const String nfcTransfer = 'nfcTransfer';
  static const String receiveMoney = 'receiveMoney';
  static const String statusSync = 'statusSync';
  static const String settings = 'settings';
  static const String deviceStatus = 'deviceStatus';
  static const String login = 'login';
  static const String registerStep1 = 'registerStep1';
  static const String registerStep2 = 'registerStep2';
  static const String registerStep3 = 'registerStep3';
  static const String registerStep4 = 'registerStep4';
  static const String registerStep5 = 'registerStep5';

  const AppRouteNames._();
}

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutePaths.login,
    routes: [
      GoRoute(
        path: AppRoutePaths.login,
        name: AppRouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutePaths.registerStep1,
        name: AppRouteNames.registerStep1,
        builder: (context, state) => const RegisterStep1Page(),
      ),
      GoRoute(
        path: AppRoutePaths.registerStep2,
        name: AppRouteNames.registerStep2,
        builder: (context, state) => const RegisterStep2Page(),
      ),
      GoRoute(
        path: AppRoutePaths.registerStep3,
        name: AppRouteNames.registerStep3,
        builder: (context, state) => const RegisterStep3Page(),
      ),
      GoRoute(
        path: AppRoutePaths.registerStep4,
        name: AppRouteNames.registerStep4,
        builder: (context, state) => const RegisterStep4Page(),
      ),
      GoRoute(
        path: AppRoutePaths.registerStep5,
        name: AppRouteNames.registerStep5,
        builder: (context, state) => const RegisterStep5Page(),
      ),
      GoRoute(
        path: AppRoutePaths.wallet,
        name: AppRouteNames.wallet,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutePaths.sendMoney,
        name: AppRouteNames.sendMoney,
        builder: (context, state) => const SendMoneyPage(),
      ),
      GoRoute(
        path: AppRoutePaths.nfcTransfer,
        name: AppRouteNames.nfcTransfer,
        builder: (context, state) => const NfcTransferPage(),
      ),
      GoRoute(
        path: AppRoutePaths.statusSync,
        name: AppRouteNames.statusSync,
        builder: (context, state) => const StatusSyncPage(),
      ),
      GoRoute(
        path: AppRoutePaths.receiveMoney,
        name: AppRouteNames.receiveMoney,
        builder: (context, state) => const ReceiveMoneyPage(),
      ),
      GoRoute(
        path: AppRoutePaths.settings,
        name: AppRouteNames.settings,
        builder: (context, state) => const _SettingsPlaceholderPage(),
      ),
      GoRoute(
        path: AppRoutePaths.deviceStatus,
        name: AppRouteNames.deviceStatus,
        builder: (context, state) => const DeviceStatusPage(),
      ),
    ],
    errorBuilder: (context, state) => _RouterErrorPage(error: state.error),
  );
});

class _RouterErrorPage extends StatelessWidget {
  const _RouterErrorPage({this.error});

  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Route error: ${error ?? 'Unknown error'}')),
    );
  }
}

class _SettingsPlaceholderPage extends StatelessWidget {
  const _SettingsPlaceholderPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Settings')));
  }
}
