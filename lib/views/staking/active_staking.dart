import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/data/Models/staking/staking_referral_dto.dart';
import 'package:quanthex/data/controllers/wallet_controller.dart';
import 'package:quanthex/data/repository/secure_storage.dart';
import 'package:quanthex/data/utils/date_utils.dart';
import 'package:quanthex/data/utils/logger.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/data/utils/security_utils.dart';
import 'package:quanthex/data/utils/staking/staking_utils.dart';
import 'package:quanthex/routes/app_routes.dart';
import 'package:quanthex/views/mining/mining_view.dart';
import 'package:quanthex/views/staking/components/staking_card.dart';
import 'package:quanthex/views/staking/components/staking_detail_row.dart';
import 'package:quanthex/widgets/arrow_back.dart';
import 'package:quanthex/widgets/snackbar/my_snackbar.dart';

import '../../data/Models/staking/staking_dto.dart';
import '../../data/controllers/mining/mining_controller.dart';
import '../../widgets/app_button.dart';
import 'components/confirm_withrawal.dart';
import 'components/withdrawal_success.dart';

class ActiveStaking extends StatelessWidget {
  ActiveStaking({super.key, required this.stake});
  final StakingDto stake;
  late WalletController walletController;

  void _showWithdrawSuccessModal(BuildContext context, StakingDto stake) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WithdrawSuccessModal(amount: double.parse(stake.stakedAmountCrypto ?? "0"), token: stake.stakedAssetSymbol ?? '', chain: stake.stakingRewardChainName ?? '', tokenImage: stake.stakedAssetImage ?? ''),
    );
  }

  Future<bool> _showWithdrawModal(BuildContext context, StakingDto stake) async {
    bool? result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
      builder: (context) => ConfirmWithdrawalModal(amount: double.parse(stake.stakedAmountCrypto ?? "0"), token: stake.stakedAssetSymbol ?? '', tokenImage: stake.stakedAssetImage ?? ''),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    walletController = Provider.of<WalletController>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: ArrowBack(iconColor: Colors.white,),
        centerTitle: true,
        actions: [
          PopupMenuButton<int>(
            color: Colors.black,
            icon: const Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: const Text("View transactions",
                  style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 0) {
                Navigate.toNamed(context, name: AppRoutes.stakingEarningPage,args: stake.stakingId);

              } 
            },
          ),
        ],
        title: Text(
          'Details',
          style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.sp),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken), image: AssetImage('assets/images/green_astro_bg.jpg'), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Farming USDT Card
                StakingCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Staking Yield (USDT)',
                              style: TextStyle(color: Colors.white, fontSize: 24.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                            ),
                            8.sp.verticalSpace,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Variable Daily Yield',
                                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                                ),
                                10.horizontalSpace,
                                Tooltip(
                                  margin: EdgeInsets.symmetric(horizontal: 10.sp),
                                  message: "Yield is calculated daily based on system performance and may vary over time",
                                  child: Icon(Icons.help_outline, size: 16.sp, color: const Color(0xFF757575)),
                                ),
                              ],
                            ),
                            4.sp.verticalSpace,
                            Consumer<MiningController>(
                              builder: (context, miningController, child) {
                                List<StakingReferralDto> referrals = miningController.stakingReferrals[stake.stakingId ?? ""] ?? [];
                                int noOfReferrals = referrals.length;
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'No of Referrals: $noOfReferrals',
                                      style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                                    ),
                                    10.horizontalSpace,
                                    Tooltip(
                                      margin: EdgeInsets.symmetric(horizontal: 10.sp),
                                      message: "Number of referrals who have staked using your referral code",
                                      child: Icon(Icons.help_outline, size: 16.sp, color: const Color(0xFF757575)),
                                    ),
                                  ],
                                );
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Referral Code: ${stake.stakingReferralCode ?? ''}',
                                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(text: stake.stakingReferralCode ?? ''));
                                    showMySnackBar(context: context, message: 'Referral code copied', type: SnackBarType.success);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10.sp),
                                    decoration: BoxDecoration(color: const Color(0xFF792A90).withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                                    child: Icon(Icons.copy_rounded, size: 20.sp, color: greenColor),
                                  ),
                                ),
                              ],
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
                          image: DecorationImage(image: AssetImage('assets/images/stake_icon.png')),
                        ),
                        // child: Icon(Icons.eco, size: 50.sp, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                10.sp.verticalSpace,
                Text(
                  'Your earnings',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                ),
                5.verticalSpace,
                Consumer<MiningController>(
                  builder: (context, miningController, _) {
                    DateTime createdAt = DateTime.fromMillisecondsSinceEpoch(int.parse(stake.stakeCreatedAt.toString()));
                    List<StakingReferralDto> referrals = miningController.stakingReferrals[stake.stakingId ?? ""] ?? [];
                    int noOfReferrals = referrals.length;
                    double amountEarnedDoubleReward = StakingUtils().calculateDoublReward(noOfReferrals: noOfReferrals, noOfTimePayed: 0, stakedAmount: double.parse(stake.stakedAmountCrypto.toString()));
                    return StakingCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Double earnings: ",
                                style: TextStyle(color: const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                              ),
                              5.horizontalSpace,
                              Text(
                                '\$ ${amountEarnedDoubleReward.toStringAsFixed(2)}',
                                style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          4.verticalSpace,
                          Row(
                            children: [
                              Text(
                                "Daily earnings: ",
                                style: TextStyle(color: const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                              ),
                              5.horizontalSpace,
                              Text(
                                '\$ 0',
                                style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          10.verticalSpace,
                          StakingDetailRow(label: 'Plan name: ', value: stake.planName ?? ""),
                          StakingDetailRow(label: 'Amount: ', value: "${stake.stakedAmountCrypto} USDT"),
                          StakingDetailRow(label: 'Duration: ', value: "${stake.duration ?? 0} Months"),
                          StakingDetailRow(label: 'Reward: ', value: "${stake.stakingRewardAssetSymbol}"),
                          StakingDetailRow(label: 'Created at: ', value: MyDateUtils.dateToSingleFormat(createdAt)),
                        ],
                      ),
                    );
                  },
                ),
                20.sp.verticalSpace,
                // Staking Details Card
                StakingCard(
                  child: Column(
                    children: [
                      StakingDetailRow(label: 'Yield Contribution', value: '20%', tooltip: 'Yield allocated based on eligible network participation and staking activity.'),
                      15.sp.verticalSpace,
                      StakingDetailRow(label: 'Flexible Capital Access', value: 'Anytime', tooltip: "Capital remains accessible and can be withdrawn subject to platform conditions."),
                      15.sp.verticalSpace,
                      StakingDetailRow(label: 'Instant Activation', value: 'Immediately after payment'),
                      15.sp.verticalSpace,
                      StakingDetailRow(label: 'Daily Yield Distribution', value: 'Every 24 Hours', tooltip: "Yield is distributed on a daily cycle every 24 hours."),
                    ],
                  ),
                ),
               
                // Withdraw Now Button
                10.verticalSpace,
                
                // Align(
                //   alignment: Alignment.center,
                //   child: Consumer<MiningController>(
                //     builder: (context, miningController, child) {
                //       return AppButton(
                //         text: 'Withdraw Now',
                //         textColor: Colors.white,
                //         color: greenColor.withOpacity(0.2),
                //         onTap: () async {
                //           bool result = await _showWithdrawModal(context, stake);
                //           if (result) {
                //             String userPin = await SecureStorage.getInstance().getPin();
                //             if (userPin.isEmpty) {
                //               logger("User PIN is empty", "ConfirmWithdrawalModal");
                //             } else {
                //               bool pinResult = await SecurityUtils.showPinDialog(context: context);
                //               if (pinResult) {
                //                 try {
                //                   String? stakeId = stake.stakingId;
                //                   if (stakeId != null && stakeId.isNotEmpty) {
                //                     // await miningController.withdraw(stakeId: stakeId, walletAddress: walletAddress);
                //                     // _showWithdrawSuccessModal(context, stake);
                //                   } else {
                //                     showMySnackBar(context: context, message: "Invalid stake ID", type: SnackBarType.error);
                //                   }
                //                 } catch (e) {
                //                   logger("Error withdrawing: $e", "ActiveStaking");
                //                   showMySnackBar(context: context, message: "Failed to process withdrawal: ${e.toString()}", type: SnackBarType.error);
                //                 }
                //               } else {
                //                 showMySnackBar(context: context, message: "Incorrect pin", type: SnackBarType.error);
                //               }
                //             }
                //           }
                //         },
                //       );
                //     },
                //   ),
                // ),
                // 10.verticalSpace,
                // Align(
                //   child: Container(
                //     width: MediaQuery.of(context).size.width * 0.8,
                //     child: Text(
                //       "Staking verification may take up to 48 hours. Once verified, yield dstribution will occur on a 24 hour daily cycle.",
                //       textAlign: TextAlign.center,
                //       style: TextStyle(color: const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
