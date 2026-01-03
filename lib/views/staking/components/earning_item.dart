import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/data/Models/staking/staking_dto.dart';
import 'package:quanthex/data/Models/staking/withdrawal.dart';
import 'package:quanthex/data/utils/date_utils.dart';

class EarningItem extends StatelessWidget {
  EarningItem({super.key, required this.withdrawal});
  WithdrawalDto withdrawal;

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(bottom: 1.sp),
      padding: EdgeInsets.only(
        left: 16.sp,
        right: 16.sp,
        bottom: 10.sp,
        top: 10.sp,
      ),
      decoration: BoxDecoration(
        // color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40.sp,
                height: 40.sp,
                decoration: BoxDecoration(
                  // color: Colors.green.withOpacity(0.2),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/usdt_image.png'),
                  ),
                ),
                // child: Center(
                //   child: Text(
                //     'T',
                //     style: TextStyle(
                //       color: Colors.green,
                //       fontSize: 20.sp,
                //       fontFamily: 'Satoshi',
                //       fontWeight: FontWeight.w700,
                //     ),
                //   ),
                // ),
              ),
              15.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Withdrawal ID: ${withdrawal.withdrawalId ?? "N/A"}',
                      maxLines: 2,
                      style: TextStyle(
                        color: const Color(0xFF2D2D2D),
                        fontSize: 16.sp,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    4.sp.verticalSpace,
                    Text(
                      MyDateUtils.formatDate(
                        int.parse(withdrawal.withdrawalCreatedAt ?? "0"),
                      ),
                      style: TextStyle(
                        color: const Color(0xFF757575),
                        fontSize: 12.sp,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Staked ${withdrawal.withdrawalAmountCrypto} ${withdrawal.withdrawalAssetSymbol}',
                style: TextStyle(
                  color: const Color(0xFF2D2D2D),
                  fontSize: 16.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          10.sp.verticalSpace,
          Container(
            height: 1,
            width: MediaQuery.sizeOf(context).width,
            color: Color(0xffEEEEEE),
          ),
        ],
      ),
    );
  }
}
