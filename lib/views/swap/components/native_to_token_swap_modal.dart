import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/core/constants/network_constants.dart';
import 'package:quanthex/data/Models/assets/supported_assets.dart';
import 'package:quanthex/data/Models/network/network_model.dart';
import 'package:quanthex/data/Models/swap/model/swap_payload.dart';
import 'package:quanthex/data/utils/my_currency_utils.dart';
import 'package:quanthex/views/home/components/coin_image.dart';
import 'package:quanthex/widgets/app_button.dart';

class NativeToTokenSwapModal extends StatefulWidget {
  const NativeToTokenSwapModal({super.key, required this.swapPayload, this.onSwap});

  final SwapPayload swapPayload;
  final VoidCallback? onSwap;

  @override
  State<NativeToTokenSwapModal> createState() => _NativeToTokenSwapModalState();
}

class _NativeToTokenSwapModalState extends State<NativeToTokenSwapModal> {
  bool _showMore = false;

  @override
  Widget build(BuildContext context) {
    final payload = widget.swapPayload;
    final fromToken = payload.pair.token0;
    final toToken = payload.pair.token1;
    final amountIn = payload.amountIn ?? payload.userAmount ?? 0.0;
    final amountOut = payload.amountOut ?? 0.0;
    final networkFee = payload.networkFee;

    // Calculate fiat equivalents
    // Note: In a real scenario, you would fetch prices from a price API
    // For now, we'll use a simple calculation or show placeholder values
    double fromAmountInFiat = 0.0;
    double toAmountInFiat = 0.0;

    // If networkFee has feeInFiat, we can estimate based on that
    // Otherwise, calculate approximate fiat values (you may want to fetch actual prices)
    if (networkFee != null && networkFee.feeInFiat > 0) {
      // Use a rough estimation - in production, fetch actual token prices
      fromAmountInFiat = amountIn * 3200; // Example ETH price
      toAmountInFiat = amountOut * 1; // Example USDC price (1:1 with USD)
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      padding: EdgeInsets.all(24.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40.sp,
              height: 4.sp,
              margin: EdgeInsets.only(bottom: 20.sp),
              decoration: BoxDecoration(color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(2)),
            ),
          ),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "You're swapping",
                style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 18.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 32.sp,
                  height: 32.sp,
                  decoration: BoxDecoration(color: const Color(0xFFF5F5F5), shape: BoxShape.circle),
                  child: Icon(Icons.close, size: 20.sp, color: const Color(0xFF2D2D2D)),
                ),
              ),
            ],
          ),

          24.sp.verticalSpace,

          // Swap From Section
          _buildSwapSection(amount: amountIn, symbol: fromToken.symbol, fiatAmount: fromAmountInFiat, token: fromToken),

          16.sp.verticalSpace,

          // Arrow Icon
          Center(
            child: Container(
              width: 40.sp,
              height: 40.sp,
              decoration: BoxDecoration(color: const Color(0xFFF5F5F5), shape: BoxShape.circle),
              child: Icon(Icons.arrow_downward, size: 24.sp, color: const Color(0xFF757575)),
            ),
          ),

          16.sp.verticalSpace,

          // Swap To Section
          _buildSwapSection(amount: amountOut, symbol: toToken.symbol, fiatAmount: toAmountInFiat, token: toToken),

          20.sp.verticalSpace,

          // Show More Button
          Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showMore = !_showMore;
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Show more',
                    style: TextStyle(color: const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                  ),
                  8.horizontalSpace,
                  Icon(_showMore ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 20.sp, color: const Color(0xFF757575)),
                ],
              ),
            ),
          ),

          // Cost Details (shown when expanded)
          if (_showMore) ...[20.sp.verticalSpace, _buildCostDetails(networkFee, fromToken)],

          30.sp.verticalSpace,

          // Swap Button
          AppButton(
            text: 'Swap',
            color: const Color(0xFF792A90),
            textColor: Colors.white,
            onTap: () {
              if (widget.onSwap != null) {
                widget.onSwap!();
              }
              Navigator.of(context).pop();
            },
          ),

          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  Widget _buildSwapSection({required double amount, required String symbol, required double fiatAmount, required SupportedCoin token}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${MyCurrencyUtils.format(amount, token.coinType == CoinType.TOKEN ? 2 : 6)} $symbol',
                style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 24.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
              ),
              4.sp.verticalSpace,
              Text(
                '\$${MyCurrencyUtils.format(fiatAmount, 2)}',
                style: TextStyle(color: const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        Container(
          width: 56.sp,
          height: 56.sp,
          decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
          child: CoinImage(imageUrl: token.image.isNotEmpty ? token.image : (token.networkModel?.imageUrl ?? ''), width: 56.sp, height: 56.sp),
        ),
      ],
    );
  }

  Widget _buildCostDetails(NetworkFee? networkFee, SupportedCoin token) {
    return Column(
      children: [
        // Fee Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Fee',
                  style: TextStyle(color: const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                ),
                4.horizontalSpace,
                Container(
                  width: 16.sp,
                  height: 16.sp,
                  decoration: BoxDecoration(color: const Color(0xFF792A90).withOpacity(0.1), shape: BoxShape.circle),
                  child: Icon(Icons.info_outline, size: 12.sp, color: const Color(0xFF792A90)),
                ),
              ],
            ),
            Text(
              'Free',
              style: TextStyle(color: const Color(0xFFFF69B4), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
            ),
          ],
        ),

        16.sp.verticalSpace,

        // Network Cost Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Network cost',
                  style: TextStyle(color: const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                ),
                4.horizontalSpace,
                Container(
                  width: 16.sp,
                  height: 16.sp,
                  decoration: BoxDecoration(color: const Color(0xFF792A90).withOpacity(0.1), shape: BoxShape.circle),
                  child: Icon(Icons.info_outline, size: 12.sp, color: const Color(0xFF792A90)),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CoinImage(imageUrl: token.networkModel?.imageUrl ?? '', width: 20.sp, height: 20.sp),
                8.horizontalSpace,
                Text(
                  networkFee != null ? '\$${MyCurrencyUtils.format(networkFee.feeInFiat, 2)}' : '\$0.00',
                  style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
