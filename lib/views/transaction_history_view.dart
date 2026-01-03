import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/widgets/bottom_nav_bar.dart';

class TransactionHistoryView extends StatefulWidget {
  const TransactionHistoryView({super.key});

  @override
  State<TransactionHistoryView> createState() => _TransactionHistoryViewState();
}

class _TransactionHistoryViewState extends State<TransactionHistoryView> {
  String _selectedFilter = 'All Transaction';

  final List<String> _filters = [
    'All Transaction',
    'Swap',
    'Sent',
    'Received',
    'Mining',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigate.back(context);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back, size: 20.sp),
                        5.horizontalSpace,
                        Text(
                          'Back',
                          style: TextStyle(
                            color: const Color(0xFF2D2D2D),
                            fontSize: 16.sp,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Transaction History',
                    style: TextStyle(
                      color: const Color(0xFF2D2D2D),
                      fontSize: 18.sp,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Spacer(),
                  SizedBox(width: 60.sp), // Balance spacing
                ],
              ),
            ),
            20.sp.verticalSpace,
            // Filter Chips
            SizedBox(
              height: 40.sp,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = _selectedFilter == filter;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 10.sp),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.sp,
                        vertical: 8.sp,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF792A90)
                            : const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          filter,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF2D2D2D),
                            fontSize: 13.sp,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            20.sp.verticalSpace,
            // Transaction List
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildTransactionItem(
                    type: 'Receive',
                    icon: Icons.arrow_downward,
                    iconColor: Colors.green,
                    address: '0x91f3A...eE72c1',
                    amount: '+0.5421 ETH',
                    date: '14/11/2025 - 9:12 AM',
                    onTap: () {
                      Navigate.toNamed(context, name: '/receiptview');
                    },
                  ),
                  _buildTransactionItem(
                    type: 'Send',
                    icon: Icons.arrow_upward,
                    iconColor: Colors.red,
                    address: '0xA7d92...14Bc90',
                    amount: '-120.55 USDT',
                    date: '13/11/2025 - 7:48 PM',
                    onTap: () {
                      Navigate.toNamed(context, name: '/receiptview');
                    },
                  ),
                  _buildTransactionItem(
                    type: 'Swap',
                    icon: Icons.swap_vert,
                    iconColor: Colors.purple,
                    address: '0x72E0c...5eE84',
                    amount: '0.0342 ETH → 92.67 USDT',
                    date: '12/11/2025 - 3:42 PM',
                    onTap: () {
                      Navigate.toNamed(context, name: '/receiptview');
                    },
                  ),
                  _buildTransactionItem(
                    type: 'Receive',
                    icon: Icons.arrow_downward,
                    iconColor: Colors.green,
                    address: 'TPh7a...Dk4pQ',
                    amount: '+350 USDT',
                    date: '12/11/2025 - 10:15 AM',
                    onTap: () {
                      Navigate.toNamed(context, name: '/receiptview');
                    },
                  ),
                  _buildTransactionItem(
                    type: 'Receive',
                    icon: Icons.arrow_downward,
                    iconColor: Colors.green,
                    address: 'bc1q7...3xjru',
                    amount: '+0.00084 BTC',
                    date: '10/11/2025 - 8:27 AM',
                    onTap: () {
                      Navigate.toNamed(context, name: '/receiptview');
                    },
                  ),
                  _buildTransactionItem(
                    type: 'Send',
                    icon: Icons.arrow_upward,
                    iconColor: Colors.red,
                    address: '0x5d81E...7aE01',
                    amount: '-22.5 ARB',
                    date: '09/11/2025 - 9:56 PM',
                    onTap: () {
                      Navigate.toNamed(context, name: '/receiptview');
                    },
                  ),
                  _buildTransactionItem(
                    type: 'Receive',
                    icon: Icons.arrow_downward,
                    iconColor: Colors.green,
                    address: '0xF3e02...814dB2',
                    amount: '+18.92 BNB',
                    date: '08/11/2025 - 5:18 PM',
                    onTap: () {
                      Navigate.toNamed(context, name: '/receiptview');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem({
    required String type,
    required IconData icon,
    required Color iconColor,
    required String address,
    required String amount,
    required String date,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.sp),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: const Color(0xFFE0E0E0), width: 1),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40.sp,
              height: 40.sp,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20.sp),
            ),
            15.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type,
                    style: TextStyle(
                      color: const Color(0xFF2D2D2D),
                      fontSize: 15.sp,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    type == 'Swap' ? 'From: $address' : address,
                    style: TextStyle(
                      color: const Color(0xFF757575),
                      fontSize: 12.sp,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: TextStyle(
                    color: const Color(0xFF2D2D2D),
                    fontSize: 15.sp,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                4.verticalSpace,
                Text(
                  date,
                  style: TextStyle(
                    color: const Color(0xFF757575),
                    fontSize: 11.sp,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
