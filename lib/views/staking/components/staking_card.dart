import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/views/mining/mining_view.dart';

class StakingCard extends StatelessWidget {
  StakingCard({super.key, required this.child});
  Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(15.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: greenColor.withOpacity(0.6), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black87.withOpacity(0.25), blurRadius: 20, spreadRadius: 0)],
      ),
      child: child,
    );
  }
}