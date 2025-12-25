import 'package:go_router/go_router.dart';
import 'package:quanthex/data/Models/subscription/subscription_dto.dart';
import 'package:quanthex/data/Models/wallets/wallet_model.dart';
import 'package:quanthex/views/change_password_view.dart';
import 'package:quanthex/views/auth/create_account/create_account_view.dart';
import 'package:quanthex/views/ethereum_detail_view.dart';
import 'package:quanthex/views/general_settings_view.dart';
import 'package:quanthex/views/home/home_page.dart';
import 'package:quanthex/views/home/home_view.dart';
import 'package:quanthex/views/landing_view.dart';
import 'package:quanthex/views/auth/sign_in/login_view.dart';
import 'package:quanthex/views/notifications_view.dart';
import 'package:quanthex/views/qr_scan_view.dart';
import 'package:quanthex/views/receipt_view.dart';
import 'package:quanthex/views/receive/receive_view.dart';
import 'package:quanthex/views/referr_and_earn/refer_earn_view.dart';
import 'package:quanthex/views/security_privacy_view.dart';
import 'package:quanthex/views/send/send_token_view.dart';
import 'package:quanthex/views/set_pin_view.dart';
import 'package:quanthex/views/settings_view.dart';
import 'package:quanthex/views/staking_view.dart';
import 'package:quanthex/views/subscribe_staking_view.dart';
import 'package:quanthex/views/subscribe_view.dart';
import 'package:quanthex/views/swap_token_view.dart';
import 'package:quanthex/views/transaction_history_view.dart';
import 'package:quanthex/views/transactions_records_view.dart';
import 'package:quanthex/views/verify_view.dart';
import 'package:quanthex/views/wallets/import_wallet_view.dart';
import 'package:quanthex/views/wallets/seed_phrase_view.dart';
import 'package:quanthex/views/wallets/setup_wallet_view.dart';
import 'package:quanthex/views/wallets/wallets_view.dart';

import '../data/Models/assets/supported_assets.dart';
import '../data/Models/mining/subscription_payload.dart';
import '../views/mining/mining_view.dart';
import '../views/splash/splash_screen.dart';

class AppRoutes{

  static String splash='/';
  static String landingview='/landingview';
  static String loginview='/loginview';
  static String createaccountview='/createaccountview';
  static String verifyview='/verifyview';
  static String setupwalletview='/setupwalletview';
  static String importwalletview='/importwalletview';
  static String seedphraseview='/seedphraseview';
  static String setpinview='/setpinview';
  static String homepage='/homepage';
  static String transactionhistoryview='/transactionhistoryview';
  static String transactionsrecordsview='/transactionsrecordsview';
  static String receiptview='/receiptview';
  static String qrscanview='/qrscanview';
  static String swaptokenview='/swaptokenview';
  static String ethereumdetailview='/ethereumdetailview';
  static String sendtokenview='/sendtokenview';
  static String receiveview='/receiveview';
  static String miningview='/miningview';
  static String subscribeview='/subscribeview';
  static String stakingview='/stakingview';
  static String subscribestakingview='/subscribestakingview';
  static String settingsview='/settingsview';
  static String walletsview='/walletsview';
  static String notificationsview='/notificationsview';
  static String changepasswordview='/changepasswordview';
  static String generalsettingsview='/generalsettingsview';
  static String securityprivacyview='/securityprivacyview';
  static String referearnview='/referearnview';


  static final router=GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) =>  SplashScreen(),
      ),
      GoRoute(
        path: landingview,
        builder: (context, state) =>  LandingView(),
      ),
      GoRoute(
        path: loginview,
        builder: (context, state) =>  LoginView(),
      ),
      GoRoute(
        path: createaccountview,
        builder: (context, state) =>  CreateAccountView(),
      ),
      GoRoute(
        path: verifyview,
        builder: (context, state) =>  VerifyView(),
      ),
      GoRoute(
        path: setupwalletview,
        builder: (context, state) =>  SetupWalletView(),
      ),
      GoRoute(
        path: importwalletview,
        builder: (context, state) =>  ImportWalletView(),
      ),
      GoRoute(
        path: seedphraseview,
        builder: (context, state){
          final args = state.extra as WalletModel;
          return SeedPhraseView(wallet: args);
        },
      ),
      GoRoute(
        path: setpinview,
        builder: (context, state) {
          bool import = state.extra as bool;
          return SetPinView(isImport: import);
        },
      ),
      GoRoute(
        path: homepage,
        builder: (context, state) =>  HomePage(),
      ),
      GoRoute(
        path: transactionhistoryview,
        builder: (context, state) =>  TransactionHistoryView(),
      ),
      GoRoute(
        path: transactionsrecordsview,
        builder: (context, state) =>  TransactionsRecordsView(),
      ),
      GoRoute(
        path: receiptview,
        builder: (context, state) =>  ReceiptView(),
      ),
      GoRoute(
        path: qrscanview,
        builder: (context, state) =>  QRScanView(),
      ),
      GoRoute(
        path: swaptokenview,
        builder: (context, state) =>  SwapTokenView(),
      ),
      GoRoute(
        path: ethereumdetailview,
        builder: (context, state) =>  EthereumDetailView(),
      ),
      GoRoute(
        path: sendtokenview,
        builder: (context, state) {
          final args = state.extra as SupportedCoin;
          return SendTokenView(coin: args);
        },
      ),
      GoRoute(
        path: receiveview,
        builder: (context, state) {
          final args = state.extra as SupportedCoin;
          return ReceiveView(coin: args);
        },
      ),
      GoRoute(
        path: miningview,
        builder: (context, state) =>  MiningView(),
      ),
      GoRoute(
        path: subscribeview,
        builder: (context, state) {
          final args = state.extra as Map;
          SubscriptionPayload subscriptionDto=args["data"] as SubscriptionPayload;
          SupportedCoin paymentToken=args["payment_token"] as SupportedCoin;
          return SubscribeView(payload: subscriptionDto,paymentToken: paymentToken,);
        },
      ),
      GoRoute(
        path: stakingview,
        builder: (context, state) =>  StakingView(),
      ),
      GoRoute(
        path: subscribestakingview,
        builder: (context, state) =>  SubscribeStakingView(),
      ),
      GoRoute(
        path: settingsview,
        builder: (context, state) =>  SettingsView(),
      ),
      GoRoute(
        path: walletsview,
        builder: (context, state) =>  WalletsView(),
      ),
      GoRoute(
        path: notificationsview,
        builder: (context, state) =>  NotificationsView(),
      ),
      GoRoute(
        path: changepasswordview,
        builder: (context, state) =>  ChangePasswordView(),
      ),
      GoRoute(
        path: generalsettingsview,
        builder: (context, state) =>  GeneralSettingsView(),
      ),
      GoRoute(
        path: securityprivacyview,
        builder: (context, state) =>  SecurityPrivacyView(),
      ),
      GoRoute(
        path: referearnview,
        builder: (context, state) =>  ReferEarnView(),
      ),
    ]
  );
}