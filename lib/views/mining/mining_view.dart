import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/core/network/Api_url.dart';
import 'package:quanthex/data/Models/mining/mining_dto.dart';
import 'package:quanthex/data/Models/users/profile_dto.dart';
import 'package:quanthex/data/Models/users/referral_dto.dart';
import 'package:quanthex/data/controllers/assets/asset_controller.dart';
import 'package:quanthex/data/controllers/balance/balance_controller.dart';
import 'package:quanthex/data/controllers/mining/mining_controller.dart';
import 'package:quanthex/data/controllers/user/user_controller.dart';
import 'package:quanthex/data/utils/logger.dart';
import 'package:quanthex/data/utils/my_currency_utils.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/data/utils/product_utils.dart';
import 'package:quanthex/data/utils/share/share_utils.dart';
import 'package:quanthex/data/utils/sub/sub_utils.dart';
import 'package:quanthex/views/mining/components/hash_card.dart';
import 'package:quanthex/views/mining/components/mining_simulation_widget.dart';
import 'package:quanthex/widgets/global/error_modal.dart';
import 'package:quanthex/widgets/quanthex_image_banner.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'earning_breakdown_modal.dart';

class MiningView extends StatefulWidget {
  MiningView({super.key, required this.mining});

  MiningDto mining;

  @override
  State<MiningView> createState() => _MiningViewState();
}

class _MiningViewState extends State<MiningView> {
  late AssetController assetController;
  ValueNotifier<bool> _loadingNotifier = ValueNotifier(true);
  ValueNotifier<bool> _errorNotifier = ValueNotifier(false);
  late MiningController miningController;
  late UserController userController;

  @override
  void initState() {
    // TODO: implement initState
    assetController = Provider.of<AssetController>(context, listen: false);
    miningController = Provider.of<MiningController>(context, listen: false);
    userController = Provider.of<UserController>(context, listen: false);
    fetchData();
    super.initState();
  }

