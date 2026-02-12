import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StakingDetailRow extends StatelessWidget {
  StakingDetailRow({super.key, required this.label, required this.value, this.tooltip});
  final String label;
  final String value;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(color: const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
            ),
            if (tooltip != null) ...[
              10.horizontalSpace,
              Tooltip(
                message: tooltip!,
                margin: EdgeInsets.symmetric(horizontal: 10.sp),
                child: Icon(Icons.help_outline, size: 16.sp, color: const Color(0xFF757575)),
              ),
            ],
          ],
        ),
        Text(
          value,
          style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
