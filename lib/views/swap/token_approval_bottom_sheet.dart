import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/data/Models/assets/network_model.dart';
import 'package:quanthex/data/Models/assets/supported_assets.dart';
import 'package:quanthex/data/Models/network/network_model.dart';
import 'package:quanthex/data/controllers/balance/balance_controller.dart';
import 'package:quanthex/data/services/swap/swap_service.dart';
import 'package:quanthex/data/services/transaction/transaction_service.dart';
import 'package:quanthex/data/utils/logger.dart';
import 'package:quanthex/data/utils/my_currency_utils.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/data/utils/network/gas_fee_check.dart';
import 'package:quanthex/data/utils/overlay_utils.dart';
import 'package:quanthex/widgets/snackbar/my_snackbar.dart';
import 'dart:math' as math;

/// A reusable bottom sheet widget for displaying token approval information
class TokenApprovalBottomSheet extends StatefulWidget {
  /// Title of the bottom sheet
  final String title;

  /// Description/Subtitle text
  final String? description;

  /// Token to be approved
  final SupportedCoin token;

  /// Spender address (who will be approved to spend tokens)
  final String spenderAddress;

  /// Spender name/description (e.g., "Uniswap Router", "DEX Contract")
  final String? spenderName;

  /// Amount to approve (null for unlimited)
  final double? approvalAmount;

  /// Network fee for the approval transaction
  final NetworkFee? networkFee;

  /// Action button text (e.g., "Approve", "Confirm Approval")
  final String actionButtonText;

  /// Callback when bottom sheet is dismissed (optional)
  final VoidCallback? onDismiss;

  /// Custom action button color (optional)
  final Color? actionButtonColor;

  /// Custom action button text color (optional)
  final Color? actionButtonTextColor;

  /// Whether to show a close button
  final bool showCloseButton;

  /// Whether the approval is pending
  bool isUnlimited;

  /// Additional information to display (optional)
  final Map<String, String>? additionalInfo;

  TokenApprovalBottomSheet({
    super.key,
    required this.title,
    this.description,
    required this.token,
    required this.spenderAddress,
    this.spenderName,
    this.approvalAmount,
    this.networkFee,
    required this.actionButtonText,
    this.onDismiss,
    this.actionButtonColor,
    this.actionButtonTextColor,
    this.showCloseButton = true,
    this.additionalInfo,
    this.isUnlimited = false,
  });

  /// Shows the token approval bottom sheet as a modal
  static void show({
    required BuildContext context,
    required String title,
    String? description,
    required SupportedCoin token,
    required String spenderAddress,
    String? spenderName,
    double? approvalAmount,
    bool isUnlimited = false,
    NetworkFee? networkFee,
    required String actionButtonText,
    required VoidCallback onApproveTap,
    VoidCallback? onDismiss,
    Color? actionButtonColor,
    Color? actionButtonTextColor,
    bool showCloseButton = true,
    bool isPending = false,
    bool isAlreadyApproved = false,
    double? currentAllowance,
    Map<String, String>? additionalInfo,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => TokenApprovalBottomSheet(
        title: title,
        description: description,
        token: token,
        spenderAddress: spenderAddress,
        spenderName: spenderName,
        approvalAmount: approvalAmount,
        networkFee: networkFee,
        actionButtonText: actionButtonText,

        onDismiss: onDismiss,
        actionButtonColor: actionButtonColor,
        actionButtonTextColor: actionButtonTextColor,
        showCloseButton: showCloseButton,
        additionalInfo: additionalInfo,
      ),
    );
  }

  @override
  State<TokenApprovalBottomSheet> createState() => _TokenApprovalBottomSheetState();
}

