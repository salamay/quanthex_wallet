import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/date_utils.dart';
class ReferralItem extends StatelessWidget {
  ReferralItem({super.key,required this.email,required this.status,required this.timeStamp});
   String email;
   String status;
   String timeStamp;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 0.sp),
      padding: EdgeInsets.all(2.sp),
      decoration: BoxDecoration(
        // color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      email,
                      style: TextStyle(
                        color: const Color(0xFF2D2D2D),
                        fontSize: 14.sp,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.sp,
                        vertical: 6.sp,
                      ),
                      // decoration: BoxDecoration(
                      //   color: isActive
                      //       ? const Color(0xFFE8F5E9)
                      //       : const Color(0xFFFFF3E0),
                      //   borderRadius: BorderRadius.circular(8),
                      // ),
                      child: Text(
                        'Joined: ${MyDateUtils.dateToSingleFormat(DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp)))}',
                        style: TextStyle(
                          color: const Color(0xFF757575),
                          fontSize: 12.sp,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
