import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/views/home/components/coin_image.dart';

import '../../../widgets/app_button.dart';
import 'package:flutter/material.dart';
class WithdrawSuccessModal extends StatelessWidget {
  final double amount;
  final String token;
  final String chain;
  final String tokenImage;
  const WithdrawSuccessModal({
    super.key,
    required this.amount,
    required this.token,
    required this.chain,
    required this.tokenImage,
  });

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
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 30.sp),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CoinImage(
                      imageUrl: tokenImage,
                      width: 60.sp,
                      height: 60.sp,
                    ),
                    Positioned(
                      left: -40.sp,
                      child: Container(
                        width: 60.sp,
                        height: 60.sp,
                        decoration: BoxDecoration(
                          color: const Color(0xFF792A90),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          size: 30.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              15.horizontalSpace,
              Text(
                '+$amount $token',
                style: TextStyle(
                  color: const Color(0xFF2D2D2D),
                  fontSize: 20.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          20.sp.verticalSpace,
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              style: TextStyle(
                color: const Color(0xFF2D2D2D),
                fontSize: 16.sp,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
              children: [
                TextSpan(text: 'An amount of '),
                TextSpan(
                  text: '$amount $token',
                  style: TextStyle(
                    color: const Color(0xFF792A90),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: ' has been successfully paid to your wallet.'),
              ],
            ),
          ),
          10.sp.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/matic_logo.png',
                width: 20.sp,
                height: 20.sp,
              ),
              8.horizontalSpace,
              Text(
                chain,
                style: TextStyle(
                  color: const Color(0xFF757575),
                  fontSize: 14.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          30.sp.verticalSpace,
          AppButton(
            text: 'Done',
            textColor: Colors.white,
            color: const Color(0xFF792A90),
            padding: EdgeInsets.all(5),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          20.sp.verticalSpace,
        ],
      ),
    );
  }
}