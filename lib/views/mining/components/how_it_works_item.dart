import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/views/mining/mining_view.dart';
class HowItWorksItem extends StatelessWidget {
  HowItWorksItem({super.key,required this.text, required this.onInfoTap} );
  String text;
  VoidCallback? onInfoTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 24.sp,
          height: 24.sp,
          decoration: BoxDecoration(
            // color: const Color(0xFF792A90),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle_outline,
            size: 20.sp,
            color: Colors.white70,
          ),
        ),
        10.horizontalSpace,
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (onInfoTap != null)
          GestureDetector(
            onTap: onInfoTap,
            child: Container(
              width: 24.sp,
              height: 24.sp,
              decoration: BoxDecoration(
                color: const Color(0xFF792A90).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.help_outline,
                size: 16.sp,
                color: greenColor,
              ),
            ),
          ),
      ],
    );
  }
}
