import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/data/Models/assets/supported_assets.dart';
import 'package:quanthex/data/utils/my_currency_utils.dart';

import '../../../core/constants/network_constants.dart';
import '../../../data/Models/balance/CoinBalance.dart';
import '../../../data/controllers/balance/balance_controller.dart';
import 'coin_image.dart';

class AssetItem extends StatelessWidget {
  AssetItem({super.key, required this.coin});

  SupportedCoin coin;


  
  @override
  Widget build(BuildContext context) {
    return Container(
     margin: EdgeInsets.symmetric(horizontal: 0.sp, vertical: 6.sp),
      padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 16.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0).withOpacity(0.5), width: 1),
      ),
      child:  Consumer<BalanceController>(
        builder: (context, bCtr, child) {
          double? priceQuotes=bCtr.priceQuotes[coin.symbol];
          CoinBalance? balance=coin.coinType==CoinType.TOKEN?bCtr.balances[coin.contractAddress!]:bCtr.balances[coin.symbol];
          return Row(
            children: [
              CoinImage(imageUrl: coin.image, height: 30.sp, width: 30.sp,),
              8.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coin.name,
                      style: TextStyle(
                        color: const Color(0xFF2D2D2D),
                        fontSize: 16.sp,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          coin.symbol,
                          style: TextStyle(
                            color: const Color(0xFF2D2D2D),
                            fontSize: 14.sp,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        4.horizontalSpace,
                        Text(
                          "(${coin.networkModel!.chainSymbol.toUpperCase()})",
                          style: TextStyle(
                            color: const Color(0xFF2D2D2D),
                            fontSize: 10.sp,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    4.verticalSpace,
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  balance!=null?Text(
                    !bCtr.hideBalance?balance.balanceInCrypto!=0?MyCurrencyUtils.format(balance.balanceInCrypto,coin.coinType==CoinType.TOKEN?2:6):"0 ":"****",
                    style: TextStyle(
                      color: const Color(0xFF2D2D2D),
                      fontSize: 16.sp,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w600,
                    ),
                  ):const SizedBox(),
                  4.verticalSpace,
                  balance!=null?Text(
                      !bCtr.hideBalance?" ${MyCurrencyUtils.formatCurrency(balance.balanceInFiat)}":"**",
                    style: TextStyle(
                      color: const Color(0xFF757575),
                      fontSize: 12.sp,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w400,
                    )
                  ):const SizedBox()
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
