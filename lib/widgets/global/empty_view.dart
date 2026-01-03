import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyView extends StatelessWidget {
  final String message;

  const EmptyView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.sp),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400, height: 1.5),
        ),
      ),
    );
  }
}
