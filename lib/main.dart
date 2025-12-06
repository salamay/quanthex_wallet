import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/views/change_password_view.dart';
import 'package:quanthex/views/create_account_view.dart';
import 'package:quanthex/views/ethereum_detail_view.dart';
import 'package:quanthex/views/general_settings_view.dart';
import 'package:quanthex/views/home_view.dart';
import 'package:quanthex/views/import_wallet_view.dart';
import 'package:quanthex/views/landing_view.dart';
import 'package:quanthex/views/login_view.dart';
import 'package:quanthex/views/mining_view.dart';
import 'package:quanthex/views/notifications_view.dart';
import 'package:quanthex/views/qr_scan_view.dart';
import 'package:quanthex/views/receipt_view.dart';
import 'package:quanthex/views/receive_view.dart';
import 'package:quanthex/views/refer_earn_view.dart';
import 'package:quanthex/views/security_privacy_view.dart';
import 'package:quanthex/views/seed_phrase_view.dart';
import 'package:quanthex/views/send_token_view.dart';
import 'package:quanthex/views/set_pin_view.dart';
import 'package:quanthex/views/settings_view.dart';
import 'package:quanthex/views/setup_wallet_view.dart';
import 'package:quanthex/views/splash_screen.dart';
import 'package:quanthex/views/staking_view.dart';
import 'package:quanthex/views/subscribe_staking_view.dart';
import 'package:quanthex/views/subscribe_view.dart';
import 'package:quanthex/views/swap_token_view.dart';
import 'package:quanthex/views/transaction_history_view.dart';
import 'package:quanthex/views/transactions_records_view.dart';
import 'package:quanthex/views/verify_view.dart';
import 'package:quanthex/views/wallets_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      child: MaterialApp(
        title: 'Quanthex',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/landingview': (context) => const LandingView(),
          '/loginview': (context) => const LoginView(),
          '/createaccountview': (context) => const CreateAccountView(),
          '/verifyview': (context) => const VerifyView(),
          '/setupwalletview': (context) => const SetupWalletView(),
          '/importwalletview': (context) => const ImportWalletView(),
          '/seedphraseview': (context) => const SeedPhraseView(),
          '/setpinview': (context) => const SetPinView(),
          '/homeview': (context) => const HomeView(),
          '/transactionhistoryview': (context) =>
              const TransactionHistoryView(),
          '/transactionsrecordsview': (context) =>
              const TransactionsRecordsView(),
          '/receiptview': (context) => const ReceiptView(),
          '/qrscanview': (context) => const QRScanView(),
          '/swaptokenview': (context) => const SwapTokenView(),
          '/ethereumdetailview': (context) => const EthereumDetailView(),
          '/sendtokenview': (context) => const SendTokenView(),
          '/receiveview': (context) => const ReceiveView(),
          '/miningview': (context) => const MiningView(),
          '/subscribeview': (context) => const SubscribeView(),
          '/stakingview': (context) => const StakingView(),
          '/subscribestakingview': (context) => const SubscribeStakingView(),
          '/settingsview': (context) => const SettingsView(),
          '/walletsview': (context) => const WalletsView(),
          '/notificationsview': (context) => const NotificationsView(),
          '/changepasswordview': (context) => const ChangePasswordView(),
          '/generalsettingsview': (context) => const GeneralSettingsView(),
          '/securityprivacyview': (context) => const SecurityPrivacyView(),
          '/referearnview': (context) => const ReferEarnView(),
        },
      ),
    );
  }
}
