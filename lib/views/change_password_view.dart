import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/utils/navigator.dart';
import 'package:quanthex/widgets/app_button.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _hideCurrentPassword = true;
  bool _hideNewPassword = true;
  bool _hideConfirmPassword = true;

  bool _canChangePassword() {
    return _currentPasswordController.text.isNotEmpty &&
        _newPasswordController.text.length >= 8 &&
        _newPasswordController.text == _confirmPasswordController.text;
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
                    'Change Password',
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
              40.sp.verticalSpace,
              // Current Password
              Text(
                'Current Password',
                style: TextStyle(
                  color: const Color(0xFF2D2D2D),
                  fontSize: 16.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
              10.sp.verticalSpace,
              TextField(
                controller: _currentPasswordController,
                obscureText: _hideCurrentPassword,
                decoration: InputDecoration(
                  hintText: 'Enter the current password',
                  hintStyle: TextStyle(
                    color: const Color(0xFF9E9E9E),
                    fontSize: 14.sp,
                    fontFamily: 'Satoshi',
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(55),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(16.sp),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _hideCurrentPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: const Color(0xFFc6c6c6),
                    ),
                    onPressed: () {
                      setState(() {
                        _hideCurrentPassword = !_hideCurrentPassword;
                      });
                    },
                  ),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              30.sp.verticalSpace,
              // New Password
              Text(
                'New Password',
                style: TextStyle(
                  color: const Color(0xFF2D2D2D),
                  fontSize: 16.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
              10.sp.verticalSpace,
              TextField(
                controller: _newPasswordController,
                obscureText: _hideNewPassword,
                decoration: InputDecoration(
                  hintText: 'Enter new password',
                  hintStyle: TextStyle(
                    color: const Color(0xFF9E9E9E),
                    fontSize: 14.sp,
                    fontFamily: 'Satoshi',
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(55),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(16.sp),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _hideNewPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: const Color(0xFFc6c6c6),
                    ),
                    onPressed: () {
                      setState(() {
                        _hideNewPassword = !_hideNewPassword;
                      });
                    },
                  ),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              8.sp.verticalSpace,
              Text(
                'Must be atleast 8 characters',
                style: TextStyle(
                  color: const Color(0xFF757575),
                  fontSize: 12.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w400,
                ),
              ),
              30.sp.verticalSpace,
              // Confirm New Password
              Text(
                'Confirm New Password',
                style: TextStyle(
                  color: const Color(0xFF2D2D2D),
                  fontSize: 16.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
              10.sp.verticalSpace,
              TextField(
                controller: _confirmPasswordController,
                obscureText: _hideConfirmPassword,
                decoration: InputDecoration(
                  hintText: 'Confirm new pasword',
                  hintStyle: TextStyle(
                    color: const Color(0xFF9E9E9E),
                    fontSize: 14.sp,
                    fontFamily: 'Satoshi',
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(55),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(16.sp),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _hideConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: const Color(0xFFc6c6c6),
                    ),
                    onPressed: () {
                      setState(() {
                        _hideConfirmPassword = !_hideConfirmPassword;
                      });
                    },
                  ),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              8.sp.verticalSpace,
              Text(
                'The password must match',
                style: TextStyle(
                  color: const Color(0xFF757575),
                  fontSize: 12.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w400,
                ),
              ),
              40.sp.verticalSpace,
              AppButton(
                text: 'Change',
                textColor: Colors.white,
                color: _canChangePassword()
                    ? const Color(0xFF792A90)
                    : const Color(0xFFB5B5B5),
                onTap: () {
                  _canChangePassword();
                  // Handle password change
                  Navigator.pop(context);
                },
              ),
              40.sp.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
