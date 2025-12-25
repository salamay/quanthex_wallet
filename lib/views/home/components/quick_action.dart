import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class QuickAction extends StatelessWidget {
  QuickAction({super.key,required this.icon,required this.label});
  dynamic icon;
  String label="";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56.sp,
          height: 56.sp,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            shape: BoxShape.circle,
          ),
          child: icon.runtimeType == IconData
              ? Icon(icon, color: const Color(0xFF2D2D2D), size: 24.sp)
              : Center(child: icon),
        ),
        8.verticalSpace,
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFF2D2D2D),
            fontSize: 12.sp,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