  void fetchData() async {
    try {
      _loadingNotifier.value = true;
      _errorNotifier.value = false;
      String miningSubscriptionId = widget.mining.subscription!.subId ?? "";
      await miningController.getSubscriptionReferrals(miningSubscriptionId);
      _loadingNotifier.value = false;
      _errorNotifier.value = false;
    } catch (e) {
      logger("Error fetching data: $e", runtimeType.toString());
      _errorNotifier.value = true;
      _loadingNotifier.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Mining',
          style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 20.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          onPressed: () {
            Navigate.back(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: Consumer<UserController>(
        builder: (context, userCtr, child) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(16.sp),
            color: Colors.white,
            child: SafeArea(
              child: ValueListenableBuilder(
                valueListenable: _loadingNotifier,
                builder: (context, loading, child) {
                  return ValueListenableBuilder(
                    valueListenable: _errorNotifier,
                    builder: (context, isError, child) {
                      return Skeletonizer(
                        ignoreContainers: false,
                        enabled: loading,
                        effect: ShimmerEffect(duration: Duration(milliseconds: 1000), baseColor: Colors.grey.withOpacity(0.4), highlightColor: Colors.white54),
                        child: Builder(
                          builder: (context) {
                            MiningDto mining = widget.mining;
                            String miningSubscriptionId = mining.subscription!.subId ?? "";
                            List<ReferralDto> directReferrals = miningController.miningDirectReferrals[miningSubscriptionId] ?? [];
                            int totalReferrals = directReferrals.length;
                            String packageName = mining.subscription!.subPackageName ?? "";
                            double hashRate = ProductUtils.getHashRate(noOfReferrals: totalReferrals, packageName: packageName);
                            double amountEarned = SubUtils.calcAmountEarned(packageName: packageName, noOfReferrals: totalReferrals);
                            return !isError
                                ? SingleChildScrollView(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    child: Column(
                                      children: [
                                        // Quanthex Image Banner
                                        Center(
                                          child: SizedBox(
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                MiningSimulationWidget(
                                                  baseHashRate: hashRate, // Static hash rate value
                                                  fluctuationRange: hashRate != ProductUtils.LEVEL_FOUR_HASHRATE ? 0.12 : 0.0, // 12% fluctuation range
                                                  animationSpeed: Duration(milliseconds: hashRate != ProductUtils.LEVEL_FOUR_HASHRATE ? 100 : 1000000000), // Animation speed
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
                                            String miningTag = mining.mining!.miningTag ?? "";
                                            return Container(
                                              padding: EdgeInsets.all(16.sp),
                                              decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(16)),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      miningTag,
                                                      style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                                                    ),
                                                  ),
                                                  10.horizontalSpace,
                                                  GestureDetector(
                                                    onTap: () {
                                                      Clipboard.setData(ClipboardData(text: miningTag));
                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Link copied')));
                                                    },
                                                    child: Icon(Icons.copy, size: 20.sp, color: const Color(0xFF757575)),
                                                  ),
                                                  10.horizontalSpace,
                                                  GestureDetector(
                                                    onTap: () async {
                                                      String desc = "Invite your friends and earn mining outputs when they join and start mining. The more you refer, the more you earn!. Start sharing and grow your minigs effortlessly";
                                                      String miningTag = mining.mining!.miningTag ?? "";
                                                      ShareUtils.shareContent(title: miningTag, subject: desc, url: ApiUrls.quanthexWebsite);
                                                    },
                                                    child: Icon(Icons.share, size: 20.sp, color: const Color(0xFF757575)),
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
                                              child: _buildStatCard(label: 'Active Members', value: totalReferrals.toString()),
                                            ),
                                            15.horizontalSpace,
                                            Expanded(
                                              child: _buildStatCard(label: 'Package name', value: packageName),
                                            ),
                                          ],
                                        ),
                                        15.sp.verticalSpace,
                                        Row(
                                          children: [
                                            Expanded(
                                              child: _buildStatCard(label: 'Current Mining Speed', value: "$hashRate Hex MH/s", isFullWidth: true, fontSize: 15.sp),
                                            ),
                                            15.horizontalSpace,
                                            Expanded(
                                              child: Consumer<BalanceController>(
                                                builder: (context, balanceCtr, child) {
                                                  double rewardPriceQuotes = balanceCtr.priceQuotes[mining.subscription!.subRewardAssetSymbol ?? ""] ?? 0;
                                                  logger("Reward Price Quotes: $rewardPriceQuotes", runtimeType.toString());
                                                  logger("Is Loading Price Quotes: ${balanceCtr.isLoadingPriceQuotes}", runtimeType.toString());
                                                  double amountInCrypto = amountEarned / rewardPriceQuotes;
                                                  return Skeletonizer(
                                                    enabled: balanceCtr.isLoadingPriceQuotes,
                                                    effect: ShimmerEffect(duration: Duration(milliseconds: 1000), baseColor: Colors.grey.withOpacity(0.4), highlightColor: Colors.white54),
                                                    ignoreContainers: false,
                                                    child: _buildStatCard(label: rewardPriceQuotes == 0 ? "" : mining.subscription!.subRewardAssetSymbol ?? "", value: MyCurrencyUtils.format(amountInCrypto, 4), isFullWidth: true),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        15.sp.verticalSpace,
                                        Row(
                                          children: [
                                            Expanded(
                                              child: HashCard(label: 'Giga Hash', value: "$hashRate Hex MH/s", isInProgress: !(totalReferrals >= ProductUtils.LEVEL_ONE_REFERRALS), fontSize: 15.sp),
                                            ),
                                            15.horizontalSpace,
                                            Expanded(
                                              child: HashCard(label: "Tera Hash", value: "$hashRate Hex MH/s", isInProgress: !(totalReferrals >= ProductUtils.LEVEL_TWO_REFERRALS)),
                                            ),
                                          ],
                                        ),
                                        15.sp.verticalSpace,
                                        Row(
                                          children: [
                                            Expanded(
                                              child: HashCard(label: "Peta Hash", value: "$hashRate Hex MH/s", isInProgress: !(totalReferrals >= ProductUtils.LEVEL_THREE_REFERRALS)),
                                            ),
                                          ],
                                        ),
                                        40.sp.verticalSpace,
                                      ],
                                    ),
                                  )
                                : Center(
                                    child: ErrorModal(
                                      callBack: () {
                                        _errorNotifier.value = false;
                                        _loadingNotifier.value = true;
                                        fetchData();
                                      },
                                    ),
                                  );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard({required String label, required String value, double? fontSize, bool isFullWidth = false}) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      height: 80.sp,
      decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(color: const Color(0xFF757575), fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
          ),
          2.sp.verticalSpace,
          AutoSizeText(
            value,
            maxLines: 1,
            style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: fontSize ?? 20.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
