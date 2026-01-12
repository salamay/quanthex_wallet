import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/data/Models/assets/supported_assets.dart';
import 'package:quanthex/data/Models/network/network_model.dart';
import 'package:quanthex/data/utils/my_currency_utils.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/views/home/components/coin_image.dart';
import 'package:wallet/wallet.dart';

/// A reusable bottom sheet widget for displaying estimated transaction fees
class TransactionFeeBottomSheet extends StatelessWidget {
  /// Title of the bottom sheet
  final String title;

  /// Description/Subtitle text
  final String? description;

  /// Action button text (e.g., "Confirm", "Continue", "Proceed")
  final String actionButtonText;

  /// Network fee information
  final NetworkFee networkFee;

  /// Network symbol (e.g., "ETH", "BSC", "MATIC")
  final String networkSymbol;

  /// Network image URL
  final String? networkImageUrl;

  /// Token information (optional)
  final SupportedCoin? token;

  /// Custom action button color (optional)
  final Color? actionButtonColor;

  /// Custom action button text color (optional)
  final Color? actionButtonTextColor;

  /// Whether to show a close button
  final bool showCloseButton;

  const TransactionFeeBottomSheet({super.key, required this.title, this.description, required this.actionButtonText, required this.networkFee, required this.networkSymbol, this.networkImageUrl, this.token, this.actionButtonColor, this.actionButtonTextColor, this.showCloseButton = true});

  /// Shows the transaction fee bottom sheet as a modal

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.all(24.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
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
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 20.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                    ),
                    if (description != null) ...[
                      8.sp.verticalSpace,
                      Text(
                        description!,
                        style: TextStyle(color: const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                      ),
                    ],
                  ],
                ),
              ),
              if (showCloseButton)
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    // onDismiss?.call();
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.sp),
                    decoration: BoxDecoration(color: const Color(0xFFF5F5F5), shape: BoxShape.circle),
                    child: Icon(Icons.close, size: 20.sp, color: const Color(0xFF2D2D2D)),
                  ),
                ),
            ],
          ),
          24.sp.verticalSpace,
          // Network/Token Info Section
          if (networkImageUrl != null || token != null)
            Container(
              padding: EdgeInsets.all(16.sp),
              decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  // Network/Token Image
                  Container(
                    width: 48.sp,
                    height: 48.sp,
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: networkImageUrl != null
                        ? CoinImage(imageUrl: networkImageUrl!, width: 48.sp, height: 48.sp)
                        : token != null
                        ? CoinImage(imageUrl: token!.image, width: 48.sp, height: 48.sp)
                        : Container(color: const Color(0xFFF5F5F5)),
                  ),
                  12.horizontalSpace,

                  // Network/Token Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (token != null)
                          Text(
                            token!.name,
                            style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                          ),
                        if (token != null) 4.sp.verticalSpace,
                        Row(
                          children: [
                            Text(
                              token != null ? token!.symbol : networkSymbol,
                              style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                            ),
                            if (token != null && token!.networkModel != null) ...[
                              4.horizontalSpace,
                              Text(
                                "(${token!.networkModel!.chainSymbol.toUpperCase()})",
                                style: TextStyle(color: const Color(0xFF757575), fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          if (networkImageUrl != null || token != null) 20.sp.verticalSpace,

          // Fee Details Section
          Container(
            padding: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(
              color: const Color(0xFFFAE9FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF792A90).withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estimated Transaction Fee',
                  style: TextStyle(color: const Color(0xFF792A90), fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                ),
                16.sp.verticalSpace,

                // Fee in Crypto
                _buildFeeRow(
                  label: 'Network Fee',
                  value: '${MyCurrencyUtils.format(networkFee.feeInCrypto, networkFee.feeInCrypto < 0.01 ? 6 : 4)} $networkSymbol',
                  valueStyle: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                ),

                12.sp.verticalSpace,

                // Fee in Fiat
                _buildFeeRow(
                  label: 'Fee (USD)',
                  value: '\$${MyCurrencyUtils.format(networkFee.feeInFiat, 2)}',
                  valueStyle: TextStyle(color: const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                ),
                12.sp.verticalSpace,
                // Gas Price
                _buildFeeRow(
                  label: 'Gas Price',
                  value: _formatGasPrice(networkFee.gasPrice),
                  valueStyle: TextStyle(color: const Color(0xFF757575), fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                ),

                12.sp.verticalSpace,

                // Max Gas
                _buildFeeRow(
                  label: 'Max Gas',
                  value: _formatGasPrice(BigInt.from(networkFee.maxGas)),
                  valueStyle: TextStyle(color: const Color(0xFF757575), fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          24.sp.verticalSpace,
          // Action Button
          GestureDetector(
            onTap: () {
              Navigate.back(context,args: true);
            },
            child: Container(
              width: double.infinity,
              height: 50.sp,
              decoration: BoxDecoration(color: actionButtonColor ?? const Color(0xFF792A90), borderRadius: BorderRadius.circular(25)),
              child: Center(
                child: Text(
                  actionButtonText,
                  style: TextStyle(color: actionButtonTextColor ?? Colors.white, fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeeRow({required String label, required String value, required TextStyle valueStyle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
        ),
        Text(value, style: valueStyle),
      ],
    );
  }

  String _formatGasPrice(BigInt gasPrice) {
    return '${EtherAmount.fromBigInt(EtherUnit.wei, gasPrice).getValueInUnit(EtherUnit.gwei).toDouble()} Gwei';
  }
}
