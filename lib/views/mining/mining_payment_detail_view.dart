import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:quanthex/data/Models/mining/mining_payment_dto.dart';
import 'package:quanthex/data/utils/navigator.dart';

class MiningPaymentDetailView extends StatelessWidget {
  final MiningPaymentDto payment;

  const MiningPaymentDetailView({super.key, required this.payment});

  String _formatDate(String? timestamp) {
    if (timestamp == null || timestamp.isEmpty) return 'N/A';
    try {
      final millis = int.tryParse(timestamp);
      if (millis == null) return 'N/A';
      final date = DateTime.fromMillisecondsSinceEpoch(millis);
      return DateFormat('MMM dd, yyyy • hh:mm a').format(date);
    } catch (_) {
      return 'N/A';
    }
  }

  String _truncateHash(String? hash) {
    if (hash == null || hash.length < 12) return hash ?? 'N/A';
    return '${hash.substring(0, 6)}...${hash.substring(hash.length - 6)}';
  }

  void _copyToClipboard(BuildContext context, String? text) {
    if (text == null || text.isEmpty) return;
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Copied to clipboard'),
        backgroundColor: const Color(0xFF792A90),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rewardSymbol = payment.mpRewardSymbol ?? payment.subRewardAssetSymbol ?? '';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigate.back(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.sp),
        ),
        title: Text(
          'Payment Detail',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.6),
              BlendMode.darken,
            ),
            image: const AssetImage('assets/images/green_astro_bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Amount banner
                _buildAmountBanner(rewardSymbol),
                SizedBox(height: 16.sp),

                // Transaction Info
                _buildSection(
                  context,
                  title: 'Transaction Info',
                  icon: Icons.receipt_long_outlined,
                  children: [
                    _buildDetailRow(context, 'Payment Number', payment.tierLabel),
                    _buildDetailRow(context, 'Status', _capitalizeStatus(payment.mpStatus)),
                    _buildDetailRow(context, 'Type', payment.isManual ? 'Manual' : 'Referral-based'),
                    _buildDetailRow(context, 'Referrals at Payment', '${payment.mpReferralCountAtPayment}'),
                    _buildDetailRow(context, 'Chain ID', '${payment.mpChainId}'),
                    _buildDetailRow(context, 'Reward Symbol', rewardSymbol.isNotEmpty ? rewardSymbol : 'N/A'),
                  ],
                ),
                SizedBox(height: 16.sp),

                // Package Info
                _buildSection(
                  context,
                  title: 'Package Info',
                  icon: Icons.inventory_2_outlined,
                  children: [
                    _buildDetailRow(context, 'Package Name', payment.subPackageName ?? 'N/A'),
                    _buildDetailRow(context, 'Asset Symbol', payment.subAssetSymbol ?? 'N/A'),
                    if (payment.subPrice != null)
                      _buildDetailRow(context, 'Package Price', '\$${payment.subPrice!.toStringAsFixed(2)}'),
                  ],
                ),
                SizedBox(height: 16.sp),

                // Blockchain
                _buildSection(
                  context,
                  title: 'Blockchain',
                  icon: Icons.link,
                  children: [
                    if (payment.mpTxHash != null && payment.mpTxHash!.isNotEmpty)
                      _buildDetailRow(
                        context,
                        'TX Hash',
                        _truncateHash(payment.mpTxHash),
                        copyValue: payment.mpTxHash,
                      ),
                    _buildDetailRow(context, 'Created', _formatDate(payment.mpCreatedAt)),
                    _buildDetailRow(context, 'Updated', _formatDate(payment.mpUpdatedAt)),
                  ],
                ),

                SizedBox(height: 32.sp),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmountBanner(String rewardSymbol) {
    Color statusColor;
    String statusLabel;

    if (payment.isPending) {
      statusColor = Colors.orange;
      statusLabel = 'Pending';
    } else if (payment.isConfirmed) {
      statusColor = const Color(0xffA8EBCF);
      statusLabel = 'Confirmed';
    } else {
      statusColor = Colors.redAccent;
      statusLabel = 'Failed';
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Text(
            'Mining Payment Amount',
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.white54,
            ),
          ),
          SizedBox(height: 6.sp),
          Text(
            '${payment.mpAmount} $rewardSymbol',
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xffA8EBCF),
            ),
          ),
          SizedBox(height: 8.sp),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 4.sp),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              statusLabel,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16.sp, color: const Color(0xffA8EBCF)),
              SizedBox(width: 8.sp),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.sp),
          Divider(color: Colors.white.withOpacity(0.1), height: 1),
          SizedBox(height: 12.sp),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    String? copyValue,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white54,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: copyValue != null ? () => _copyToClipboard(context, copyValue) : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (copyValue != null) ...[
                    SizedBox(width: 4.sp),
                    Icon(Icons.copy, size: 12.sp, color: Colors.white38),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _capitalizeStatus(String status) {
    if (status.isEmpty) return status;
    return status[0].toUpperCase() + status.substring(1).toLowerCase();
  }
}
