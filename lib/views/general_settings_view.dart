import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/data/utils/navigator.dart';

class GeneralSettingsView extends StatelessWidget {
  const GeneralSettingsView({super.key});

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
                    'General Settings',
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
              Text(
                'Current Language',
                style: TextStyle(
                  color: const Color(0xFF2D2D2D),
                  fontSize: 18.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
              10.sp.verticalSpace,
              Text(
                'Translate the application to a different supported language of your choice.',
                style: TextStyle(
                  color: const Color(0xFF757575),
                  fontSize: 14.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              20.sp.verticalSpace,
              GestureDetector(
                onTap: () {
                  // Show language picker
                },
                child: Container(
                  padding: EdgeInsets.all(16.sp),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'English - US',
                        style: TextStyle(
                          color: const Color(0xFF2D2D2D),
                          fontSize: 16.sp,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: const Color(0xFF757575),
                        size: 24.sp,
                      ),
                    ],
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
}
