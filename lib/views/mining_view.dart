import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/utils/navigator.dart';
import 'package:quanthex/widgets/app_button.dart';
import 'package:quanthex/widgets/bottom_nav_bar.dart';

class MiningView extends StatefulWidget {
  const MiningView({super.key});

  @override
  State<MiningView> createState() => _MiningViewState();
}

class _MiningViewState extends State<MiningView> {
  final double _miningProgress = 0.63; // 63%
  final String _earnedAmount = '1,127,393.22';
  final String _referralLink = 'https://quanthex.io/r/QUX4837';
  bool subScribed = false;

  void _showEarningBreakdownModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      builder: (context) => EarningBreakdownModal(),
    );
  }

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
                    'Mining',
                    style: TextStyle(
                      color: const Color(0xFF2D2D2D),
                      fontSize: 18.sp,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Container(
                      width: 41,
                      height: 41,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2,
                        vertical: 9,
                      ),
                      decoration: ShapeDecoration(
                        color: const Color(0x7CDADADA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.50),
                        ),
                      ),
                      child: Icon(
                        Icons.more_horiz,
                        size: 24.sp,
                        color: const Color(0xFF2D2D2D),
                      ),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: subScribed == false
                    ? ifNotSubScribed()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          40.sp.verticalSpace,
                          // Mining Progress Circle
                          Center(
                            child: SizedBox(
                              width: 200.sp,
                              height: 200.sp,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 200.sp,
                                    height: 200.sp,
                                    child: CircularProgressIndicator(
                                      value: _miningProgress,
                                      strokeWidth: 22,
                                      strokeCap: StrokeCap.round,
                                      backgroundColor: const Color(0xFFF9E6FF),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        const Color(0xFF792A90),
                                      ),
                                    ),
                                  ),
                                  // Column(
                                  //   mainAxisAlignment: MainAxisAlignment.center,
                                  //   children: [
                                  //     Text(
                                  //       'Mining',
                                  //       style: TextStyle(
                                  //         color: const Color(0xFF757575),
                                  //         fontSize: 14.sp,
                                  //         fontFamily: 'Satoshi',
                                  //         fontWeight: FontWeight.w500,
                                  //       ),
                                  //     ),
                                  //     5.verticalSpace,
                                  //     Text(
                                  //       '${(_miningProgress * 100).toInt()}%',
                                  //       style: TextStyle(
                                  //         color: const Color(0xFF2D2D2D),
                                  //         fontSize: 32.sp,
                                  //         fontFamily: 'Satoshi',
                                  //         fontWeight: FontWeight.w700,
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                          ),
                          30.sp.verticalSpace,
                          // Earned Amount
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.sp,
                              vertical: 4.sp,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 240, 42, 243),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                '$_earnedAmount Hex MH/s',
                                style: TextStyle(
                                  color: const Color.fromARGB(
                                    255,
                                    255,
                                    255,
                                    255,
                                  ),
                                  fontSize: 32.sp,
                                  fontFamily: 'Satoshi',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          // 8.sp.verticalSpace,
                          // Center(
                          //   child: Text(
                          //     'Earned STB',
                          //     style: TextStyle(
                          //       color: const Color(0xFF792A90),
                          //       fontSize: 14.sp,
                          //       fontFamily: 'Satoshi',
                          //       fontWeight: FontWeight.w500,
                          //     ),
                          //   ),
                          // ),
                          30.sp.verticalSpace,
                          // Referral Link
                          Container(
                            padding: EdgeInsets.all(16.sp),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _referralLink,
                                    style: TextStyle(
                                      color: const Color(0xFF2D2D2D),
                                      fontSize: 14.sp,
                                      fontFamily: 'Satoshi',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                10.horizontalSpace,
                                GestureDetector(
                                  onTap: () {
                                    Clipboard.setData(
                                      ClipboardData(text: _referralLink),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Link copied')),
                                    );
                                  },
                                  child: Icon(
                                    Icons.copy,
                                    size: 20.sp,
                                    color: const Color(0xFF757575),
                                  ),
                                ),
                                10.horizontalSpace,
                                Icon(
                                  Icons.share,
                                  size: 20.sp,
                                  color: const Color(0xFF757575),
                                ),
                              ],
                            ),
                          ),
                          30.sp.verticalSpace,
                          // Statistics Cards
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  label: 'Active Members',
                                  value: '3',
                                ),
                              ),
                              15.horizontalSpace,
                              Expanded(
                                child: _buildStatCard(
                                  label: 'Bonus Boost Rate',
                                  value: '+0.02 /hr',
                                ),
                              ),
                            ],
                          ),
                          15.sp.verticalSpace,
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  label: 'Current Mining Speed',
                                  value: '0.03 /hr',
                                  isFullWidth: true,
                                ),
                              ),
                              15.horizontalSpace,
                              Expanded(
                                child: _buildStatCard(
                                  label: 'STB',
                                  value: '38153.9651',
                                  isFullWidth: true,
                                ),
                              ),
                            ],
                          ),
                          40.sp.verticalSpace,
                        ],
                      ),
              ),
            ),
            BottomNavBar(currentIndex: 2),
          ],
        ),
      ),
    );
  }

  Widget ifNotSubScribed() {
    return Column(
      children: [
        // Introduction Section
        Text(
          'Ignite Your Mining Power Let the Blockchain Work for You.',
          style: TextStyle(
            color: const Color(0xFF2D2D2D),
            fontSize: 24.sp,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w700,
          ),
        ),
        15.sp.verticalSpace,
        Text(
          'Activate any mining package and begin generating rewards instantly. The higher your package and network growth, the more you earn.',
          style: TextStyle(
            color: const Color(0xFF757575),
            fontSize: 14.sp,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
        30.sp.verticalSpace,
        // How It Works
        Text(
          'How It Works',
          style: TextStyle(
            color: const Color(0xFF2D2D2D),
            fontSize: 18.sp,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w700,
          ),
        ),
        15.sp.verticalSpace,
        _buildHowItWorksItem('Choose a package'),
        10.sp.verticalSpace,
        _buildHowItWorksItem(
          'Get your HexaPower referral link',
          // onInfoTap: ,
        ),
        10.sp.verticalSpace,
        _buildHowItWorksItem('Share & grow your earnings'),
        30.sp.verticalSpace,
        // Available Packages
        Text(
          'Available Packages',
          style: TextStyle(
            color: const Color(0xFF2D2D2D),
            fontSize: 18.sp,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w700,
          ),
        ),
        10.sp.verticalSpace,
        Text(
          'Pick a plan that matches your budget and unlock mining rewards.',
          style: TextStyle(
            color: const Color(0xFF757575),
            fontSize: 14.sp,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w400,
          ),
        ),
        20.sp.verticalSpace,
        _buildPackageCard(
          price: 50,
          name: 'Starter Package',
          description:
              'Offering up to 5,000 DOGE or 257,000 STB in rewards. Advance through the required stages to unlock the full payout.',
          isSelected: true,
        ),
        15.sp.verticalSpace,
        _buildPackageCard(
          price: 200,
          name: 'Growth Package',
          description:
              'Offering up to 28,600 DOGE or 1,315,000 STB in rewards. Move through all stages to claim the maximum benefit.',
        ),
        15.sp.verticalSpace,
        _buildPackageCard(
          price: 500,
          name: 'Advanced Package',
          description:
              'Offering up to 50,000 DOGE or 2,300,000 STB in rewards. Progress through the necessary stages to access the full reward.',
        ),
        15.sp.verticalSpace,
        _buildPackageCard(
          price: 1000,
          name: 'Pro Package',
          description:
              'Offering up to 79,000 DOGE or 3,660,000 STB in rewards. Complete all progression levels to receive the entire reward.',
        ),

        40.sp.verticalSpace,
      ],
    );
  }

  Widget _buildHowItWorksItem(String text, {VoidCallback? onInfoTap}) {
    return Row(
      children: [
        Container(
          width: 24.sp,
          height: 24.sp,
          decoration: BoxDecoration(
            // color: const Color(0xFF792A90),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle_outline,
            size: 20.sp,
            color: Color(0xff6d6d6d),
          ),
        ),
        10.horizontalSpace,
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: const Color(0xFF2D2D2D),
              fontSize: 14.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (onInfoTap != null)
          GestureDetector(
            onTap: onInfoTap,
            child: Container(
              width: 24.sp,
              height: 24.sp,
              decoration: BoxDecoration(
                color: const Color(0xFF792A90).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.help_outline,
                size: 16.sp,
                color: const Color(0xFF792A90),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPackageCard({
    required int price,
    required String name,
    required String description,
    bool isSelected = false,
  }) {
    return GestureDetector(
      onTap: () {
        Navigate.toNamed(context, name: '/subscribeview');
        // In real app, pass package data
      },
      child: Container(
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFAE9FF) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF792A90)
                : const Color(0xFFE0E0E0),
            width: isSelected ? 1 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$$price $name',
                  style: TextStyle(
                    color: const Color(0xFF2D2D2D),
                    fontSize: 18.sp,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (isSelected)
                  GestureDetector(
                    onTap: _showEarningBreakdownModal,
                    child: Container(
                      width: 24.sp,
                      height: 24.sp,
                      decoration: BoxDecoration(
                        color: const Color(0xFF792A90).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.help_outline,
                        size: 16.sp,
                        color: const Color(0xFF792A90),
                      ),
                    ),
                  ),
              ],
            ),
            10.sp.verticalSpace,
            Text(
              description,
              style: TextStyle(
                color: const Color(0xFF757575),
                fontSize: 12.sp,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
            if (isSelected) ...[
              15.sp.verticalSpace,
              AppButton(
                text: 'Subscribe',
                textColor: Colors.white,
                color: const Color(0xFF792A90),
                onTap: () {
                  Navigate.toNamed(context, name: '/subscribeview').then((
                    value,
                  ) {
                    if (value == true) {
                      setState(() {
                        subScribed = true;
                      });
                    }
                    // setState(() {});
                  });
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    bool isFullWidth = false,
  }) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFF757575),
              fontSize: 12.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w400,
            ),
          ),
          8.sp.verticalSpace,
          Text(
            value,
            style: TextStyle(
              color: const Color(0xFF2D2D2D),
              fontSize: 20.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// Earning Breakdown Modal
class EarningBreakdownModal extends StatelessWidget {
  const EarningBreakdownModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.sp,
              height: 4.sp,
              margin: EdgeInsets.only(bottom: 20.sp),
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Center(
            child: Text(
              'Earning Breakdown Explained',
              style: TextStyle(
                color: const Color(0xFF2D2D2D),
                fontSize: 20.sp,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          20.sp.verticalSpace,
          Text(
            'Each time your activity count reaches a specific milestone (called completes), a new reward tier is unlocked.',
            style: TextStyle(
              color: const Color(0xFF757575),
              fontSize: 14.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
          15.sp.verticalSpace,
          Text(
            'Your completes increase as your participation grows, and every tier unlocks automatically as the required milestones are reached.',
            style: TextStyle(
              color: const Color(0xFF757575),
              fontSize: 14.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
          30.sp.verticalSpace,
          AppButton(
            text: 'Okay, I Got it',
            textColor: Colors.white,
            color: const Color(0xFF792A90),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          10.sp.verticalSpace,
        ],
      ),
    );
  }
}
