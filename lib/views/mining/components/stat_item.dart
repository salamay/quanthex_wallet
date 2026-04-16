import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class StatItem extends StatelessWidget {
  
  StatItem({required this.icon, required this.label, required this.value, required this.accentColor});
  final IconData icon;
  final String label;
  final String value;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 18.sp, color: accentColor),
        4.sp.verticalSpace,
        Text(
          label,
          style: TextStyle(color: Colors.white70, fontSize: 10.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
          maxLines: 1,
        ),
        2.sp.verticalSpace,
        Text(
          value,
          style: TextStyle(color: Colors.white, fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
