import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/data/Models/mining/mining_dto.dart';
import 'package:quanthex/data/controllers/balance/balance_controller.dart';
import 'package:quanthex/data/utils/my_currency_utils.dart';
import 'package:quanthex/data/utils/product_utils.dart';
import 'package:quanthex/views/home/components/coin_image.dart';
import 'package:quanthex/views/mining/components/horizontal_divider.dart';
import 'package:quanthex/views/mining/components/mining_simulation_widget.dart';
import 'package:quanthex/views/mining/components/mining_stat_item.dart';
import 'package:quanthex/views/mining/mining_view.dart';

class SummaryCard extends StatelessWidget {
  SummaryCard({super.key, required this.mining, required this.hashRate, required this.amountEarned, required this.progressPercent, required this.totalReferrals});
  MiningDto mining;
  double hashRate;
  double amountEarned;
  double progressPercent;
  int totalReferrals;
  
  @override
  Widget build(BuildContext context) {
     final sub = mining.subscription!;
    final rewardSymbol = sub.subRewardAssetSymbol ?? '—';
    return Container(
      child: Consumer<BalanceController>(
        builder: (context, balanceCtr, _) {
          double rewardPriceQuotes = balanceCtr.priceQuotes[rewardSymbol] ?? 0;
          double amountInCrypto = rewardPriceQuotes > 0 ? amountEarned / rewardPriceQuotes : 0;
          String totalEarnedStr = balanceCtr.isLoadingPriceQuotes ? '...' : MyCurrencyUtils.format(amountInCrypto, 2);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.rocket_launch_outlined, size: 22.sp, color: Colors.white70),
                  8.sp.horizontalSpace,
                  Expanded(
                    child: Text(
                      sub.subPackageName ?? 'Starter Package',
                      style: TextStyle(color: Colors.white, fontSize: 18.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 6.sp),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6.sp,
                          height: 6.sp,
                          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        ),
                        6.sp.horizontalSpace,
                        Text(
                          'ACTIVE',
                          style: TextStyle(color: Colors.white, fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              16.sp.verticalSpace,
              if (sub.subPrice != null)
                Text(
                  '\$${sub.subPrice!.toStringAsFixed(0)}',
                  style: TextStyle(color: Colors.white, fontSize: 28.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                ),
              10.sp.verticalSpace,
              HorizontalDivider(),
              10.sp.verticalSpace,
              Container(
                padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 12.sp),
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    Expanded(
                      child: MiningStatItem(icon: Icons.bolt, label: 'Hash Power', value: '$hashRate Hex MH/s', accentColor: kAccentPurple),
                    ),
                    Container(width: 1, height: 36.sp, color: Colors.white24),
                    Expanded(
                      child: MiningStatItem(icon: Icons.monetization_on_outlined, label: 'Total Earned', value: '$totalEarnedStr $rewardSymbol', accentColor: kAccentPurple),
                    ),
                  ],
                ),
              ),
              10.sp.verticalSpace,
              HorizontalDivider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Progress',
                    style: TextStyle(color: Colors.white, fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                  ),
                  8.sp.horizontalSpace,
                  Expanded(
                    child: Center(
                      child: MiningSimulationWidget(
                        totalReferrals: totalReferrals,
                        fluctuationRange: totalReferrals != ProductUtils.LEVEL_THREE_REFERRALS ? 0.1 : 0.0,
                        animationSpeed: Duration(milliseconds: hashRate != ProductUtils.LEVEL_FOUR_HASHRATE ? 100 : 1000000000),
                            hashUnit: "Hex MH/s",
                            hashRate: hashRate,
                      ),
                    ),
                  ),
                ],
              ),
              12.sp.verticalSpace,
              Row(
                children: [
                  CoinImage(imageUrl: mining.subscription?.subRewardAssetImage ?? "", height: 20.sp, width: 20.sp),
                  4.sp.horizontalSpace,
                  Text(
                    'Reward: $rewardSymbol',
                    style: TextStyle(color: Colors.white, fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
