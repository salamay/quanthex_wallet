import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/utils/navigator.dart';

class SecurityPrivacyView extends StatefulWidget {
  const SecurityPrivacyView({super.key});

  @override
  State<SecurityPrivacyView> createState() => _SecurityPrivacyViewState();
}

class _SecurityPrivacyViewState extends State<SecurityPrivacyView> {
  bool _unlockWithBiometrics = true;
  bool _unlockWithFaceId = true;
  String _unlockMethod = 'pin'; // 'pin' or 'password'

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
                          style: TextStyle(
                            color: const Color(0xFF2D2D2D),
                            fontSize: 16.sp,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Security & Privacy',
                    style: TextStyle(
                      color: const Color(0xFF2D2D2D),
                      fontSize: 18.sp,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Spacer(),
                  SizedBox(width: 60.sp),
                ],
              ),
              30.sp.verticalSpace,
              // Show Secret Recovery Phrase
              _buildSecuritySection(
                title: 'Show Secret Recovery Phrase',
                description:
                    'Protect your wallet by saving your secret recovery phrase in the savings & drive or written in a piece of paper, or notes and diaries',
                buttonText: 'Show Secret Recovery Phrase',
                onButtonTap: () {
                  // Navigate to seed phrase view
                },
              ),
              20.sp.verticalSpace,
              // Password
              _buildSecuritySection(
                title: 'Password',
                description:
                    'Choose a strong password to unlock the app on your device, make sure to add uppercase, numbers and special character to enforce your password',
                buttonText: 'Change Password',
                onButtonTap: () {
                  Navigate.toNamed(context, name: '/changepasswordview');
                },
              ),
              20.sp.verticalSpace,
              // 6 Digit Pin
              _buildSecuritySection(
                title: '6 Digit Pin',
                description:
                    'Add an extra layer of security to your wallet by setting up a PIN. This will be used to unlock your wallet and approve transactions.',
                buttonText: 'Change Pin',
                onButtonTap: () {
                  Navigate.toNamed(context, name: '/setpinview');
                },
              ),
              20.sp.verticalSpace,
              // Unlock Method
              _buildSection(
                title: 'Unlock Method',
                description:
                    'Choose the default method you want to be using to unlock your wallet when you launch it',
                child: Padding(
                  padding: EdgeInsetsGeometry.only(top: 10.sp),
                  child: Row(
                    children: [
                      15.sp.verticalSpace,
                      _buildRadioOption(
                        title: '6-Digit Pin',
                        value: 'pin',
                        groupValue: _unlockMethod,
                        onChanged: (value) {
                          setState(() {
                            _unlockMethod = value!;
                          });
                        },
                      ),
                      10.sp.horizontalSpace,
                      _buildRadioOption(
                        title: 'Password',
                        value: 'password',
                        groupValue: _unlockMethod,
                        onChanged: (value) {
                          setState(() {
                            _unlockMethod = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              20.sp.verticalSpace,
              // Unlock with Biometrics
              _buildToggleSection(
                title: 'Unlock with Biometrics',
                value: _unlockWithBiometrics,
                onChanged: (value) {
                  setState(() {
                    _unlockWithBiometrics = value;
                  });
                },
              ),
              20.sp.verticalSpace,
              // Unlock with Face ID
              _buildToggleSection(
                title: 'Unlock with Face ID',
                value: _unlockWithFaceId,
                onChanged: (value) {
                  setState(() {
                    _unlockWithFaceId = value;
                  });
                },
              ),
              20.sp.verticalSpace,
              // Delete Wallet
              _buildSection(
                title: 'Delete Wallet',
                description:
                    'This will remove all the wallet relate data from your device and you will loose access to the wallect forever',
                child: 15.sp.verticalSpace,
              ),
              Container(
                width: double.infinity,
                height: 50.sp,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 1),
                  borderRadius: BorderRadius.circular(65),
                ),
                child: Center(
                  child: Text(
                    'Delete Wallet',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16.sp,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              40.sp.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecuritySection({
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onButtonTap,
  }) {
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
                  style: TextStyle(
                    color: const Color(0xFF792A90),
                    fontSize: 16.sp,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String description,
    required Widget child,
  }) {
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
            style: TextStyle(
              color: const Color(0xFF2D2D2D),
              fontSize: 18.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w700,
            ),
          ),
          8.sp.verticalSpace,
          Text(
            description,
            style: TextStyle(
              color: const Color(0xFF757575),
              fontSize: 14.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildToggleSection({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
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
                  style: TextStyle(
                    color: const Color(0xFF2D2D2D),
                    fontSize: 18.sp,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF792A90),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption({
    required String title,
    required String value,
    required String? groupValue,
    required Function(String?) onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Row(
        children: [
          Container(
            width: 24.sp,
            height: 24.sp,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: groupValue == value
                    ? const Color(0xFF792A90)
                    : const Color(0xFFE0E0E0),
                width: 2,
              ),
              color: groupValue == value
                  ? const Color(0xFF792A90)
                  : Colors.transparent,
            ),
            child: groupValue == value
                ? Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Icon(
                      Icons.circle_rounded,
                      size: 16.sp,
                      color: const Color(0xFF792A90),
                    ),
                  )
                : null,
          ),
          10.horizontalSpace,
          Text(
            title,
            style: TextStyle(
              color: const Color(0xFF2D2D2D),
              fontSize: 16.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
