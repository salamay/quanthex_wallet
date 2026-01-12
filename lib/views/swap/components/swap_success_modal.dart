// Swap Success Modal
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/widgets/app_button.dart';
class SwapSuccessModal extends StatelessWidget {
  final String fromToken;
  final String toToken;

  const SwapSuccessModal({super.key, required this.fromToken, required this.toToken});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.all(24.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.sp,
            height: 4.sp,
            margin: EdgeInsets.only(bottom: 20.sp),
            decoration: BoxDecoration(color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(2)),
          ),
          10.sp.verticalSpace,
          // Stack(
          //   alignment: Alignment.center,
          //   children: [
          //     Container(
          //       width: 60.sp,
          //       height: 60.sp,
          //       decoration: BoxDecoration(
          //         color: const Color(0xFFF9E6FF),
          //         shape: BoxShape.circle,
          //       ),
          //       child: Icon(
          //         Icons.diamond,
          //         size: 32.sp,
          //         color: const Color(0xFF792A90),
          //       ),
          //     ),
          //     Positioned(
          //       right: 0,
          //       child: Container(
          //         width: 40.sp,
          //         height: 40.sp,
          //         decoration: BoxDecoration(
          //           color: Colors.blue,
          //           shape: BoxShape.circle,
          //         ),
          //         child: Icon(Icons.circle, size: 24.sp, color: Colors.white),
          //       ),
          //     ),
          //   ],
          // ),
          Container(
            width: 137.sp,
            height: 80.sp,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/images/swapduo.png"), fit: BoxFit.fill),
            ),
          ),
          20.sp.verticalSpace,
          Text(
            'Swap Successful',
            style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 22.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
          ),
          10.sp.verticalSpace,
          Text(
            'Your token swap went through successfully.',
            textAlign: TextAlign.center,
            style: TextStyle(color: const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
          ),
          30.sp.verticalSpace,
          AppButton(
            text: 'Done',
            textColor: Colors.white,
            color: const Color(0xFF792A90),
            onTap: () {
              Navigator.of(context).pop();
              // Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
          20.sp.verticalSpace,
        ],
      ),
    );
  }
}
