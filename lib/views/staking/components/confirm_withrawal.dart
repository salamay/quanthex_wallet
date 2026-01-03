// Confirm Withdrawal Modal
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/data/repository/secure_storage.dart';
import 'package:quanthex/data/utils/logger.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/data/utils/security_utils.dart';
import 'package:quanthex/views/home/components/coin_image.dart';
import 'package:quanthex/widgets/snackbar/my_snackbar.dart';

import '../../../widgets/app_button.dart';
import '../../../widgets/confirm_pin_modal.dart';
import 'package:flutter/material.dart';

class ConfirmWithdrawalModal extends StatelessWidget {
  final double amount;
  final String token;
  final String tokenImage;

  const ConfirmWithdrawalModal({
    super.key,
    required this.amount,
    required this.token,
    required this.tokenImage,
  
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40.sp,
              height: 4.sp,
              margin: EdgeInsets.only(bottom: 20.sp),
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // USDT Icon
          Container(
            width: 80.sp,
            height: 80.sp,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CoinImage(imageUrl: tokenImage, width: 60.sp, height: 60.sp),
              ],
            ),
          ),
          20.sp.verticalSpace,
          Text(
            'Confirm Withdrawal',
            style: TextStyle(
              color: const Color(0xFF2D2D2D),
              fontSize: 20.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w700,
            ),
          ),
          15.sp.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.sp),
            child: Text(
              'You\'re about to withdraw \$$amount $token to your selected wallet address, Please review the details below before proceeding.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF757575),
                fontSize: 14.sp,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
          ),
          30.sp.verticalSpace,
          Container(
            padding: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Amount',
                      style: TextStyle(
                        color: const Color(0xFF757575),
                        fontSize: 14.sp,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      '\$$amount $token',
                      style: TextStyle(
                        color: const Color(0xFF2D2D2D),
                        fontSize: 16.sp,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          30.sp.verticalSpace,
          AppButton(
            text: 'Confirm Withdraw',
            textColor: Colors.white,
            color: const Color(0xFF792A90),
            padding: EdgeInsets.zero,
            onTap: () async {
              Navigate.back(context, args: true);
            },
          ),
          20.sp.verticalSpace,
        ],
      ),
    );
  }
}
