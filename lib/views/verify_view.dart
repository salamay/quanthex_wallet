import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:quanthex/utils/navigator.dart';
import 'package:quanthex/widgets/app_button.dart';

class VerifyView extends StatelessWidget {
  const VerifyView({super.key});

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

              Center(
                child: SizedBox(
                  width: 228.sp,
                  child: Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          borderRadius: BorderRadius.circular(30),
                          minHeight: 8,
                          value: 0.5,
                          color: const Color(0xFF792A90),
                        ),
                      ),
                      15.horizontalSpace,
                      Text(
                        '2 / 4',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF454545),
                          fontSize: 10.sp,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              15.sp.verticalSpace,
              Text(
                'Verify Your Email',
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
                width: 270.sp,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text:
                            'We’ve sent a 6-digit verification code to your email ',
                        style: TextStyle(
                          color: const Color(0xFF757575),
                          fontSize: 14,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: 'adem******@gmail.com',
                        style: TextStyle(
                          color: const Color(0xFF434343),
                          fontSize: 14,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              30.sp.verticalSpace,

              PinCodeTextField(
                length: 6,
                obscureText: false,
                animationType: AnimationType.fade,
                appContext: context,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.circle,
                  // borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 50,

                  // activeFillColor: Color(0xffD4D4D4),
                  inactiveFillColor: Color(0xffF5F5F5),
                  activeFillColor: Color(0xffF5F5F5),

                  selectedFillColor: Color(0xffF5F5F5),
                  activeColor: Color(0xffD4D4D4),
                  inactiveColor: Color(0xffF5F5F5),
                  selectedColor: Color(0xffD4D4D4),
                ),
                animationDuration: Duration(milliseconds: 300),
                // backgroundColor: Colors.blue.shade50,
                enableActiveFill: true,
                // errorAnimationController: errorController,
                // controller: textEditingController,
                onCompleted: (v) {
                  // print("Completed");
                },
                onChanged: (value) {
                  // print(value);
                  // setState(() {
                  //   currentText = value;
                  // });
                },
                beforeTextPaste: (text) {
                  print("Allowing to paste $text");
                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                  return true;
                },
              ),

              10.sp.verticalSpace,

              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Didn’t receive the code? ',
                      style: TextStyle(
                        color: const Color(0xFF757575),
                        fontSize: 13,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: 'Resend in 32 s',
                      style: TextStyle(
                        color: const Color(0xFF393939),
                        fontSize: 13,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              20.sp.verticalSpace,

              Spacer(),
              AppButton(
                text: 'Verify Now',
                textColor: Colors.white,
                color: Color(0xFFB5B5B5),
                onTap: () {
                  Navigate.toNamed(context, name: '/setupwalletview');
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
