import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/data/controllers/notification/notification_controller.dart';
import 'package:quanthex/data/controllers/swap/swap_controller.dart';
import 'package:quanthex/data/services/notification/fcm_service.dart';
import 'package:quanthex/data/services/notification/notification_service.dart';
import 'package:quanthex/routes/app_routes.dart';
import 'package:quanthex/widgets/loading_overlay/loading.dart';

import 'data/controllers/assets/asset_controller.dart';
import 'data/controllers/balance/balance_controller.dart';
import 'data/controllers/home/home_controller.dart';
import 'data/controllers/mining/mining_controller.dart';
import 'data/controllers/user/user_controller.dart';
import 'data/controllers/wallet_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initHiveForFlutter();
  await NotificationService.getInstance().initNotification();
  FirebaseMessaging.onBackgroundMessage(FcmService.firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(FcmService.firebaseMessagingOnForegroundMessageHandler);
  FirebaseMessaging.onMessageOpenedApp.listen(FcmService.firebaseMessagingOnMessageOpenedApHandler);
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  // // Catch async/dart errors
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: false);
  //   return true;
  // };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WalletController()),
        ChangeNotifierProvider(create: (_) => BalanceController()),
        ChangeNotifierProvider(create: (_) => AssetController()),
        ChangeNotifierProvider(create: (_) => HomeController()),
        ChangeNotifierProvider(create: (_) => MiningController()),
        ChangeNotifierProvider(create: (_) => UserController()),
        ChangeNotifierProvider(create: (_) => SwapController()),
        ChangeNotifierProvider(create: (_) => NotificationController()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        child: GlobalLoaderOverlay(
          overlayColor: Colors.transparent,
          overlayWholeScreen: true,

          overlayWidgetBuilder: (context) =>
              Center(child: Loading(size: 30.sp)),
          child: MaterialApp.router(
            title: 'Quanthex',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            routerConfig: AppRoutes.router,
          ),
        ),
      ),
    );
  }
}
