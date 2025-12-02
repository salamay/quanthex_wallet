import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/views/create_account_view.dart';
import 'package:quanthex/views/landing_view.dart';
import 'package:quanthex/views/login_view.dart';
import 'package:quanthex/views/splash_screen.dart';
import 'package:quanthex/views/verify_view.dart';

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
        },
      ),
    );
  }
}
