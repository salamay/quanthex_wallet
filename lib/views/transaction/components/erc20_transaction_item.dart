import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/data/Models/transactions/erc20_transfer_dto.dart';
import 'package:quanthex/data/utils/my_currency_utils.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/routes/app_routes.dart';
import 'package:quanthex/views/transaction/components/transaction_status_badge.dart';
import 'dart:math' as math;

enum TransactionType { receive, send }

class Erc20TransactionItem extends StatelessWidget {
  final TransactionType type;
  final Erc20TransferDto erc20Tx;
  final VoidCallback? onTap;
  final String? networkName;
  final String? networkSymbol;
  final String? walletName;
  Erc20TransactionItem({super.key, required this.type, required this.erc20Tx, this.onTap, this.networkName, this.networkSymbol, this.walletName});

  @override
  Widget build(BuildContext context) {
    BigInt value = BigInt.parse(erc20Tx.value ?? "0");
    final amount = value / BigInt.from(math.pow(10, int.parse(erc20Tx.tokenDecimals ?? "18")));
    final isReceive = type == TransactionType.receive;
    final iconColor = isReceive ? const Color(0xFF4CAF50) : const Color(0xFFF44336);
    final amountColor = isReceive ? const Color(0xFF4CAF50) : const Color(0xFFF44336);
    final icon = isReceive ? Icons.arrow_downward : Icons.arrow_upward;
    // final typeText = isReceive ? 'Receive' : 'Send';

    return GestureDetector(
      onTap:
          onTap ??
          () {
            Navigate.toNamed(
              context,
              name: AppRoutes.transactiondetailsview,
              args: {
                'amount': MyCurrencyUtils.formatCurrency2(amount.toDouble()),
                'tokenSymbol': erc20Tx.tokenSymbol ?? '',
                'fromAddress': erc20Tx.fromAddress ?? '',
                'toAddress': erc20Tx.toAddress ?? '',
                'fromLabel': erc20Tx.fromAddressEntity,
                'toLabel': erc20Tx.toAddressEntity,
                'networkFee': '0', // ERC20 network fee would need to be calculated separately
                'networkSymbol': networkSymbol ?? '',
                'transactionHash': erc20Tx.transactionHash ?? '',
                'blockNumber': erc20Tx.blockNumber ?? '',
                'timestamp': erc20Tx.blockTimestamp ?? '',
                'walletName': walletName,
                'isReceive': type == TransactionType.receive,
                'isSuccess': true,
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
                          '${erc20Tx.fromAddress!.substring(0, 6)}...${erc20Tx.fromAddress!.substring(erc20Tx.fromAddress!.length - 4)}',
                          style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  4.verticalSpace,
                  erc20Tx.fromAddressEntity != null
                      ? Text(
                          erc20Tx.fromAddressEntity ?? "",
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
                      '${erc20Tx.tokenSymbol}',
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
