import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/widgets/loading_overlay/loading.dart';

class HashCard extends StatelessWidget {
  HashCard({super.key, required this.label, required this.value, this.fontSize, this.isInProgress = false});
  String label;
  String value;
  double? fontSize;
  bool isInProgress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      height: 80.sp,
      decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(color: const Color(0xFF757575), fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
          ),
          2.sp.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
             !isInProgress? Expanded(
                child: AutoSizeText(
                  value,
                  maxLines: 1,
                  style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: fontSize ?? 20.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                ),
              ):const SizedBox.shrink(),
              4.horizontalSpace,
              if (isInProgress)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      isInProgress?Text(
                      "In Progress",
                      style: TextStyle(color: const Color(0xFF757575), fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                    ):const SizedBox.shrink(),
                    4.horizontalSpace,
                    Loading(size: 16.sp),
                    ],
                  )  ,
                  if (!isInProgress)
                  Icon(Icons.check_circle, color: Colors.green, size: 16.sp),
            ],
          ),
        ],
      ),
    );
  }
}
