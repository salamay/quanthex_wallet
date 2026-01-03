import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/widgets/snackbar/my_snackbar.dart';

class TransactionDetailsView extends StatefulWidget {
  final String amount;
  final String tokenSymbol;
  final String fromAddress;
  final String toAddress;
  final String? fromLabel;
  final String? toLabel;
  final String networkFee;
  final String networkSymbol;
  final String transactionHash;
  final String blockNumber;
  final String timestamp;
  final String? walletName;
  final bool isReceive;
  final bool isSuccess;
  final String? networkName;

  const TransactionDetailsView({
    super.key,
    required this.amount,
    required this.tokenSymbol,
    required this.fromAddress,
    required this.toAddress,
    this.fromLabel,
    this.toLabel,
    required this.networkFee,
    required this.networkSymbol,
    required this.transactionHash,
    required this.blockNumber,
    required this.timestamp,
    this.walletName,
    this.isReceive = false,
    this.isSuccess = true,
    this.networkName,
  });

  @override
  State<TransactionDetailsView> createState() => _TransactionDetailsViewState();
}

class _TransactionDetailsViewState extends State<TransactionDetailsView> {
  bool _expandedDetails = true;

  String _formatAddress(String address) {
    if (address.isEmpty) return 'Unknown';
    if (address.length <= 10) return address;
    return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
  }

