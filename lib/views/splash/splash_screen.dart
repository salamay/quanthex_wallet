import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:quanthex/data/services/auth/auth_service.dart';
import 'package:quanthex/data/utils/home_nav_resolver.dart';

import '../../routes/app_routes.dart';
import '../../data/utils/navigator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((e)async{
      await AuthService.getInstance().initializeGoogleSignIn();
      Timer(const Duration(seconds: 2), () {
        HomeNavResolver.resolveHomeRoute(context);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/splash.png'), //landingbgimage
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: Image.asset('assets/images/splash_logo.png', fit: BoxFit.fill),
        ),
      ),
    );
  }
}
