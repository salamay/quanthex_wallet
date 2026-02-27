import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/widgets/snackbar/my_snackbar.dart';

class ReferralCodeWidget extends StatelessWidget {
  const ReferralCodeWidget({required this.referralCode});
  final String referralCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 18.sp),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [const Color(0xFF792A90).withOpacity(0.08), const Color(0xFF280233).withOpacity(0.06)]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF792A90).withOpacity(0.35), width: 1.2),
        boxShadow: [BoxShadow(color: const Color(0xFF792A90).withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.sp),
                decoration: BoxDecoration(color: const Color(0xFF792A90).withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.card_giftcard_rounded, size: 22.sp, color: const Color(0xFF792A90)),
              ),
              12.horizontalSpace,
              Expanded(
                child: Text(
                  'Your Staking Referral Code',
                  style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          14.sp.verticalSpace,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 4.sp),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF792A90).withOpacity(0.2)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    referralCode,
                    style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 15.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600, letterSpacing: 0.8),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: referralCode));
                    showMySnackBar(context: context, message: 'Referral code copied', type: SnackBarType.success);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.sp),
                    decoration: BoxDecoration(color: const Color(0xFF792A90).withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                    child: Icon(Icons.copy_rounded, size: 20.sp, color: const Color(0xFF792A90)),
                  ),
                ),
              ],
            ),
          ),
          8.sp.verticalSpace,
          Text(
            'Share this code so others can use it when staking',
            style: TextStyle(color: const Color(0xFF757575), fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
