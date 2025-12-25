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
import 'package:quanthex/utils/my_currency_utils.dart';
import 'package:quanthex/utils/navigator.dart';
import 'package:quanthex/utils/share/share_utils.dart';
import 'package:quanthex/utils/sub/sub_utils.dart';


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
                  packageName: packageName, noOfReferrals: noOfReferrals);
              return Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      40.sp.verticalSpace,
                      // Mining Progress Circle
                      Center(
                        child: SizedBox(
                          width: 200.sp,
                          height: 200.sp,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 200.sp,
                                height: 200.sp,
                                child: CircularProgressIndicator(
                                  value: noOfReferrals / SubUtils.maxOfReferrals,
                                  strokeWidth: 22,
                                  strokeCap: StrokeCap.round,
                                  backgroundColor: const Color(0xFFF9E6FF),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    const Color(0xFF792A90),
                                  ),
                                ),
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
                      30.sp.verticalSpace,
                      // Earned Amount
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.sp,
                          vertical: 4.sp,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 240, 42, 243),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: AutoSizeText(
                            "${mining.mining!.hashRate} Hex MH/s",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color.fromARGB(
                                255,
                                255,
                                255,
                                255,
                              ),
                              fontSize: 25.sp,
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
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
                      30.sp.verticalSpace,
                      // Referral Link
                      Consumer<UserController>(
                        builder: (context,userCtr,_) {
                          ProfileDto? userProfile=userCtr.profile;
                          return Container(
                            padding: EdgeInsets.all(16.sp),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                userProfile!=null?Expanded(
                                  child: Text(
                                    userProfile.referralCode??"",
                                    style: TextStyle(
                                      color: const Color(0xFF2D2D2D),
                                      fontSize: 14.sp,
                                      fontFamily: 'Satoshi',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ):const Spacer(),
                                10.horizontalSpace,
                                GestureDetector(
                                  onTap: () {
                                    if(userProfile!=null){
                                      Clipboard.setData(
                                        ClipboardData(text: userProfile.referralCode??""),
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
                                  onTap: ()async{
                                    String desc="Invite your friends and earn rewards when they join and start mining. The more you refer, the more you earn!. Start sharing and grow your earnings effortlessly";
                                    String referralCode=userProfile!.referralCode??"";
                                    ShareUtils.shareContent(title: referralCode, subject: desc, url: ApiUrls.quanthexWebsite);
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
                                fontSize: 15.sp
                            ),
                          ),
                          15.horizontalSpace,
                          Expanded(
                            child: _buildStatCard(
                              label: mining.subscription!.subRewardAssetName ?? "",
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
        }
    );
  }

  Widget _buildStatCard(
      {required String label, required String value, double? fontSize, bool isFullWidth = false,}) {
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
          )
        ],
      ),
    );
  }
}


