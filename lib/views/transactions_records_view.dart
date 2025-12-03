import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/utils/navigator.dart';
import 'package:quanthex/widgets/app_textfield.dart';

class TransactionsRecordsView extends StatelessWidget {
  const TransactionsRecordsView({super.key});

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transactions Records',
                    style: TextStyle(
                      color: const Color(0xFF2D2D2D),
                      fontSize: 20.sp,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigate.back(context);
                    },
                    child: Container(
                      width: 32.sp,
                      height: 32.sp,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 20.sp,
                        color: const Color(0xFF2D2D2D),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            10.sp.verticalSpace,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'View all credit and debit that has occurred in your wallet.',
                style: TextStyle(
                  color: const Color(0xFF757575),
                  fontSize: 14.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            20.sp.verticalSpace,
            // Search and Filter Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: AppTextfield(
                      hintText: 'Search',
                      prefixIcon: Icon(
                        Icons.search,
                        size: 20.sp,
                        color: const Color(0xFF9E9E9E),
                      ),
                      filledColor: const Color(0xFFF5F5F5),
                      borderColor: const Color(0xFFF5F5F5),
                      radius: 25,
                    ),
                  ),
                  10.horizontalSpace,
                  Container(
                    width: 50.sp,
                    height: 50.sp,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Icon(
                      Icons.tune,
                      size: 24.sp,
                      color: const Color(0xFF2D2D2D),
                    ),
                  ),
                ],
              ),
            ),
            20.sp.verticalSpace,
            // Transaction List
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildTransactionRecord(
                    title: 'Wallet funding',
                    icon: Icons.arrow_downward,
                    iconColor: Colors.blue,
                    date: 'March 20, 2025 19:21:51',
                    status: 'Attempt',
                    statusColor: Colors.orange,
                    amount: '+ ₦50,000',
                    subStatus: 'Successful',
                  ),
                  _buildTransactionRecord(
                    title: 'Crypto withdraw',
                    icon: Icons.arrow_upward,
                    iconColor: Colors.purple,
                    date: 'March 20, 2025 17:05:28',
                    status: 'Success',
                    statusColor: Colors.teal,
                    amount: '- ₦20,000',
                    subStatus: 'Successful',
                  ),
                  _buildTransactionRecord(
                    title: 'Deposit',
                    icon: Icons.arrow_downward,
                    iconColor: Colors.blue,
                    date: 'March 19, 2025 12:05:12',
                    status: 'Success',
                    statusColor: Colors.teal,
                    amount: '+ 100',
                    subStatus: 'Successful',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionRecord({
    required String title,
    required IconData icon,
    required Color iconColor,
    required String date,
    required String status,
    required Color statusColor,
    required String amount,
    required String subStatus,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.sp),
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48.sp,
            height: 48.sp,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24.sp,
            ),
          ),
          15.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: const Color(0xFF2D2D2D),
                    fontSize: 16.sp,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                5.verticalSpace,
                Text(
                  date,
                  style: TextStyle(
                    color: const Color(0xFF757575),
                    fontSize: 12.sp,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                8.verticalSpace,
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.sp,
                    vertical: 4.sp,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w600,
                    ),
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
                  fontSize: 18.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
              5.verticalSpace,
              Text(
                subStatus,
                style: TextStyle(
                  color: const Color(0xFF4CAF50),
                  fontSize: 12.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

