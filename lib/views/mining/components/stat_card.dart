import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/views/mining/mining_view.dart';

class StatCard extends StatelessWidget {
  StatCard({super.key, required this.label, required this.value, this.fontSize, this.infoText});
  String label;
  String value;
  String? infoText;
  double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 90.sp,
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
            style: TextStyle(color: Colors.white70, fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400,height: 1),
          ),
          2.sp.verticalSpace,
          AutoSizeText(
            value,
            maxLines: 1,
            style: TextStyle(color: Colors.white, fontSize: fontSize ?? 18.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
          ),
           2.sp.verticalSpace,
          infoText!=null?AutoSizeText(
            infoText!,
            maxLines: 3,
            style: TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'Satoshi', fontWeight: FontWeight.w400,height: 1),
          ):SizedBox.shrink(),
        ],
      ),
    );
  }
}