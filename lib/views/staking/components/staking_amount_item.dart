import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StakingAmountItem extends StatelessWidget {
  StakingAmountItem({super.key, required this.content, this.borderColor, required this.bgColor, required this.textColor});
  String content;
  Color bgColor;
  Color textColor;
  Color? borderColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.h),
      decoration: BoxDecoration(
        color: bgColor, borderRadius: BorderRadius.circular(10.sp),
        border: Border.all(color: borderColor??Colors.transparent)
        ),
      child: Center(
        child: Text(
          content,
          style: TextStyle(color: textColor, fontSize: 16, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
