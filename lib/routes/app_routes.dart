import 'package:go_router/go_router.dart';
import 'package:quanthex/data/Models/mining/mining_dto.dart';
import 'package:quanthex/data/Models/staking/staking_payload.dart';
import 'package:quanthex/data/Models/wallets/wallet_model.dart';
import 'package:quanthex/views/change_password_view.dart';
import 'package:quanthex/views/auth/create_account/create_account_view.dart';
import 'package:quanthex/views/coin_view/ethereum_detail_view.dart';
import 'package:quanthex/views/general_settings_view.dart';
import 'package:quanthex/views/home/home_page.dart';
import 'package:quanthex/views/landing_view.dart';
import 'package:quanthex/views/auth/sign_in/login_view.dart';
import 'package:quanthex/views/mining/subscription_package.dart';
import 'package:quanthex/views/notifications/notification_list_view.dart';
import 'package:quanthex/views/notifications_view.dart';
import 'package:quanthex/views/otp/model/otp_args.dart';
import 'package:quanthex/views/qr_scan_view.dart';
import 'package:quanthex/views/receipt_view.dart';
import 'package:quanthex/views/receive/receive_view.dart';
import 'package:quanthex/views/referr_and_earn/refer_earn_view.dart';
import 'package:quanthex/views/settings/security_privacy_view.dart';
import 'package:quanthex/views/send/send_token_view.dart';
import 'package:quanthex/views/settings/pin/set_pin_view.dart';
import 'package:quanthex/views/settings/pin/set_new_pin_view.dart';
import 'package:quanthex/views/settings/settings_view.dart';
import 'package:quanthex/views/settings/pin/verify_current_pin_view.dart';
import 'package:quanthex/views/staking/staking_view.dart';
import 'package:quanthex/views/staking/subscribe_staking_view.dart';
import 'package:quanthex/views/mining/subscribe_view.dart';
import 'package:quanthex/views/swap/swap_token_view.dart';
import 'package:quanthex/views/transaction_history_view.dart';
import 'package:quanthex/views/transactions_records_view.dart';
import 'package:quanthex/views/otp/verify_view.dart';
import 'package:quanthex/views/wallets/backup_seed_phrase_view.dart';
import 'package:quanthex/views/wallets/import_wallet_view.dart';
import 'package:quanthex/views/wallets/seed_phrase_view.dart';
import 'package:quanthex/views/wallets/setup_wallet_view.dart';
import 'package:quanthex/views/wallets/wallets_view.dart';
import 'package:quanthex/views/withdrawals_view.dart';

import '../data/Models/assets/supported_assets.dart';
import '../data/Models/mining/subscription_payload.dart';
import '../views/mining/mining_view.dart';
import '../views/splash/splash_screen.dart';
import '../views/transaction/transaction_details_view.dart';

class AppRoutes {
  static String splash = '/';
  static String landingview = '/landingview';
  static String loginview = '/loginview';
  static String createaccountview = '/createaccountview';
  static String verifyview = '/verifyview';
  static String setupwalletview = '/setupwalletview';
  static String importwalletview = '/importwalletview';
  static String seedphraseview = '/seedphraseview';
  static String backupseedphraseview = '/backupseedphraseview';
  static String setpinview = '/setpinview';
  static String homepage = '/homepage';
  static String transactionhistoryview = '/transactionhistoryview';
  static String transactionsrecordsview = '/transactionsrecordsview';
  static String receiptview = '/receiptview';
  static String transactiondetailsview = '/transactiondetailsview';
  static String qrscanview = '/qrscanview';
  static String swaptokenview = '/swaptokenview';
  static String ethereumdetailview = '/ethereumdetailview';
  static String sendtokenview = '/sendtokenview';
  static String receiveview = '/receiveview';
    static String packageview = '/packageview';

  static String miningview = '/miningview';
  static String subscribeview = '/subscribeview';
  static String stakingview = '/stakingview';
  static String subscribestakingview = '/subscribestakingview';
  static String settingsview = '/settingsview';
  static String walletsview = '/walletsview';
  static String notificationsview = '/notificationsview';
  static String notificationlistview = '/notificationlistview';
  static String changepasswordview = '/changepasswordview';
  static String generalsettingsview = '/generalsettingsview';
  static String securityprivacyview = '/securityprivacyview';
  static String referearnview = '/referearnview';
  static String withdrawalsview = '/withdrawalsview';
  static String verifycurrentpinview = '/verifycurrentpinview';
  static String setnewpinview = '/setnewpinview';

