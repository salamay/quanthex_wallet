import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/views/mining/mining_view.dart';


class MiningStatItem extends StatelessWidget {
  const MiningStatItem({required this.icon, required this.label, required this.value, required this.accentColor});

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
        ),
        2.sp.verticalSpace,
        Text(
          value,
          style: TextStyle(color: Colors.white, fontSize: 11.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
