import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/widgets/app_button.dart';

class ReceiptView extends StatelessWidget {
  const ReceiptView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                20.sp.verticalSpace,
                // Header
                Row(
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
                      'Receipt',
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
                40.sp.verticalSpace,
                // Transaction Icon
                Container(
                  width: 120.sp,
                  height: 120.sp,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9E6FF),
                    image: DecorationImage(
                      image: AssetImage('assets/images/eth_logo.png'),
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF792A90),
                      width: 3,
                    ),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      // Image.asset(
                      //   'assets/images/eth_logo.png',
                      //   width: 60.sp,
                      //   height: 60.sp,
                      // ),
                      Positioned(
                        bottom: -10.sp,
                        right: 10.sp,
                        child: Container(
                          width: 32.sp,
                          height: 32.sp,
                          decoration: BoxDecoration(
                            color: const Color(0xffffffff),
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            'assets/images/matic_logo.png',
                            width: 60.sp,
                            height: 60.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                20.sp.verticalSpace,
                Text(
                  'ETH Received',
                  style: TextStyle(
                    color: const Color(0xFF2D2D2D),
                    fontSize: 22.sp,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                10.sp.verticalSpace,
                Text(
                  '0.24 ETH',
                  style: TextStyle(
                    color: const Color(0xFF2D2D2D),
                    fontSize: 32.sp,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                5.sp.verticalSpace,
                Text(
                  '\$752.00',
                  style: TextStyle(
                    color: const Color(0xFF757575),
                    fontSize: 18.sp,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                40.sp.verticalSpace,
                // Transaction Details
                Container(
                  padding: EdgeInsets.all(16.sp),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow('Date', '23 Aug 2025, 10:28AM'),
                      // Divider(height: 24.sp),
                      20.sp.verticalSpace,
                      _buildDetailRow('Amount', '0.24'),
                      20.sp.verticalSpace,
                      // Divider(height: 24.sp),
                      _buildDetailRow('Status', 'Completed'),
                    ],
                  ),
                ),
                20.sp.verticalSpace,
                _buildDetailRow('Network Fee', '\$0.21'),
                15.sp.verticalSpace,
                _buildDetailRow(
                  'Sender',
                  '0xA4f27B.....A92dC9E',
                  isAddress: true,
                ),
                40.sp.verticalSpace,
                AppButton(
                  text: 'Share',
                  textColor: Colors.white,
                  color: const Color(0xFF792A90),
                  onTap: () {
                    // Share functionality
                    Clipboard.setData(
                      ClipboardData(
                        text:
                            'ETH Received: 0.24 ETH\nDate: 23 Aug 2025, 10:28AM\nStatus: Completed',
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Receipt copied to clipboard')),
                    );
                  },
                ),
                20.sp.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isAddress = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFF757575),
            fontSize: 14.sp,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w400,
          ),
        ),
        if (isAddress)
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: value));
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: const Color(0xFF2D2D2D),
                    fontSize: 14.sp,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                5.horizontalSpace,
                Icon(Icons.copy, size: 16.sp, color: const Color(0xFF757575)),
              ],
            ),
          )
        else
          Text(
            value,
            style: TextStyle(
              color: const Color(0xFF2D2D2D),
              fontSize: 14.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}
