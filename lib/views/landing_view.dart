import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/utils/navigator.dart';
import 'package:quanthex/widgets/app_button.dart';

class LandingView extends StatelessWidget {
  const LandingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.red,
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/landingbgimage.png'), //
            fit: BoxFit.fill,
          ),
        ),

        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 217.sp,
                child: Text(
                  'Your all-in-one crypto hub',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.sp,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),

              20.sp.verticalSpace,

              SizedBox(
                width: 301.sp,

                child: Text(
                  'Send, Receive, Swap, Mine, and Stake effortlessly. Track your earnings, grow your assets, and manage your portfolio, all in one secure app.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFFCE9DDC),
                    fontSize: 14.sp,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w500,
                    height: 1.57,
                  ),
                ),
              ),

              25.sp.verticalSpace,
              AppButton(
                text: 'Get Started',
                onTap: () {
                  Navigate.toNamed(context, name: '/createaccountview');
                },
              ),
              15.sp.verticalSpace,
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Already have an account?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w700,
                        height: 1.47,
                        letterSpacing: -0.41,
                      ),
                    ),
                    TextSpan(
                      text: ' Sign In',
                      style: TextStyle(
                        color: const Color(0xFFAA45C7),
                        fontSize: 15,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w700,
                        height: 1.47,
                        letterSpacing: -0.41,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigate.toNamed(context, name: '/loginview');
                        },
                    ),
                  ],
                ),
              ),
              10.sp.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