  static final router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(path: splash, builder: (context, state) => SplashScreen()),
      GoRoute(path: landingview, builder: (context, state) => LandingView()),
      GoRoute(path: loginview, builder: (context, state) => LoginView()),
      GoRoute(path: createaccountview, builder: (context, state) => CreateAccountView()),
      GoRoute(
        path: verifyview,
        builder: (context, state) {
          final args = state.extra as OtpArgs;
          return VerifyView(args: args);
        },
      ),
      GoRoute(path: setupwalletview, builder: (context, state) => SetupWalletView()),
      GoRoute(path: importwalletview, builder: (context, state) => ImportWalletView()),
      GoRoute(
        path: seedphraseview,
        builder: (context, state) {
          final args = state.extra as WalletModel;
          return SeedPhraseView(wallet: args);
        },
      ),
      GoRoute(
        path: backupseedphraseview,
        builder: (context, state) {
          final args = state.extra as WalletModel;
          return BackupSeedPhraseView(wallet: args);
        },
      ),
      GoRoute(
        path: setpinview,
        builder: (context, state) {
          bool import = state.extra as bool;
          return SetPinView(isImport: import);
        },
      ),
      GoRoute(path: homepage, builder: (context, state) => HomePage()),
      GoRoute(path: transactionhistoryview, builder: (context, state) => TransactionHistoryView()),
      GoRoute(path: transactionsrecordsview, builder: (context, state) => TransactionsRecordsView()),
      GoRoute(path: receiptview, builder: (context, state) => ReceiptView()),
      GoRoute(
        path: transactiondetailsview,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return TransactionDetailsView(
            amount: args['amount'] as String,
            tokenSymbol: args['tokenSymbol'] as String,
            fromAddress: args['fromAddress'] as String,
            toAddress: args['toAddress'] as String,
            fromLabel: args['fromLabel'] as String?,
            toLabel: args['toLabel'] as String?,
            networkFee: args['networkFee'] as String,
            networkSymbol: args['networkSymbol'] as String,
            transactionHash: args['transactionHash'] as String,
            blockNumber: args['blockNumber'] as String,
            timestamp: args['timestamp'] as String,
            walletName: args['walletName'] as String?,
            isReceive: args['isReceive'] as bool? ?? false,
            isSuccess: args['isSuccess'] as bool? ?? true,
            networkName: args['networkName'] as String?,
          );
        },
      ),
      GoRoute(path: qrscanview, builder: (context, state) => QRScanView()),
      GoRoute(path: swaptokenview, builder: (context, state) => SwapTokenView()),
      GoRoute(
        path: ethereumdetailview,
        builder: (context, state) {
          final args = state.extra as SupportedCoin;
          return EthereumDetailView(coin: args);
        },
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
      GoRoute(path: miningview, builder: (context, state) {
        final args = state.extra as MiningDto;
        return MiningView(mining: args);
      }),
      GoRoute(path: packageview, builder: (context, state) => SubscriptionPackage()),
      GoRoute(
        path: subscribeview,
        builder: (context, state) {
          final args = state.extra as Map;
          SubscriptionPayload subscriptionDto = args["data"] as SubscriptionPayload;
          SupportedCoin paymentToken = args["payment_token"] as SupportedCoin;
          return SubscribeView(payload: subscriptionDto, paymentToken: paymentToken);
        },
      ),
      GoRoute(path: stakingview, builder: (context, state) => StakingView()),
      GoRoute(
        path: subscribestakingview,
        builder: (context, state) {
          final args = state.extra as Map;
          StakingPayload payload = args["data"] as StakingPayload;
          SupportedCoin paymentToken = args["payment_token"] as SupportedCoin;
          return SubscribeStakingView(payload: payload, paymentToken: paymentToken);
        },
      ),
      GoRoute(path: settingsview, builder: (context, state) => SettingsView()),
      GoRoute(path: walletsview, builder: (context, state) => WalletsView()),
      GoRoute(path: notificationsview, builder: (context, state) => NotificationsView()),
      GoRoute(path: notificationlistview, builder: (context, state) => NotificationListView()),
      GoRoute(path: changepasswordview, builder: (context, state) => ChangePasswordView()),
      GoRoute(path: generalsettingsview, builder: (context, state) => GeneralSettingsView()),
      GoRoute(path: securityprivacyview, builder: (context, state) => SecurityPrivacyView()),
      GoRoute(path: verifycurrentpinview, builder: (context, state) => VerifyCurrentPinView()),
      GoRoute(path: setnewpinview, builder: (context, state) => SetNewPinView()),
      GoRoute(path: referearnview, builder: (context, state) => ReferEarnView()),
      GoRoute(path: withdrawalsview, builder: (context, state) => WithdrawalsView()),
    ],
  );
}
