import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/views/otp/model/otp_args.dart';
import 'package:quanthex/widgets/app_button.dart';
import 'package:quanthex/widgets/app_textfield.dart';
import 'package:quanthex/widgets/arrow_back.dart';

import '../../../data/repository/secure_storage.dart';
import '../../../data/services/auth/auth_service.dart';
import '../../../routes/app_routes.dart';
import '../../../data/utils/device/device_utils.dart';
import '../../../data/utils/logger.dart';
import '../../../data/utils/overlay_utils.dart';
import '../../../widgets/snackbar/my_snackbar.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: MediaQuery.of(context).size.height,
            child: Form(
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
                  20.sp.verticalSpace,
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
                      'Please sign in to your account to continue using our app.',
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
                  AppTextfield(
                      hintText: 'Password',
                      isPassword: true,
                    controller: password,
                    validator: (val)=>val==null?"A valid password is required":null,
                  ),

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

                  10.sp.verticalSpace,
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
                  20.sp.verticalSpace,

                  ValueListenableBuilder(
                      valueListenable: formValidation,
                      builder: (context,valid,_) {
                      return AppButton(
                        text: 'Sign In',
                        textColor: Colors.white,
                        color: valid?const Color(0xFF792A90):Color(0xFFB5B5B5),
                        onTap: () async {
                          if(!valid){
                            return;
                          }
                          String email=emailAddress.text.trim();
                          String pass=password.text.trim();
                          String refCode=referralCode.text.trim();
                          String deviceName=DeviceUtils.getDeviceType();
                          String deviceId=await DeviceUtils.getDeviceId()??"UNKNOWN_DEVICE_ID";
                          try{
                            showOverlay(context);
                            await AuthService.getInstance().getSignInOtp(email: email, password: pass);
                            hideOverlay(context);
                            OtpArgs otpArgs=OtpArgs(
                                email: email,
                                initialCallBack: ()async{
                                  await AuthService.getInstance().getSignInOtp(email: email, password: pass);
                                }
                            );
                            String? input=await Navigate.awaitToNamed(context,name: AppRoutes.verifyview,args: otpArgs);
                            logger("Input: $input", runtimeType.toString());
                            if(input==null){
                              return;
                            }
                            showOverlay(context);
                            String token=await AuthService.getInstance().signIn(email: email, password: pass, deviceId: deviceId, deviceName: deviceName,otp: input);
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
                  ),
                  10.sp.verticalSpace,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
