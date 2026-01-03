import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/data/Models/transactions/native_tx_dto.dart';
import 'package:quanthex/data/utils/my_currency_utils.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/routes/app_routes.dart';
import 'package:quanthex/views/transaction/components/erc20_transaction_item.dart';
import 'package:quanthex/views/transaction/components/transaction_status_badge.dart';
import 'dart:math' as math;

class NativeTxItem extends StatelessWidget {
  final TransactionType type;
  final NativeTxDto nativeTx;
  final String tokenSymbol;
  final VoidCallback? onTap;
  final String? networkName;
  final String? walletName;
  NativeTxItem({super.key, required this.type, required this.nativeTx, required this.tokenSymbol, this.onTap, this.networkName, this.walletName});

  @override
  Widget build(BuildContext context) {
    BigInt value = BigInt.parse(nativeTx.value ?? "0");
    final amount = value / BigInt.from(math.pow(10, 18));
    final isReceive = type == TransactionType.receive;
    final iconColor = isReceive ? const Color(0xFF4CAF50) : const Color(0xFFF44336);
    final amountColor = isReceive ? const Color(0xFF4CAF50) : const Color(0xFFF44336);
    final icon = isReceive ? Icons.arrow_downward : Icons.arrow_upward;
    // final typeText = isReceive ? 'Receive' : 'Send';

    return GestureDetector(
      onTap:
          onTap ??
          () {
            // Calculate network fee
            String networkFee = '0';
            if (nativeTx.transactionFee != null && nativeTx.transactionFee!.isNotEmpty) {
              try {
                final fee = BigInt.parse(nativeTx.transactionFee!);
                final feeAmount = fee / BigInt.from(math.pow(10, 18));
                networkFee = MyCurrencyUtils.formatCurrency2(feeAmount.toDouble());
              } catch (e) {
                networkFee = '0';
              }
            }

            Navigate.toNamed(
              context,
              name: AppRoutes.transactiondetailsview,
              args: {
                'amount': MyCurrencyUtils.formatCurrency2(amount.toDouble()),
                'tokenSymbol': tokenSymbol,
                'fromAddress': nativeTx.fromAddress ?? '',
                'toAddress': nativeTx.toAddress ?? '',
                'fromLabel': nativeTx.fromAddressLabel,
                'toLabel': nativeTx.toAddressLabel,
                'networkFee': networkFee,
                'networkSymbol': tokenSymbol,
                'transactionHash': nativeTx.hash ?? '',
                'blockNumber': nativeTx.blockNumber ?? '',
                'timestamp': nativeTx.blockTimestamp ?? '',
                'walletName': walletName,
                'isReceive': type == TransactionType.receive,
                'isSuccess': nativeTx.receiptStatus == '1',
                'networkName': networkName,
              },
            );
          },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 0.sp),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: const Color(0xFF1E1E1E).withOpacity(0.1), width: 1)),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48.sp,
              height: 48.sp,
              decoration: BoxDecoration(color: iconColor.withOpacity(0.15), shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 24.sp),
            ),
            8.horizontalSpace,
            // Address and Type
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          '${nativeTx.fromAddress!.substring(0, 6)}...${nativeTx.fromAddress!.substring(nativeTx.fromAddress!.length - 4)}',
                          style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  4.verticalSpace,
                  nativeTx.fromAddressEntity != null
                      ? Text(
                          nativeTx.fromAddressEntity ?? "",
                          style: TextStyle(color: const Color(0xFF757575), fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                        )
                      : const SizedBox(),
                  4.verticalSpace,
                  TransactionStatusBadge(status: TransactionStatus.completed),
                ],
              ),
            ),
            12.horizontalSpace,
            // Amount
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      MyCurrencyUtils.formatCurrency2(amount),
                      style: TextStyle(color: amountColor, fontSize: 15.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                    ),
                    4.horizontalSpace,
                    Text(
                      '${tokenSymbol}',
                      style: TextStyle(color: const Color(0xFF757575), fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                // if (usdAmount != null) ...[
                //   4.verticalSpace,
                //   Text(
                //     usdAmount!,
                //     style: TextStyle(color: const Color(0xFF757575), fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                //   ),
                // ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
