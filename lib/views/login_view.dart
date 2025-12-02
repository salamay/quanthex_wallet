import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/utils/navigator.dart';
import 'package:quanthex/widgets/app_button.dart';
import 'package:quanthex/widgets/app_textfield.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 5,
                children: [
                  // 15.sp.horizontalSpace,
                  GestureDetector(
                    onTap: () {
                      Navigate.back(context);
                    },
                    child: Icon(Icons.arrow_back, size: 17.sp),
                  ),
                  Text(
                    'Back',
                    style: TextStyle(
                      color: const Color(0xFF292929),
                      fontSize: 13.sp,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w500,
                      // height: 1.69,
                    ),
                  ),

                  Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF9E6FF),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          color: const Color(0xFFFAEBFF),
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 2,
                      children: [
                        Container(
                          width: 12.8.sp,
                          height: 12.8.sp,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/Union.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        5.verticalSpace,
                        Text(
                          'EN',
                          style: TextStyle(
                            color: const Color(0xFF4F4F4F),
                            fontSize: 13.sp,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w500,
                            // letterSpacing: -0.41,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 15.sp.horizontalSpace,
                ],
              ),
              30.sp.verticalSpace,
              Text(
                'Welcome Back',
                style: TextStyle(
                  color: const Color(0xFF2D2D2D),
                  fontSize: 19,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                  height: 1.16,
                ),
              ),
              10.sp.verticalSpace,
              SizedBox(
                width: 325.sp,
                child: Text(
                  'Enter your credentials to quickly access your wallet and continue managing your funds.',
                  style: TextStyle(
                    color: const Color(0xFF757575),
                    fontSize: 14.sp,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              30.sp.verticalSpace,
              Text(
                'Email Address',
                style: TextStyle(
                  color: const Color(0xFF333333),
                  fontSize: 14,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                  height: 1.57,
                  letterSpacing: -0.41,
                ),
              ),

              5.sp.verticalSpace,
              AppTextfield(hintText: 'Enter your email address'),

              20.sp.verticalSpace,
              Text(
                'Password',
                style: TextStyle(
                  color: const Color(0xFF333333),
                  fontSize: 14,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                  height: 1.57,
                  letterSpacing: -0.41,
                ),
              ),
              5.sp.verticalSpace,
              AppTextfield(hintText: 'Password', isPassword: true),

              20.sp.verticalSpace,
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1.5.sp,
                        // width: double.infinity,
                        color: Color(0xffEBEBEB),
                      ),
                    ),
                    // 20.sp.verticalSpace,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Or',
                        style: TextStyle(
                          color: const Color(0xFF959595),
                          fontSize: 11.sp,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w700,
                          height: 2.sp,
                          letterSpacing: -0.41,
                        ),
                      ),
                    ),
                    // 20.sp.verticalSpace,
                    Expanded(
                      child: Container(
                        height: 1.5.sp,
                        // width: double.infinity,
                        color: Color(0xffEBEBEB),
                      ),
                    ),
                  ],
                ),
              ),

              15.sp.verticalSpace,

              Container(
                width: 333.sp,
                height: 45.sp,
                padding: const EdgeInsets.symmetric(
                  // horizontal: 131,
                  // vertical: 18,
                ),
                decoration: ShapeDecoration(
                  color: const Color(0xFF323232),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 7,
                  children: [
                    Container(
                      width: 17.sp,
                      height: 17.sp,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/googleimage.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text(
                      'Sign in using Google',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w700,
                        height: 1.69,
                        letterSpacing: -0.41,
                      ),
                    ),
                  ],
                ),
              ),

              20.sp.verticalSpace,
              Center(
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: const Color(0xFF792A90),
                    fontSize: 13,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w700,
                    height: 1.69,
                  ),
                ),
              ),

              Spacer(),
              AppButton(
                text: 'Sign In',
                textColor: Colors.white,
                color: Color(0xFFB5B5B5),
                onTap: () {
                  // Navigate.toNamed(context, name: '/landingview');
                },
              ),
              10.sp.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
