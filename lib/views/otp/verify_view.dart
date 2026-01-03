import 'dart:async';
import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:quanthex/routes/app_routes.dart';
import 'package:quanthex/data/utils/logger.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/views/otp/model/otp_args.dart';
import 'package:quanthex/widgets/app_button.dart';
import 'package:quanthex/widgets/snackbar/my_snackbar.dart';

import '../../data/repository/my_local_storage.dart';

class VerifyView extends StatefulWidget {
  VerifyView({super.key,required this.args});

  OtpArgs args;

  @override
  State<VerifyView> createState() => _VerifyViewState();
}

class _VerifyViewState extends State<VerifyView> {

  int _resendTimer = 30; // Initial timer duration
  bool _isResendEnabled = false;
  int _resendAttempts = 0; // Tracks the number of attempts
  Timer? _timer;
  List<int> durations = [30, 60, 90, 120];
  TextEditingController pinController = TextEditingController();
  String textValue="";
  int maxLength=6;

  @override
  void dispose() {
    // TODO: implement dispose
    _timer?.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    SchedulerBinding.instance.addPostFrameCallback((e){
      getCacheTimeLeft();
    });
    super.initState();
  }


  Future<void> initCallBack()async{
    await widget.args.initialCallBack.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 80.sp,
        leading:  Row(
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
            // 15.sp.horizontalSpace,
          ],
        ),
        actions: [
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
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

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
                        text: "${widget.args.email.substring(0,1)}***@${widget.args.email.split("@")[1]}",
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
                controller: pinController,
                keyboardType: TextInputType.number,
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
                  textValue=v;
                  setState(() {});
                },
                onChanged: (value) {
                  textValue=value;
                  setState(() {});
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
                      text:  _isResendEnabled ? "Resend" : "Resend available in $_resendTimer seconds.",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          if(_isResendEnabled){
                            logger("Can resend now.",runtimeType.toString());
                            _resendAttempts++; // Increment attempts
                            startResendTimer();
                            _resendTimer = calculateTimerDuration(); // Get updated timer duration
                            // Call resend OTP API here
                            await initCallBack();
                          }else{
                            logger("Resend not available yet.",runtimeType.toString());
                          }
                        },
                      style: TextStyle(
                        color: const Color(0xFF792A90),
                        fontSize: 16,
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
                text: 'Done',
                textColor: Colors.white,
                color: textValue.length==maxLength?const Color(0xFF792A90):Color(0xFFB5B5B5),
                onTap: () {
                  String pin=pinController.text.trim();
                  if(pin.length!=maxLength){
                    showMySnackBar(context: context, message: "Please enter a valid 6-digit code", type: SnackBarType.error);
                    return;
                  }
                  Navigate.back(context,args: pin);
                },
              ),
              10.sp.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
  int calculateTimerDuration() {
    return durations[_resendAttempts.clamp(0, durations.length - 1)];
  }
  // Function to start the timer
  void startResendTimer() {
    setState(() {
      _isResendEnabled = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer == 0) {
        timer.cancel();
        setState(() {
          _isResendEnabled = true;
        });
      } else {
        setState(() {
          _resendTimer--;
          MyLocalStorage().setOtpTimeLeft("otp", _resendTimer);
        });
      }
    });
  }

  void getCacheTimeLeft()async{
    try{
      int timeLeft=await MyLocalStorage().getOtpTimeLeft("otp");
      logger("Time left: $timeLeft",runtimeType.toString());
      if(timeLeft>0){
        _resendTimer=timeLeft;
        startResendTimer();
      }else{
        startResendTimer();
        _resendTimer = calculateTimerDuration(); // Get updated timer duration
        try{
          // await initCallBack();
        }catch(e){
          logger(e.toString(),runtimeType.toString());
          showMySnackBar(context: context, message: "Unable to send otp", type: SnackBarType.error);
        }
      }
    }catch(e){
      logger(e.toString(),runtimeType.toString());
      showMySnackBar(context: context, message: "An error occurred", type: SnackBarType.error);
    }
  }
}
