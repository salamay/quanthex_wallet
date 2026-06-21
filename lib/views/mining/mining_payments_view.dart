import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/data/Models/mining/mining_dto.dart';
import 'package:quanthex/data/Models/mining/mining_payment_dto.dart';
import 'package:quanthex/data/controllers/mining/mining_controller.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/routes/app_routes.dart';

class MiningPaymentsView extends StatefulWidget {
  final MiningDto mining;

  const MiningPaymentsView({super.key, required this.mining});

  @override
  State<MiningPaymentsView> createState() => _MiningPaymentsViewState();
}

class _MiningPaymentsViewState extends State<MiningPaymentsView> {
  final ScrollController _scrollController = ScrollController();

  String get _minId => widget.mining.mining?.minId ?? '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MiningController>().fetchMiningPayments(_minId, refresh: true);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<MiningController>().loadMoreMiningPayments(_minId);
    }
  }

  String _formatDate(String? timestamp) {
    if (timestamp == null || timestamp.isEmpty) return 'N/A';
    try {
      final millis = int.tryParse(timestamp);
      if (millis == null) return 'N/A';
      final date = DateTime.fromMillisecondsSinceEpoch(millis);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (_) {
      return 'N/A';
    }
  }

  String _truncateHash(String? hash) {
    if (hash == null || hash.length < 12) return hash ?? 'N/A';
    return '${hash.substring(0, 6)}...${hash.substring(hash.length - 6)}';
  }

  @override
  Widget build(BuildContext context) {
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
          'Payment History',
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
          child: Consumer<MiningController>(
            builder: (context, controller, _) {
              final payments = controller.miningPayments[_minId] ?? [];
              final total = controller.miningPaymentsTotals[_minId] ?? 0;
              final isLoading = controller.fetchingMiningPayments;
              final hasError = controller.fetchingMiningPaymentsError;
              final isLoadingMore = controller.loadingMoreMiningPayments;

              if (isLoading && payments.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xffA8EBCF)),
                );
              }

              if (hasError && payments.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, color: Colors.white54, size: 48.sp),
                      SizedBox(height: 12.sp),
                      Text(
                        'Failed to load payments',
                        style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                      ),
                      SizedBox(height: 12.sp),
                      TextButton(
                        onPressed: () => controller.fetchMiningPayments(_minId, refresh: true),
                        child: Text(
                          'Retry',
                          style: TextStyle(color: const Color(0xffA8EBCF), fontSize: 14.sp),
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (payments.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.receipt_long_outlined, color: Colors.white54, size: 48.sp),
                      SizedBox(height: 12.sp),
                      Text(
                        'No payments yet',
                        style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  // Header info
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 6.sp),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.mining.subscription?.subPackageName ?? '',
                            style: TextStyle(
                              color: const Color(0xffA8EBCF),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '$total payment${total == 1 ? '' : 's'}',
                          style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                        ),
                      ],
                    ),
                  ),
                  // List
                  Expanded(
                    child: RefreshIndicator(
                      color: const Color(0xffA8EBCF),
                      backgroundColor: Colors.black54,
                      onRefresh: () => controller.fetchMiningPayments(_minId, refresh: true),
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 16.sp),
                        itemCount: payments.length + (isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == payments.length) {
                            return Padding(
                              padding: EdgeInsets.all(16.sp),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xffA8EBCF),
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          }
                          return _buildPaymentCard(payments[index]);
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentCard(MiningPaymentDto payment) {
    return GestureDetector(
      onTap: () {
        Navigate.toNamed(context, name: AppRoutes.miningPaymentDetailView, args: payment);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.sp),
        padding: EdgeInsets.all(14.sp),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: tier label + amount + status
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
                  decoration: BoxDecoration(
                    color: payment.isManual
                        ? Colors.orange.withOpacity(0.2)
                        : const Color(0xffA8EBCF).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    payment.tierLabel,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: payment.isManual ? Colors.orange : const Color(0xffA8EBCF),
                    ),
                  ),
                ),
                SizedBox(width: 8.sp),
                Text(
                  '${payment.mpAmount} ${payment.mpRewardSymbol}',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                _buildStatusBadge(payment),
              ],
            ),
            SizedBox(height: 10.sp),
            Divider(color: Colors.white.withOpacity(0.1), height: 1),
            SizedBox(height: 10.sp),
            // Info rows
            _buildInfoRow(Icons.calendar_today_outlined, 'Date', _formatDate(payment.mpCreatedAt)),
            SizedBox(height: 6.sp),
            if (payment.mpTxHash != null && payment.mpTxHash!.isNotEmpty) ...[
              _buildInfoRow(Icons.tag, 'TX Hash', _truncateHash(payment.mpTxHash)),
              SizedBox(height: 6.sp),
            ],
            _buildInfoRow(Icons.people_outline, 'Referrals', '${payment.mpReferralCountAtPayment}'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(MiningPaymentDto payment) {
    Color bgColor;
    Color textColor;
    String label;

    if (payment.isPending) {
      bgColor = Colors.orange.withOpacity(0.2);
      textColor = Colors.orange;
      label = 'Pending';
    } else if (payment.isConfirmed) {
      bgColor = const Color(0xffA8EBCF).withOpacity(0.15);
      textColor = const Color(0xffA8EBCF);
      label = 'Confirmed';
    } else {
      bgColor = Colors.red.withOpacity(0.2);
      textColor = Colors.redAccent;
      label = 'Failed';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 4.sp),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: Colors.white38),
        SizedBox(width: 6.sp),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white54,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
