import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/core/network/Api_url.dart';
import 'package:quanthex/data/Models/mining/mining_dto.dart';
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
import 'package:quanthex/views/mining/components/horizontal_divider.dart';
import 'package:quanthex/views/mining/components/mining_simulation_widget.dart';
import 'package:quanthex/views/mining/components/mining_stat_item.dart';
import 'package:quanthex/views/mining/components/referral_card.dart';
import 'package:quanthex/views/mining/components/stat_card.dart';
import 'package:quanthex/views/mining/components/summary_card.dart';
import 'package:quanthex/widgets/global/error_modal.dart';
import 'package:skeletonizer/skeletonizer.dart';

const Color kAccentPurple = Color(0xFF792A90);
const Color greenColor = Color(0xffA8EBCF);

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
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigate.back(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.sp),
        ),
      ),
      body: Consumer<UserController>(
        builder: (context, userCtr, child) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken),
                image: AssetImage('assets/images/green_astro_bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.all(16.sp),
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
                        effect: ShimmerEffect(
                          duration: Duration(milliseconds: 1000),
                          baseColor: Colors.grey.withOpacity(0.4),
                          highlightColor: Colors.white54,
                        ),
                        child: Builder(
                          builder: (context) {
                            MiningDto mining = widget.mining;
                            String miningSubscriptionId = mining.subscription!.subId ?? "";
                            List<ReferralDto> directReferrals = miningController.miningDirectReferrals[miningSubscriptionId] ?? [];
                            int totalReferrals = directReferrals.length;
                            String packageName = mining.subscription!.subPackageName ?? "";
                            double hashRate = ProductUtils.getHashRate(noOfReferrals: totalReferrals, packageName: packageName);
                            double amountEarned = SubUtils.calcAmountEarned(packageName: packageName, noOfReferrals: totalReferrals);
                            double progressPercent = (totalReferrals / ProductUtils.LEVEL_THREE_REFERRALS).clamp(0.0, 1.0);
                            return !isError
                                ? SingleChildScrollView(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        // Main summary card
                                        SummaryCard(
                                          mining: mining,
                                          hashRate: hashRate,
                                          amountEarned: amountEarned,
                                          progressPercent: progressPercent,
                                          totalReferrals: totalReferrals,
                                        ),
                                        20.sp.verticalSpace,
                                        // Referral link card (dark)
                                        ReferralCard(miningTag: mining.mining!.miningTag ?? ""),
                                        20.sp.verticalSpace,
                                        // Stat cards (dark)
                                        Row(
                                          children: [
                                            Expanded(child: StatCard(label: 'Active Members', value: totalReferrals.toString())),
                                            12.horizontalSpace,
                                            Expanded(child: StatCard(label: 'Package', value: packageName)),
                                          ],
                                        ),
                                        12.sp.verticalSpace,
                                        Row(
                                          children: [
                                            Expanded(
                                              child: StatCard(
                                                label: 'Mining Speed',
                                                value: "$hashRate Hex MH/s",
                                                fontSize: 13.sp,
                                              ),
                                            ),
                                            12.horizontalSpace,
                                            Expanded(
                                              child: Consumer<BalanceController>(
                                                builder: (context, balanceCtr, child) {
                                                  double rewardPriceQuotes = balanceCtr.priceQuotes[mining.subscription!.subRewardAssetSymbol ?? ""] ?? 0;
                                                  double amountInCrypto = rewardPriceQuotes > 0 ? amountEarned / rewardPriceQuotes : 0;
                                                  return Skeletonizer(
                                                    enabled: balanceCtr.isLoadingPriceQuotes,
                                                    effect: ShimmerEffect(duration: Duration(milliseconds: 1000), baseColor: Colors.grey.withOpacity(0.4), highlightColor: Colors.white54),
                                                    ignoreContainers: false,
                                                    child: StatCard(
                                                      label: mining.subscription!.subRewardAssetSymbol ?? "",
                                                      value: MyCurrencyUtils.format(amountInCrypto, 4),
                                                      fontSize: 14.sp,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        12.sp.verticalSpace,
                                        Row(
                                          children: [
                                            Expanded(
                                              child: HashCard(
                                                label: 'Giga Hash',
                                                value: "$hashRate Hex MH/s",
                                                isInProgress: !(totalReferrals >= ProductUtils.LEVEL_ONE_REFERRALS),
                                                fontSize: 15.sp,
                                              ),
                                            ),
                                            12.horizontalSpace,
                                            Expanded(
                                              child: HashCard(
                                                label: "Tera Hash",
                                                value: "$hashRate Hex MH/s",
                                                isInProgress: !(totalReferrals >= ProductUtils.LEVEL_TWO_REFERRALS),
                                              ),
                                            ),
                                          ],
                                        ),
                                        12.sp.verticalSpace,
                                        Row(
                                          children: [
                                            Expanded(
                                              child: HashCard(
                                                label: "Peta Hash",
                                                value: "$hashRate Hex MH/s",
                                                isInProgress: !(totalReferrals >= ProductUtils.LEVEL_THREE_REFERRALS),
                                              ),
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

}

