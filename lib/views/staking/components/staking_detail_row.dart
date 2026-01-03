import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class StakingDetailRow extends StatelessWidget {
  StakingDetailRow({super.key, required this.label, required this.value});
  String label;
  String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFF757575),
            fontSize: 14.sp,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: const Color(0xFF2D2D2D),
            fontSize: 14.sp,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
