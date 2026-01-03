import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/data/Models/staking/withdrawal.dart';
import 'package:quanthex/data/repository/secure_storage.dart';
import 'package:quanthex/data/utils/logger.dart';
import 'package:quanthex/data/utils/security_utils.dart';
import 'package:quanthex/views/staking/components/earning_item.dart';
import 'package:quanthex/views/staking/components/staking_detail_row.dart';
import 'package:quanthex/widgets/snackbar/my_snackbar.dart';

import '../../data/Models/staking/staking_dto.dart';
import '../../data/controllers/mining/mining_controller.dart';
import '../../widgets/app_button.dart';
import 'components/confirm_withrawal.dart';
import 'components/withdrawal_success.dart';

class ActiveStaking extends StatelessWidget {
  ActiveStaking({super.key, required this.stake});
  StakingDto stake;

  void _showWithdrawSuccessModal(BuildContext context, StakingDto stake) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WithdrawSuccessModal(
        amount: double.parse(stake.stakedAmountCrypto ?? "0"),
        token: stake.stakedAssetSymbol ?? '',
        chain: stake.stakingRewardChainName ?? '',
        tokenImage: stake.stakedAssetImage ?? '',
      ),
    );
  }

  Future<bool> _showWithdrawModal(
    BuildContext context,
    StakingDto stake,
  ) async {
    bool? result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      builder: (context) => ConfirmWithdrawalModal(
        amount: double.parse(stake.stakedAmountCrypto ?? "0"),
        token: stake.stakedAssetSymbol ?? '',
        tokenImage: stake.stakedAssetImage ?? '',
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.sp.verticalSpace,
        // Farming USDT Card
        Container(
          padding: EdgeInsets.all(20.sp),
          decoration: BoxDecoration(
            // gradient: LinearGradient(
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            //   colors: [const Color(0xFF792A90), const Color(0xFF9B4DB0)],
            // ),
            gradient: LinearGradient(
              begin: Alignment(0.00, 0.50),
              end: Alignment(1.00, 0.50),
              colors: [const Color(0xFF792A90), const Color(0xFF280233)],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Farming USDT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    8.sp.verticalSpace,
                    Text(
                      '0.5 - 20% Daily APY',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14.sp,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 80.sp,
                height: 80.sp,
                decoration: BoxDecoration(
                  // color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/farming_image.png'),
                  ),
                ),
                // child: Icon(Icons.eco, size: 50.sp, color: Colors.white),
              ),
            ],
          ),
        ),
        20.sp.verticalSpace,
        // Withdraw Now Button
        Consumer<MiningController>(
          builder: (context, miningController, child) {
            return AppButton(
              text: 'Withdraw Now',
              textColor: const Color(0xFF792A90),
              color: const Color(0xFFF9E6FF),
              onTap: () async {
                bool result = await _showWithdrawModal(context, stake);
                if (result) {
                  String userPin = await SecureStorage.getInstance().getPin();
                  if (userPin.isEmpty) {
                    logger("User PIN is empty", "ConfirmWithdrawalModal");
                  } else {
                    bool pinResult = await SecurityUtils.showPinDialog(
                      context: context,
                    );
                    if (pinResult) {
                      try {
                        String? stakeId = stake.stakingId;
                        if (stakeId != null && stakeId.isNotEmpty) {
                          await miningController.withdraw(stakeId: stakeId);
                          _showWithdrawSuccessModal(context, stake);
                        } else {
                          showMySnackBar(
                            context: context,
                            message: "Invalid stake ID",
                            type: SnackBarType.error,
                          );
                        }
                      } catch (e) {
                        logger("Error withdrawing: $e", "ActiveStaking");
                        showMySnackBar(
                          context: context,
                          message:
                              "Failed to process withdrawal: ${e.toString()}",
                          type: SnackBarType.error,
                        );
                      }
                    } else {
                      showMySnackBar(
                        context: context,
                        message: "Incorrect pin",
                        type: SnackBarType.error,
                      );
                    }
                  }
                }
              },
            );
          },
        ),
        20.sp.verticalSpace,
        // Staking Details Card
        Container(
          padding: EdgeInsets.all(16.sp),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              StakingDetailRow(label: 'Matching Bonus', value: '20%'),
              15.sp.verticalSpace,
              StakingDetailRow(label: 'Capital Flexibility', value: 'Anytime'),
              15.sp.verticalSpace,
              StakingDetailRow(
                label: 'Instant Activation',
                value: 'Immediately after payment',
              ),
              15.sp.verticalSpace,
              StakingDetailRow(label: 'Daily Payouts', value: 'Every 24 Hours'),
            ],
          ),
        ),
        30.sp.verticalSpace,
        // Subscribed Packages
        Text(
          'Withdrawals',
          style: TextStyle(
            color: const Color(0xFF2D2D2D),
            fontSize: 18.sp,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w700,
          ),
        ),
        15.sp.verticalSpace,
        Consumer<MiningController>(
          builder: (context, mCtr, child) {
            List<WithdrawalDto> withdrawals = mCtr.withdrawals;
            return Column(
              children: withdrawals
                  .map((e) => EarningItem(withdrawal: e))
                  .toList(),
            );
          },
        ),
        40.sp.verticalSpace,
      ],
    );
  }
}
