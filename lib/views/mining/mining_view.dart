import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/core/network/Api_url.dart';
import 'package:quanthex/data/Models/mining/mining_dto.dart';
import 'package:quanthex/data/Models/users/profile_dto.dart';
import 'package:quanthex/data/Models/users/referral_dto.dart';
import 'package:quanthex/data/controllers/mining/mining_controller.dart';
import 'package:quanthex/data/controllers/user/user_controller.dart';
import 'package:quanthex/data/utils/my_currency_utils.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/data/utils/product_utils.dart';
import 'package:quanthex/data/utils/share/share_utils.dart';
import 'package:quanthex/data/utils/sub/sub_utils.dart';
import 'package:quanthex/views/mining/components/mining_simulation_widget.dart';
import 'package:quanthex/widgets/quanthex_image_banner.dart';

import 'earning_breakdown_modal.dart';

class MiningView extends StatefulWidget {
  const MiningView({super.key});

  @override
  State<MiningView> createState() => _MiningViewState();
}

class _MiningViewState extends State<MiningView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(
      builder: (context, userCtr, child) {
        List<ReferralDto> referrals = userCtr.referrals;
        int noOfReferrals = referrals.length;
        return Consumer<MiningController>(
          builder: (context, miningCtr, child) {
            MiningDto mining = miningCtr.minings.first;
            String packageName = mining.subscription!.subPackageName ?? "";
            double amountEarned = SubUtils.calcAmountEarned(
              packageName: packageName,
              noOfReferrals: noOfReferrals,
            );
            return Column(
              children: [
                // Quanthex Image Banner
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 0.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Mining',
                        style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 20.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      QuanthexImageBanner(width: 110.sp, height: 60.sp),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mining Progress Circle
                    Center(
                      child: SizedBox(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            MiningSimulationWidget(
                              baseHashRate: double.parse(
                                mining.mining!.hashRate ?? "0",
                              ), // Static hash rate value
                              fluctuationRange:
                                  mining.mining!.hashRate !=
                                      ProductUtils.LEVEL_SIX_HASHRATE.toString()
                                  ? 0.12
                                  : 0.0, // 12% fluctuation range
                              animationSpeed: Duration(
                                milliseconds:
                                    mining.mining!.hashRate !=
                                        ProductUtils.LEVEL_SIX_HASHRATE
                                            .toString()
                                    ? 100
                                    : 1000000000,
                              ), // Animation speed
                              hashUnit: "Hex MH/s",
                              title: "DIGIT HASH",
                              subtitle: "MINING ENGINE",
                            ),
                            // Column(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     Text(
                            //       'Mining',
                            //       style: TextStyle(
                            //         color: const Color(0xFF757575),
                            //         fontSize: 14.sp,
                            //         fontFamily: 'Satoshi',
                            //         fontWeight: FontWeight.w500,
                            //       ),
                            //     ),
                            //     5.verticalSpace,
                            //     Text(
                            //       '${(_miningProgress * 100).toInt()}%',
                            //       style: TextStyle(
                            //         color: const Color(0xFF2D2D2D),
                            //         fontSize: 32.sp,
                            //         fontFamily: 'Satoshi',
                            //         fontWeight: FontWeight.w700,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                    // Earned Amount

                    // 8.sp.verticalSpace,
                    // Center(
                    //   child: Text(
                    //     'Earned STB',
                    //     style: TextStyle(
                    //       color: const Color(0xFF792A90),
                    //       fontSize: 14.sp,
                    //       fontFamily: 'Satoshi',
                    //       fontWeight: FontWeight.w500,
                    //     ),
                    //   ),
                    // ),
                    20.sp.verticalSpace,
                    // Referral Link
                    Consumer<UserController>(
                      builder: (context, userCtr, _) {
                        ProfileDto? userProfile = userCtr.profile;
                        return Container(
                          padding: EdgeInsets.all(16.sp),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              userProfile != null
                                  ? Expanded(
                                      child: Text(
                                        userProfile.referralCode ?? "",
                                        style: TextStyle(
                                          color: const Color(0xFF2D2D2D),
                                          fontSize: 14.sp,
                                          fontFamily: 'Satoshi',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )
                                  : const Spacer(),
                              10.horizontalSpace,
                              GestureDetector(
                                onTap: () {
                                  if (userProfile != null) {
                                    Clipboard.setData(
                                      ClipboardData(
                                        text: userProfile.referralCode ?? "",
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Link copied')),
                                    );
                                  }
                                },
                                child: Icon(
                                  Icons.copy,
                                  size: 20.sp,
                                  color: const Color(0xFF757575),
                                ),
                              ),
                              10.horizontalSpace,
                              GestureDetector(
                                onTap: () async {
                                  String desc =
                                      "Invite your friends and earn rewards when they join and start mining. The more you refer, the more you earn!. Start sharing and grow your earnings effortlessly";
                                  String referralCode =
                                      userProfile!.referralCode ?? "";
                                  ShareUtils.shareContent(
                                    title: referralCode,
                                    subject: desc,
                                    url: ApiUrls.quanthexWebsite,
                                  );
                                },
                                child: Icon(
                                  Icons.share,
                                  size: 20.sp,
                                  color: const Color(0xFF757575),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    30.sp.verticalSpace,
                    // Statistics Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            label: 'Active Members',
                            value: referrals.length.toString(),
                          ),
                        ),
                        15.horizontalSpace,
                        Expanded(
                          child: _buildStatCard(
                            label: 'Package name',
                            value: packageName,
                          ),
                        ),
                      ],
                    ),
                    15.sp.verticalSpace,
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            label: 'Current Mining Speed',
                            value: "${mining.mining!.hashRate} Hex MH/s",
                            isFullWidth: true,
                            fontSize: 15.sp,
                          ),
                        ),
                        15.horizontalSpace,
                        Expanded(
                          child: _buildStatCard(
                            label:
                                mining.subscription!.subRewardAssetName ?? "",
                            value: MyCurrencyUtils.formatCurrency(amountEarned),
                            isFullWidth: true,
                          ),
                        ),
                      ],
                    ),
                    40.sp.verticalSpace,
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    double? fontSize,
    bool isFullWidth = false,
  }) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      height: 80.sp,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFF757575),
              fontSize: 12.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w400,
            ),
          ),
          2.sp.verticalSpace,
          AutoSizeText(
            value,
            maxLines: 1,
            style: TextStyle(
              color: const Color(0xFF2D2D2D),
              fontSize: fontSize ?? 20.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
