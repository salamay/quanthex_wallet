import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/utils/navigator.dart';

class ReferEarnView extends StatelessWidget {
  const ReferEarnView({super.key});

  @override
  Widget build(BuildContext context) {
    final String referralLink = 'https://quanthex.io/r/QUX4837';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    'Refer and Earn',
                    style: TextStyle(
                      color: const Color(0xFF2D2D2D),
                      fontSize: 18.sp,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Spacer(),
                  SizedBox(width: 60.sp),
                ],
              ),
              30.sp.verticalSpace,
              // Refer & Earn Header
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Refer & Earn',
                      style: TextStyle(
                        color: const Color(0xFF2D2D2D),
                        fontSize: 24.sp,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    width: 102.sp,
                    height: 102.sp,
                    decoration: BoxDecoration(
                      // color: const Color(0xFF792A90),
                      image: DecorationImage(
                        image: AssetImage('assets/images/refer_earn_image.png'),
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.campaign,
                      color: Colors.white,
                      size: 30.sp,
                    ),
                  ),
                ],
              ),
              15.sp.verticalSpace,
              Text(
                'Share your HexaPower link and grow your mining and staking network. Every new member boosts your mining progress and helps you unlock higher rewards.',
                style: TextStyle(
                  color: const Color(0xFF757575),
                  fontSize: 14.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              20.sp.verticalSpace,
              // Referral Link
              Container(
                padding: EdgeInsets.all(16.sp),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF792A90), width: 1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        referralLink,
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
                        Clipboard.setData(ClipboardData(text: referralLink));
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Link copied')));
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
              40.sp.verticalSpace,
              // How It Works
              Text(
                'How It Works',
                style: TextStyle(
                  color: const Color(0xFF2D2D2D),
                  fontSize: 20.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
              20.sp.verticalSpace,
              _buildHowItWorksItem(
                icon: Icons.share,
                iconColor: Colors.cyan,
                title: 'Share your link',
                description:
                    'Invite your friend to join Quanthex by sharing your unique referral links',
              ),
              15.sp.verticalSpace,
              _buildHowItWorksItem(
                icon: Icons.person_add,
                iconColor: Colors.orange,
                title: 'Friends sign up',
                description:
                    'Your friends use your referral link to download and sign up on the app.',
              ),
              15.sp.verticalSpace,
              _buildHowItWorksItem(
                icon: Icons.rocket_launch,
                iconColor: Colors.blue,
                title: 'Friends Join & Boost Your Earnings',
                description:
                    'Your start earning from the mining and also gain more ROI from the staking when they also join.',
              ),
              40.sp.verticalSpace,
              // Referral List
              Text(
                'Referral List',
                style: TextStyle(
                  color: const Color(0xFF2D2D2D),
                  fontSize: 20.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
              20.sp.verticalSpace,
              _buildReferralItem(
                number: "1",
                email: 'oladapo****@gmail.com',
                mining: '+3%',
                staking: '+1.5%',
                status: 'Active',
                joinedDate: '12/06/2025',
              ),
              _buildReferralItem(
                number: "2",
                email: 'precious***@yahoo.com',
                mining: '+2%',
                staking: '-',
                status: 'Active',
                joinedDate: '10/06/2025',
              ),
              _buildReferralItem(
                number: "3",
                email: 'victor**@hotmail.com',
                mining: '-',
                staking: '-',
                status: 'Pending',
                joinedDate: '08/06/2025',
              ),
              40.sp.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHowItWorksItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48.sp,
          height: 48.sp,
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
                title,
                style: TextStyle(
                  color: const Color(0xFF2D2D2D),
                  fontSize: 16.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w600,
                ),
              ),
              5.sp.verticalSpace,
              Text(
                description,
                style: TextStyle(
                  color: const Color(0xFF757575),
                  fontSize: 14.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReferralItem({
    required String email,
    required String mining,
    required String staking,
    required String status,
    required String joinedDate,
    required String number,
  }) {
    final isActive = status == 'Active';

    return Container(
      margin: EdgeInsets.only(bottom: 12.sp),
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        // color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number.',
            style: TextStyle(
              color: const Color(0xFF2D2D2D),
              fontSize: 16.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w600,
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      email,
                      style: TextStyle(
                        color: const Color(0xFF2D2D2D),
                        fontSize: 16.sp,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.sp,
                        vertical: 6.sp,
                      ),
                      // decoration: BoxDecoration(
                      //   color: isActive
                      //       ? const Color(0xFFE8F5E9)
                      //       : const Color(0xFFFFF3E0),
                      //   borderRadius: BorderRadius.circular(8),
                      // ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: Color(0xff454545),
                          // isActive ? Colors.green : Colors.orange,
                          fontSize: 12.sp,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                10.sp.verticalSpace,
                Row(
                  children: [
                    Text(
                      'Mining: $mining',
                      style: TextStyle(
                        color: const Color(0xFF757575),
                        fontSize: 14.sp,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    10.horizontalSpace,
                    Text(
                      '•',
                      style: TextStyle(
                        color: const Color(0xFF757575),
                        fontSize: 14.sp,
                      ),
                    ),
                    10.horizontalSpace,
                    Text(
                      'Staking: $staking',
                      style: TextStyle(
                        color: const Color(0xFF757575),
                        fontSize: 14.sp,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    Spacer(),
                    Text(
                      'Joined: $joinedDate',
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
        ],
      ),
    );
  }
}
