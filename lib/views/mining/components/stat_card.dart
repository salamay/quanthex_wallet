import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/views/mining/mining_view.dart';

class StatCard extends StatelessWidget {
  StatCard({super.key, required this.label, required this.value, this.fontSize});
  String label;
  String value;
  double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      height: 80.sp,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: greenColor.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.white70, fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
          ),
          2.sp.verticalSpace,
          AutoSizeText(
            value,
            maxLines: 1,
            style: TextStyle(color: Colors.white, fontSize: fontSize ?? 18.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}