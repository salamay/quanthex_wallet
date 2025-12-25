import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/utils/navigator.dart';
import 'package:quanthex/widgets/app_button.dart';
import 'package:quanthex/widgets/bottom_nav_bar.dart';

class EarningBreakdownModal extends StatelessWidget {
  const EarningBreakdownModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.sp,
              height: 4.sp,
              margin: EdgeInsets.only(bottom: 20.sp),
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Center(
            child: Text(
              'Earning Breakdown Explained',
              style: TextStyle(
                color: const Color(0xFF2D2D2D),
                fontSize: 20.sp,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          20.sp.verticalSpace,
          Text(
            'Each time your activity count reaches a specific milestone (called completes), a new reward tier is unlocked.',
            style: TextStyle(
              color: const Color(0xFF757575),
              fontSize: 14.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
          15.sp.verticalSpace,
          Text(
            'Your completes increase as your participation grows, and every tier unlocks automatically as the required milestones are reached.',
            style: TextStyle(
              color: const Color(0xFF757575),
              fontSize: 14.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
          30.sp.verticalSpace,
          AppButton(
            text: 'Okay, I Got it',
            textColor: Colors.white,
            color: const Color(0xFF792A90),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          10.sp.verticalSpace,
        ],
      ),
    );
  }
}