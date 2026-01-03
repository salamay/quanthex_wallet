import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/data/Models/assets/supported_assets.dart';
import 'package:quanthex/data/Models/balance/CoinBalance.dart';
import 'package:quanthex/data/utils/my_currency_utils.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/data/controllers/balance/balance_controller.dart';
import 'package:quanthex/core/constants/network_constants.dart';
import 'package:quanthex/views/home/components/coin_image.dart';

class StakingTokenItem extends StatelessWidget {
  final SupportedCoin coin;
  final VoidCallback? onTap;

  const StakingTokenItem({super.key, required this.coin, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 6.sp),
        padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 16.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E0E0).withOpacity(0.5), width: 1),
        ),
        child: Consumer<BalanceController>(
          builder: (context, bCtr, child) {
            CoinBalance? balance = coin.coinType == CoinType.TOKEN ? bCtr.balances[coin.contractAddress!] : bCtr.balances[coin.symbol];

            double balanceInCrypto = balance?.balanceInCrypto ?? 0.0;
            double balanceInFiat = balance?.balanceInFiat ?? 0.0;
            bool hideBalance = bCtr.hideBalance;

            return Row(
              children: [
                // Token Icon
                CoinImage(imageUrl: coin.image, height: 40.sp, width: 40.sp),
                12.horizontalSpace,
                // Token Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coin.symbol.toUpperCase(),
                        style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                      ),
                      4.verticalSpace,
                      Text(
                        coin.name,
                        style: TextStyle(color: const Color(0xFF757575), fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                // Balance Info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      hideBalance
                          ? '****'
                          : balanceInCrypto != 0
                          ? '${MyCurrencyUtils.format(balanceInCrypto, coin.coinType == CoinType.TOKEN ? 2 : 6)}'
                          : '0.00',
                      style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                    ),
                    4.verticalSpace,
                    Text(
                      hideBalance
                          ? '****'
                          : balanceInFiat > 0
                          ? '${MyCurrencyUtils.formatCurrency(balanceInFiat)} USD'
                          : '\$0.00 USD',
                      style: TextStyle(color: const Color(0xFF757575), fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
