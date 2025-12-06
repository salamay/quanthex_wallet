import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/utils/navigator.dart';
import 'package:quanthex/widgets/app_textfield.dart';
import 'package:quanthex/widgets/bottom_nav_bar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _isBalanceVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.sp.verticalSpace,
                      // Header
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20.sp,
                            backgroundColor: const Color(0xFFF5F5F5),
                            backgroundImage: AssetImage(
                              'assets/images/person.png',
                            ),
                            // child: Icon(
                            //   Icons.person,
                            //   size: 24.sp,
                            //   color: const Color(0xFF792A90),
                            // ),
                          ),
                          10.horizontalSpace,
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.sp,
                              vertical: 6.sp,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Main Wallet',
                                  style: TextStyle(
                                    color: const Color(0xFF2D2D2D),
                                    fontSize: 13.sp,
                                    fontFamily: 'Satoshi',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                5.horizontalSpace,
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 16.sp,
                                  color: const Color(0xFF2D2D2D),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Container(
                              width: 41.sp,
                              height: 41.sp,
                              padding: const EdgeInsets.all(10),
                              decoration: ShapeDecoration(
                                color: const Color(0x7CDADADA),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.50),
                                ),
                              ),
                              child: Image.asset(
                                'assets/images/scan_icon.png',
                                width: 19.sp,
                                height: 19.sp,
                              ),
                            ),
                            // Icon(
                            //   Icons.qr_code_scanner,
                            //   size: 24.sp,
                            //   color: const Color(0xFF2D2D2D),
                            // ),
                            onPressed: () {
                              Navigate.toNamed(context, name: '/qrscanview');
                            },
                          ),
                          IconButton(
                            icon: Container(
                              width: 41.sp,
                              height: 41.sp,
                              padding: const EdgeInsets.all(10),
                              decoration: ShapeDecoration(
                                color: const Color(0x7CDADADA),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.50),
                                ),
                              ),
                              child: Image.asset(
                                'assets/images/noti_icon.png',
                                width: 19.sp,
                                height: 19.sp,
                              ),
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      20.sp.verticalSpace,
                      // Search Bar
                      AppTextfield(
                        hintText: 'Search token',
                        prefixIcon: Icon(
                          Icons.search,
                          size: 20.sp,
                          color: const Color(0xFF9E9E9E),
                        ),
                        filledColor: const Color(0xFFF5F5F5),
                        borderColor: const Color(0xFFF5F5F5),
                        radius: 25,
                      ),
                      25.sp.verticalSpace,
                      // Portfolio Value
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Portfolio Value',
                            style: TextStyle(
                              color: const Color(0xFF757575),
                              fontSize: 14.sp,
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          8.horizontalSpace,
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isBalanceVisible = !_isBalanceVisible;
                              });
                            },
                            child: Icon(
                              _isBalanceVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 18.sp,
                              color: const Color(0xFF757575),
                            ),
                          ),
                        ],
                      ),
                      10.sp.verticalSpace,
                      Center(
                        child: Text(
                          _isBalanceVisible ? '\$25,540.23' : '••••••',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF2D2D2D),
                            fontSize: 32.sp,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      8.sp.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.trending_up,
                            size: 16.sp,
                            color: const Color(0xFF4CAF50),
                          ),
                          5.horizontalSpace,
                          Text(
                            '+\$214.67 (1.74%)',
                            style: TextStyle(
                              color: const Color(0xFF4CAF50),
                              fontSize: 14.sp,
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      30.sp.verticalSpace,
                      // Quick Actions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildQuickAction(
                            icon: Icons.arrow_downward,
                            label: 'Deposit',
                            onTap: () {
                              Navigate.toNamed(context, name: '/receiveview');
                            },
                          ),
                          _buildQuickAction(
                            icon: Icons.arrow_upward,
                            label: 'Send',
                            onTap: () {
                              Navigate.toNamed(context, name: '/sendtokenview');
                            },
                          ),
                          _buildQuickAction(
                            icon: Icons.swap_horiz,
                            label: 'Swap',
                            onTap: () {
                              Navigate.toNamed(context, name: '/swaptokenview');
                            },
                          ),
                          _buildQuickAction(
                            icon: Image.asset(
                              'assets/images/history.png',
                              width: 24.sp,
                              height: 24.sp,
                              fit: BoxFit.contain,
                            ),
                            label: 'History',
                            onTap: () {
                              Navigate.toNamed(
                                context,
                                name: '/transactionhistoryview',
                              );
                            },
                          ),
                        ],
                      ),
                      30.sp.verticalSpace,
                      // My Assets
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'My Assets',
                            style: TextStyle(
                              color: const Color(0xFF2D2D2D),
                              fontSize: 18.sp,
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.sp,
                              vertical: 6.sp,
                            ),
                            decoration: BoxDecoration(
                              // color: const Color(0xFFF5F5F5),
                              border: Border.all(color: Color(0xFFF5F5F5)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.add,
                                  size: 16.sp,
                                  color: const Color(0xFF2D2D2D),
                                ),
                                5.horizontalSpace,
                                Text(
                                  'Add token',
                                  style: TextStyle(
                                    color: const Color(0xFF2D2D2D),
                                    fontSize: 12.sp,
                                    fontFamily: 'Satoshi',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      20.sp.verticalSpace,
                      // Assets List
                      _buildAssetItem(
                        icon: Icons.diamond,
                        iconColor: Colors.blue,
                        name: 'TON',
                        price: '\$1.49',
                        holdings: '2,684.56 TON',
                        value: '\$4,000',
                        onTap: () {
                          Navigate.toNamed(
                            context,
                            name: '/ethereumdetailview',
                          );
                        },
                      ),
                      _buildAssetItem(
                        icon: Icons.circle,
                        iconColor: Colors.green,
                        name: 'USDT',
                        price: '\$1',
                        holdings: '3,503.52 USDT',
                        value: '\$3,500',
                        onTap: () {
                          Navigate.toNamed(
                            context,
                            name: '/ethereumdetailview',
                          );
                        },
                      ),
                      _buildAssetItem(
                        icon: Icons.diamond,
                        iconColor: Colors.grey,
                        name: 'ETH',
                        price: '\$3,088.07',
                        holdings: '0.245 ETH',
                        value: '\$612.44',
                        onTap: () {
                          Navigate.toNamed(
                            context,
                            name: '/ethereumdetailview',
                          );
                        },
                      ),
                      _buildAssetItem(
                        icon: Icons.circle,
                        iconColor: Colors.purple,
                        name: 'SOL',
                        price: '\$150.23',
                        holdings: '5.23 SOL',
                        value: '\$785',
                        onTap: () {
                          Navigate.toNamed(
                            context,
                            name: '/ethereumdetailview',
                          );
                        },
                      ),
                      _buildAssetItem(
                        icon: Icons.circle,
                        iconColor: Colors.orange,
                        name: 'BNB',
                        price: '\$580.45',
                        holdings: '1.2 BNB',
                        value: '\$696',
                        onTap: () {
                          Navigate.toNamed(
                            context,
                            name: '/ethereumdetailview',
                          );
                        },
                      ),
                      _buildAssetItem(
                        icon: Icons.circle,
                        iconColor: Colors.purple,
                        name: 'POL',
                        price: '\$0.85',
                        holdings: '1,200 POL',
                        value: '\$1,020',
                        onTap: () {
                          Navigate.toNamed(
                            context,
                            name: '/ethereumdetailview',
                          );
                        },
                      ),
                      20.sp.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
            BottomNavBar(currentIndex: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56.sp,
            height: 56.sp,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              shape: BoxShape.circle,
            ),
            child: icon.runtimeType == IconData
                ? Icon(icon, color: const Color(0xFF2D2D2D), size: 24.sp)
                : Center(child: icon),
          ),
          8.verticalSpace,
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFF2D2D2D),
              fontSize: 12.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetItem({
    required IconData icon,
    required Color iconColor,
    required String name,
    required String price,
    required String holdings,
    required String value,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 15.sp),
        padding: EdgeInsets.symmetric(vertical: 12.sp),
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
              child: Icon(icon, color: iconColor, size: 24.sp),
            ),
            15.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: const Color(0xFF2D2D2D),
                      fontSize: 16.sp,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    price,
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
                  holdings,
                  style: TextStyle(
                    color: const Color(0xFF2D2D2D),
                    fontSize: 16.sp,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                4.verticalSpace,
                Text(
                  value,
                  style: TextStyle(
                    color: const Color(0xFF757575),
                    fontSize: 12.sp,
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