  String _formatTimestamp(String timestamp) {
    if (timestamp.isEmpty) return 'Unknown';
    try {
      final date = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp) * 1000);
      final month = date.month.toString().padLeft(2, '0');
      final day = date.day.toString().padLeft(2, '0');
      final hour = date.hour.toString().padLeft(2, '0');
      final minute = date.minute.toString().padLeft(2, '0');
      final second = date.second.toString().padLeft(2, '0');
      return '$month/$day $hour:$minute:$second';
    } catch (e) {
      return timestamp;
    }
  }

  String _getTransactionExplorerUrl() {
    if (widget.transactionHash.isEmpty) return '';

    final network = widget.networkName?.toLowerCase() ?? widget.networkSymbol.toLowerCase();
    final hash = widget.transactionHash;

    // Determine blockchain explorer based on network
    String baseUrl;
    if (network.contains('bsc') || network.contains('bnb') || network.contains('binance')) {
      baseUrl = 'https://bscscan.com/tx/$hash';
    } else if (network.contains('ethereum') || network.contains('eth')) {
      baseUrl = 'https://etherscan.io/tx/$hash';
    } else if (network.contains('polygon') || network.contains('matic')) {
      baseUrl = 'https://polygonscan.com/tx/$hash';
    } else if (network.contains('arbitrum') || network.contains('arb')) {
      baseUrl = 'https://arbiscan.io/tx/$hash';
    } else if (network.contains('optimism') || network.contains('op')) {
      baseUrl = 'https://optimistic.etherscan.io/tx/$hash';
    } else if (network.contains('avalanche') || network.contains('avax')) {
      baseUrl = 'https://snowtrace.io/tx/$hash';
    } else if (network.contains('fantom') || network.contains('ftm')) {
      baseUrl = 'https://ftmscan.com/tx/$hash';
    } else {
      // Default to BSC if network is unknown
      baseUrl = 'https://bscscan.com/tx/$hash';
    }

    return baseUrl;
  }

  String _getTransactionLink() {
    return _getTransactionExplorerUrl();
  }

  Future<void> _openTransactionUrl() async {
    final url = _getTransactionExplorerUrl();
    if (url.isEmpty) {
      showMySnackBar(context: context, message: 'Transaction hash not available', type: SnackBarType.error);
      return;
    }

    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        showMySnackBar(context: context, message: 'Could not open transaction URL', type: SnackBarType.error);
      }
    } catch (e) {
      showMySnackBar(context: context, message: 'Error opening URL: $e', type: SnackBarType.error);
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    showMySnackBar(context: context, message: 'Copied to clipboard', type: SnackBarType.success);
  }

  @override
  Widget build(BuildContext context) {
    final isSuccess = widget.isSuccess;
    final amount = widget.amount;
    final tokenSymbol = widget.tokenSymbol;
    final isReceive = widget.isReceive;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.sp),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigate.back(context),
                      child: Icon(Icons.arrow_back, size: 24.sp, color: const Color(0xFF2D2D2D)),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Transaction Details',
                          style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 18.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    SizedBox(width: 24.sp),
                  ],
                ),
              ),
              20.sp.verticalSpace,

              // Status Icon and Amount
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 64.sp,
                      height: 64.sp,
                      decoration: BoxDecoration(color: isSuccess ? const Color(0xFF4CAF50) : Colors.red, shape: BoxShape.circle),
                      child: Icon(isSuccess ? Icons.check : Icons.close, color: Colors.white, size: 32.sp),
                    ),
                    12.sp.verticalSpace,
                    Text(
                      'Transfer Successful',
                      style: TextStyle(color: isSuccess ? const Color(0xFF4CAF50) : Colors.red, fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                    ),
                    8.sp.verticalSpace,
                    Text(
                      '${isReceive ? '+' : '-'}$amount $tokenSymbol',
                      style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 24.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              30.sp.verticalSpace,

              // First Card - From, To, Network Fee
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.sp),
                child: Container(
                  padding: EdgeInsets.all(16.sp),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(label: 'From', value: _formatAddress(widget.fromAddress), subLabel: widget.fromLabel?.isNotEmpty == true ? widget.fromLabel : (widget.walletName ?? ''), onCopy: () => _copyToClipboard(widget.fromAddress)),
                      16.sp.verticalSpace,
                      _buildInfoRow(label: 'To', value: _formatAddress(widget.toAddress), subLabel: widget.toLabel, onCopy: () => _copyToClipboard(widget.toAddress)),
                      16.sp.verticalSpace,
                      _buildInfoRow(label: 'Network Fee', value: '${widget.networkFee} ${widget.networkSymbol}'),
                      if (!_expandedDetails) ...[
                        12.sp.verticalSpace,
                        GestureDetector(
                          onTap: () => setState(() => _expandedDetails = true),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Expand Details',
                                style: TextStyle(color: const Color(0xFF792A90), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                              ),
                              4.horizontalSpace,
                              Icon(Icons.keyboard_arrow_down, color: const Color(0xFF792A90), size: 20.sp),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              if (_expandedDetails) ...[
                16.sp.verticalSpace,
                // Second Card - Blockchain Details
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.sp),
                  child: Container(
                    padding: EdgeInsets.all(16.sp),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildInfoRow(label: 'TX Hash', value: _formatAddress(widget.transactionHash), onCopy: () => _copyToClipboard(widget.transactionHash)),
                                  16.sp.verticalSpace,
                                  _buildInfoRow(label: 'Block Height', value: widget.blockNumber.replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')),
                                  16.sp.verticalSpace,
                                  _buildInfoRow(label: 'Time', value: _formatTimestamp(widget.timestamp)),
                                ],
                              ),
                            ),
                            // QR Code
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8.sp),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
                                  ),
                                  child: QrImageView(data: _getTransactionLink(), size: 80.sp, backgroundColor: Colors.white),
                                ),
                                8.sp.verticalSpace,
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: _openTransactionUrl,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 6.sp),
                                        decoration: BoxDecoration(color: const Color(0xFF792A90), borderRadius: BorderRadius.circular(6)),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.open_in_new, size: 14.sp, color: Colors.white),
                                            4.horizontalSpace,
                                            Text(
                                              'View on Explorer',
                                              style: TextStyle(color: Colors.white, fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    8.sp.verticalSpace,
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Link',
                                          style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                                        ),
                                        4.horizontalSpace,
                                        GestureDetector(
                                          onTap: () => _copyToClipboard(_getTransactionLink()),
                                          child: Icon(Icons.copy, size: 16.sp, color: const Color(0xFF757575)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              30.sp.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({required String label, required String value, String? subLabel, VoidCallback? onCopy}) {
    final displaySubLabel = subLabel?.isNotEmpty == true ? subLabel : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: const Color(0xFF757575), fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        value,
                        style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                      ),
                      8.horizontalSpace,
                      if (onCopy != null)
                        GestureDetector(
                          onTap: onCopy,
                          child: Icon(Icons.copy, size: 14.sp, color: const Color(0xFF757575)),
                        ),
                    ],
                  ),
                  if (displaySubLabel != null) ...[
                    2.sp.verticalSpace,
                    Text(
                      '($displaySubLabel)',
                      style: TextStyle(color: const Color(0xFF757575), fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