class _TokenApprovalBottomSheetState extends State<TokenApprovalBottomSheet> {
  bool isPending = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.all(8.sp),
      child: SingleChildScrollView(
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
                        widget.title,
                        style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 20.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                      ),
                      if (widget.description != null) ...[
                        8.sp.verticalSpace,
                        Text(
                          widget.description!,
                          style: TextStyle(color: const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                        ),
                      ],
                    ],
                  ),
                ),
                if (widget.showCloseButton)
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      widget.onDismiss?.call();
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
            if (isPending)
              Container(
                padding: EdgeInsets.all(12.sp),
                margin: EdgeInsets.only(bottom: 16.sp),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFF9800).withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20.sp,
                      height: 20.sp,
                      child: CircularProgressIndicator(strokeWidth: 2, color: const Color(0xFFFF9800)),
                    ),
                    8.horizontalSpace,
                    Expanded(
                      child: Text(
                        'Approval transaction pending...',
                        style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),

            // Token Information Section
            Container(
              padding: EdgeInsets.all(16.sp),
              decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  // Token Image
                  Container(
                    width: 48.sp,
                    height: 48.sp,
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: CachedNetworkImage(
                      imageUrl: widget.token.image,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
                        ),
                      ),
                      placeholder: (context, url) => Container(
                        color: const Color(0xFFF5F5F5),
                        child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: const Color(0xFF792A90))),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: const Color(0xFFF5F5F5),
                        child: Icon(Icons.error_outline, size: 24.sp, color: const Color(0xFF757575)),
                      ),
                    ),
                  ),
                  12.horizontalSpace,

                  // Token Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.token.name,
                          style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                        ),
                        4.verticalSpace,
                        Row(
                          children: [
                            Text(
                              widget.token.symbol,
                              style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                            ),
                            if (widget.token.networkModel != null) ...[
                              4.horizontalSpace,
                              Text(
                                "(${widget.token.networkModel!.chainSymbol.toUpperCase()})",
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
            20.sp.verticalSpace,
            // Approval Details Section
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
                    'Approval Details',
                    style: TextStyle(color: const Color(0xFF792A90), fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                  ),
                  16.sp.verticalSpace,

                  // Spender Name/Address
                  _buildDetailRow(
                    label: 'Spender',
                    value: widget.spenderName ?? _formatAddress(widget.spenderAddress),
                    valueStyle: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                  ),

                  12.sp.verticalSpace,

                  // Approval Amount
                  !widget.isUnlimited?_buildDetailRow(
                    label: 'Approval Amount',
                    value: '${MyCurrencyUtils.format(widget.approvalAmount!, (widget.token.decimal ?? 18) > 6 ? 6 : 2)} ${widget.token.symbol}',
                    valueStyle: TextStyle(color: widget.isUnlimited ? const Color(0xFFFF9800) : const Color(0xFF2D2D2D), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                  ):_buildDetailRow(
                    label: 'Approval Amount',
                    value: 'Unlimited ${widget.token.symbol}',
                    valueStyle: TextStyle(color: widget.isUnlimited ? const Color(0xFFFF9800) : const Color(0xFF2D2D2D), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                  ),

                  // Network Fee
                  if (widget.networkFee != null) ...[
                    12.sp.verticalSpace,
                    Divider(color: const Color(0xFF792A90).withOpacity(0.2)),
                    12.sp.verticalSpace,
                    _buildDetailRow(
                      label: 'Network Fee',
                      value: '${MyCurrencyUtils.format(widget.networkFee!.feeInCrypto, widget.networkFee!.feeInCrypto < 0.01 ? 6 : 4)} ${widget.networkFee!.symbol}',
                      valueStyle: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                    ),
                    8.sp.verticalSpace,
                    _buildDetailRow(
                      label: 'Fee (USD)',
                      value: '\$${MyCurrencyUtils.format(widget.networkFee!.feeInFiat, 2)}',
                      valueStyle: TextStyle(color: const Color(0xFF757575), fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                    ),
                  ],
                ],
              ),
            ),

            // Warning for Unlimited Approval
            // if (widget.isUnlimited) ...[
            //   20.sp.verticalSpace,
            //   Container(
            //     padding: EdgeInsets.all(12.sp),
            //     decoration: BoxDecoration(
            //       color: const Color(0xFFFFF3E0),
            //       borderRadius: BorderRadius.circular(8),
            //       border: Border.all(color: const Color(0xFFFF9800).withOpacity(0.3)),
            //     ),
            //     child: Row(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Icon(Icons.warning_amber_rounded, color: const Color(0xFFFF9800), size: 20.sp),
            //         8.horizontalSpace,
            //         Expanded(
            //           child: Text(
            //             'You are approving unlimited tokens. The spender can withdraw any amount from your wallet. Only approve if you trust this address.',
            //             style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400, height: 1.4),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ],

            24.sp.verticalSpace,

            // Action Button
            GestureDetector(
              onTap: () async {
                try{
                if (isPending) {
                  return;
                }
                isPending = true;
                setState(() {});
                BalanceController bCtr = Provider.of<BalanceController>(context, listen: false);
                NetworkModel network = widget.token.networkModel!;
                bool isGas = GasFeeCheck.gasFeeCheck(bCtr: bCtr, chainCurrency: network.chainCurrency, feeInCrypto: widget.networkFee!.feeInCrypto);
                if (isGas) {
                  String walletAddress = widget.token.walletAddress ?? "";
                  String privateKey = widget.token.privateKey ?? "";
                  BigInt amountIn = !widget.isUnlimited?BigInt.from(double.parse(widget.approvalAmount!.toString()) * math.pow(10, widget.token.decimal!)):SwapService.permitUnlimited;

                  String txId = "";
                  try {
                    txId = await SwapService.getInstance().approve(walletAddress: walletAddress, privateKey: privateKey, spender: widget.spenderAddress, spender2: "", token0: widget.token, amountIn: amountIn, fee: widget.networkFee!, isIntermediary: false);
                  } catch (e) {
                    logger(e.toString(), "TokenApprovalBottomSheet");
                    showMySnackBar(context: context, message: "An error occurred while approving", type: SnackBarType.error);
                    return;
                  }
                  TransactionStatus transactionStatus = await TransactionService().waitForTransactionConfirmation(txHash: txId, rpcUrl: network.rpcUrl,pollInterval: 4);
                  if(transactionStatus.isSuccess){
                     isPending = false;
                     setState(() {});
                     Navigate.back(context, args: txId);

                  }else{
                    showMySnackBar(context: context, message: "Transaction failed", type: SnackBarType.error);
                    isPending = false;
                    setState(() {});
                  }
             
                } else {
                  showMySnackBar(context: context, message: "Insufficient balance for gas fee", type: SnackBarType.error);
                  isPending = false;
                  setState(() {});
                  
                }
              }catch(e){
                isPending = false;
                setState(() {});
                showMySnackBar(context: context, message: "An error occurred while approving", type: SnackBarType.error);
              }
            },
              child: Container(
                width: double.infinity,
                height: 50.sp,
                decoration: BoxDecoration(color: (isPending) ? const Color(0xFFE0E0E0) : widget.actionButtonColor ?? const Color(0xFF792A90), borderRadius: BorderRadius.circular(25)),
                child: Center(
                  child: isPending  ? SizedBox(
                          width: 20.sp,
                          height: 20.sp,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )  : Text(
                         widget.actionButtonText,
                          style: TextStyle(color: widget.actionButtonTextColor ?? Colors.white, fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({required String label, required String value, required TextStyle valueStyle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(color: const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(value, textAlign: TextAlign.right, style: valueStyle),
        ),
      ],
    );
  }

  Widget _buildInfoRow({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  String _formatAddress(String address) {
    if (address.length <= 10) return address;
    return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
  }
}
