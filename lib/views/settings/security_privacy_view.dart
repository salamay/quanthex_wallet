import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/data/repository/my_local_storage.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/routes/app_routes.dart';

class SecurityPrivacyView extends StatefulWidget {
  const SecurityPrivacyView({super.key});

  @override
  State<SecurityPrivacyView> createState() => _SecurityPrivacyViewState();
}

class _SecurityPrivacyViewState extends State<SecurityPrivacyView> {
  bool _unlockWithBiometrics = false;
  bool _unlockWithFaceId = true;
  String _unlockMethod = 'pin'; // 'pin' or 'password'

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async{
      await loadBiometricAuth();
    });
  }

  Future<void> loadBiometricAuth() async {
    bool biometricAuth = await MyLocalStorage().getBiometricAuth();
    setState(() {
      _unlockWithBiometrics = biometricAuth;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.sp.verticalSpace,
              // Header
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigate.back(context);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back, size: 20.sp),
                        5.horizontalSpace,
                        Text(
                          'Back',
                          style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Security & Privacy',
                    style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 18.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                  ),
                  Spacer(),
                  SizedBox(width: 60.sp),
                ],
              ),

              20.sp.verticalSpace,
              // 6 Digit Pin
              _buildSecuritySection(
                title: '6 Digit Pin',
                description: 'Add an extra layer of security to your wallet by setting up a PIN. This will be used to unlock your wallet and approve transactions.',
                buttonText: 'Change Pin',
                onButtonTap: () {
                  // Navigate.toNamed(context, name: AppRoutes.setpinview, args: false);
                  Navigate.toNamed(context, name: AppRoutes.verifycurrentpinview, args: false);
                },
              ),
              // Unlock Method
              // _buildSection(
              //   title: 'Unlock Method',
              //   description:
              //       'Choose the default method you want to be using to unlock your wallet when you launch it or authenticate your transactions',
              //   child: Padding(
              //     padding: EdgeInsetsGeometry.only(top: 10.sp),
              //     child: Row(
              //       children: [
              //         15.sp.verticalSpace,
              //         _buildRadioOption(
              //           title: '6-Digit Pin',
              //           value: 'pin',
              //           groupValue: _unlockMethod,
              //           onChanged: (value) {
              //             setState(() {
              //               _unlockMethod = value!;
              //             });
              //           },
              //         ),
              //         10.sp.horizontalSpace,
              //         _buildRadioOption(
              //           title: 'Password',
              //           value: 'password',
              //           groupValue: _unlockMethod,
              //           onChanged: (value) {
              //             setState(() {
              //               _unlockMethod = value!;
              //             });
              //           },
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Unlock with Biometrics
              _buildToggleSection(
                title: 'Biometric Authentication',
                value: _unlockWithBiometrics,
                onChanged: (value) async {
                  if (value) {
                    await MyLocalStorage().setBiometricAuth(true);
                  } else {
                    await MyLocalStorage().setBiometricAuth(false);
                  }
                  setState(() {
                    _unlockWithBiometrics = value;
                  });
                },
              ),
              40.sp.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecuritySection({required String title, required String description, required String buttonText, required VoidCallback onButtonTap}) {
    return _buildSection(
      title: title,
      description: description,
      child: Column(
        children: [
          15.sp.verticalSpace,
          GestureDetector(
            onTap: onButtonTap,
            child: Container(
              width: double.infinity,
              height: 50.sp,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF792A90), width: 1),
                borderRadius: BorderRadius.circular(65),
              ),
              child: Center(
                child: Text(
                  buttonText,
                  style: TextStyle(color: const Color(0xFF792A90), fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required String description, required Widget child}) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        // color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 18.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
          ),
          8.sp.verticalSpace,
          Text(
            description,
            style: TextStyle(color: const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400, height: 1.5),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildToggleSection({required String title, required bool value, required Function(bool) onChanged}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 5),
      decoration: BoxDecoration(
        // color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 18.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeThumbColor: const Color(0xFF792A90)),
        ],
      ),
    );
  }

  Widget _buildRadioOption({required String title, required String value, required String? groupValue, required Function(String?) onChanged}) {
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Row(
        children: [
          Container(
            width: 24.sp,
            height: 24.sp,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: groupValue == value ? const Color(0xFF792A90) : const Color(0xFFE0E0E0), width: 2),
              color: groupValue == value ? const Color(0xFF792A90) : Colors.transparent,
            ),
            child: groupValue == value
                ? Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                    child: Icon(Icons.circle_rounded, size: 16.sp, color: const Color(0xFF792A90)),
                  )
                : null,
          ),
          10.horizontalSpace,
          Text(
            title,
            style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
