import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:quanthex/data/repository/secure_storage.dart';
import 'package:quanthex/data/services/auth/auth_service.dart';
import 'package:quanthex/routes/app_routes.dart';
import 'package:quanthex/data/utils/device/device_utils.dart' show DeviceUtils;
import 'package:quanthex/data/utils/logger.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/data/utils/overlay_utils.dart';
import 'package:quanthex/widgets/app_button.dart';
import 'package:quanthex/widgets/app_textfield.dart';
import 'package:quanthex/widgets/arrow_back.dart';
import 'package:quanthex/widgets/checkbox.dart';
import 'package:quanthex/widgets/snackbar/my_snackbar.dart';

import '../../../core/constants/auth_constants.dart';
import '../../otp/model/otp_args.dart';

class CreateAccountView extends StatefulWidget {
  CreateAccountView({super.key});

  @override
  State<CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<CreateAccountView> {
   final _formKey=GlobalKey<FormState>();

  final TextEditingController emailAddress=TextEditingController();

  final password = TextEditingController();

  final TextEditingController confirmPasswordCtr = TextEditingController();

  final TextEditingController referralCode=TextEditingController();

  ValueNotifier<bool> formValidation=ValueNotifier<bool>(false);

  ValueNotifier<bool> agreement=ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 80.sp,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ArrowBack(),
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
          ],
        ),
        backgroundColor: Colors.white,
        actions: [
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
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            height: MediaQuery.sizeOf(context).height - 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    width: 228.sp,
                    child: Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            borderRadius: BorderRadius.circular(30),
                            minHeight: 8,
                            value: 0.25,
                            color: const Color(0xFF792A90),
                          ),
                        ),
                        15.horizontalSpace,
                        Text(
                          '1 / 4',
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
                Form(
                  key: _formKey,
                  onChanged: (){
                    logger("Form changed", runtimeType.toString());
                    if(_formKey.currentState!.validate()){
                      formValidation.value=true;
                    }else{
                      formValidation.value=false;
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      15.sp.verticalSpace,
                      Text(
                        'Create Account',
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
                        child: Text(
                          'Join the platform and set up your secure wallet.',
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
                      AppTextfield(
                        hintText: 'Enter your email address',
                        controller: emailAddress,
                        validator: (val)=>!EmailValidator.validate(val!)?"Please enter a valid email address":null,
                      ),

                      15.sp.verticalSpace,
                      Text(
                        'New Password',
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
                      AppTextfield(
                        hintText: 'Password',
                        isPassword: true,
                        controller: password,
                        validator: (val)=>val==null?"A valid password is required":null,
                      ),
                      15.sp.verticalSpace,
                      Text(
                        'Confirm New Password',
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
                      AppTextfield(
                        hintText: 'Confirm password',
                        isPassword: true,
                        controller: confirmPasswordCtr,
                        validator: (val){
                          String pass=password.text.trim();
                          String confirmPassword=confirmPasswordCtr.text.trim();
                          if(pass==confirmPassword){
                            return null;
                          }else{
                            return "Passwords do not match";
                          }
                        },
                      ),
                      15.sp.verticalSpace,
                      Text(
                        'Referral Code (Optional)',
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
                      AppTextfield(
                        hintText: 'Enter referral code',
                        controller: referralCode,
                      ),
                      20.sp.verticalSpace,
                    ],
                  ),
                ),

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

                Row(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: agreement,
                      builder: (context,agreed,_) {
                        return CheckBoxx(
                          value: agreed,
                          onChanged: (val){
                            agreement.value=val!;
                          },
                        );
                      }
                    ),
                    5.sp.horizontalSpace,
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'I agree to ',
                            style: TextStyle(
                              color: const Color(0xFF454545),
                              fontSize: 13,
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w500,
                              height: 1.69,
                            ),
                          ),
                          TextSpan(
                            text: 'Terms & Conditions',
                            style: TextStyle(
                              color: const Color(0xFF792A90),
                              fontSize: 13,
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w500,
                              height: 1.69,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                10.sp.verticalSpace,
                ValueListenableBuilder(
                  valueListenable: formValidation,
                  builder: (context,valid,_) {
                    return ValueListenableBuilder(
                        valueListenable: agreement,
                        builder: (context,agreed,_) {
                        return AppButton(
                          text: 'Create account',
                          textColor: Colors.white,
                          color: valid&&agreed?const Color(0xFF792A90):Color(0xFFB5B5B5),
                          onTap: ()async {
                            if(!valid&&agreed){
                              return;
                            }
                            String email=emailAddress.text.trim();
                            String pass=password.text.trim();
                            String refCode=referralCode.text.trim();
                            String deviceName=DeviceUtils.getDeviceType();
                            String regVia=regBasic;
                            String deviceId=await DeviceUtils.getDeviceId()??"UNKNOWN_DEVICE_ID";
                            try{
                              showOverlay(context);
                              await AuthService.getInstance().getRegOtp(email: email);
                              hideOverlay(context);
                              OtpArgs otpArgs=OtpArgs(
                                  email: email,
                                  initialCallBack: ()async{
                                    await AuthService.getInstance().getRegOtp(email: email);
                                  }
                              );
                              String? input=await Navigate.awaitToNamed(context,name: AppRoutes.verifyview,args: otpArgs);
                              logger("Input: $input", runtimeType.toString());
                              if(input==null){
                                return;
                              }
                              showOverlay(context);
                              String token=await AuthService.getInstance().registerUser(email: email, password: pass, deviceId: deviceId, deviceName: deviceName, referralCode: refCode, regVia: regVia,otp: input);
                              await SecureStorage.getInstance().saveAuthToken(token);
                              hideOverlay(context);
                              Navigate.go(context, name: AppRoutes.setupwalletview);
                            }catch(e){
                              hideOverlay(context);
                              showMySnackBar(context: context, message: e.toString(), type: SnackBarType.error);
                              return;
                            }
                          },
                        );
                      }
                    );
                  }
                ),
                10.sp.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
