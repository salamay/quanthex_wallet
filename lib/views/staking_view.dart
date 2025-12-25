import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/utils/navigator.dart';
import 'package:quanthex/widgets/app_button.dart';
import 'package:quanthex/widgets/bottom_nav_bar.dart';
import 'package:quanthex/widgets/confirm_pin_modal.dart';

class StakingView extends StatefulWidget {
  const StakingView({super.key});

  @override
  State<StakingView> createState() => _StakingViewState();
}

class _StakingViewState extends State<StakingView> {
  bool _hasActiveStaking = false; // Change to true to show active state
  final double _balance = 120.0;

  void _showWithdrawModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      builder: (context) => ConfirmWithdrawalModal(
        amount: _balance,
        token: 'USDT',
        onConfirm: (pin) {
          Navigator.pop(context);
          print("confirming withdraw");
          Future.delayed(Duration(milliseconds: 200), () {
            _showWithdrawSuccessModal();
          });
        },
      ),
    );
  }

  void _showWithdrawSuccessModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WithdrawSuccessModal(
        amount: _balance,
        token: 'USDT',
        chain: 'Polygon Mainnet',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with gradient background
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 160.sp,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFF792A90),
                            const Color(0xFF9B4DB0),
                          ],
                        ),
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images/staking_backimage.png',
                          ),
                          colorFilter: ColorFilter.mode(
                            Color(0xff792a901a),
                            BlendMode.darken,
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                      // child: Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 20),
                      //   child: Column(
                      //     children: [
                      //       15.sp.verticalSpace,

                      //       20.sp.verticalSpace,
                      //     ],
                      //   ),
                      // ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigate.back(context);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.arrow_back,
                                  size: 20.sp,
                                  color: Colors.white,
                                ),
                                5.horizontalSpace,
                                Text(
                                  'Back',
                                  style: TextStyle(
                                    color: Colors.white,
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
                            'Staking',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Spacer(),
                          SizedBox(width: 60.sp), // Balance for back button
                        ],
                      ),
                    ),
                  ],
                ),
                _hasActiveStaking
                    ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: _buildActiveStakingView(),
                )
                    : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: _buildEmptyStakingView(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveStakingView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.sp.verticalSpace,
        // Farming USDT Card
        Container(
          padding: EdgeInsets.all(20.sp),
          decoration: BoxDecoration(
            // gradient: LinearGradient(
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            //   colors: [const Color(0xFF792A90), const Color(0xFF9B4DB0)],
            // ),
            gradient: LinearGradient(
              begin: Alignment(0.00, 0.50),
              end: Alignment(1.00, 0.50),
              colors: [const Color(0xFF792A90), const Color(0xFF280233)],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Farming USDT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    8.sp.verticalSpace,
                    Text(
                      '0.5 - 3% Daily APY',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14.sp,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 80.sp,
                height: 80.sp,
                decoration: BoxDecoration(
                  // color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/farming_image.png'),
                  ),
                ),
                // child: Icon(Icons.eco, size: 50.sp, color: Colors.white),
              ),
            ],
          ),
        ),
        20.sp.verticalSpace,
        // Withdraw Now Button
        AppButton(
          text: 'Withdraw Now',
          textColor: const Color(0xFF792A90),
          color: const Color(0xFFF9E6FF),
          onTap: _showWithdrawModal,
        ),
        20.sp.verticalSpace,
        // Staking Details Card
        Container(
          padding: EdgeInsets.all(16.sp),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _buildDetailRow('Matching Bonus', '20%'),
              15.sp.verticalSpace,
              _buildDetailRow('Capital Flexibility', 'Anytime'),
              15.sp.verticalSpace,
              _buildDetailRow(
                'Instant Activation',
                'Immediately after payment',
              ),
              15.sp.verticalSpace,
              _buildDetailRow('Daily Payouts', 'Every 24 Hours'),
            ],
          ),
        ),
        30.sp.verticalSpace,
        // Subscribed Packages
        Text(
          'Subscribed Packages',
          style: TextStyle(
            color: const Color(0xFF2D2D2D),
            fontSize: 18.sp,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w700,
          ),
        ),
        15.sp.verticalSpace,
        _buildEarningItem('Dec 22, 2025 - 11:46 AM', '3.20'),
        _buildEarningItem('Dec 22, 2025 - 11:46 AM', '3.10'),
        _buildEarningItem('Dec 22, 2025 - 11:46 AM', '3.05'),
        _buildEarningItem('Dec 22, 2025 - 11:46 AM', '3.00'),
        40.sp.verticalSpace,
      ],
    );
  }

  Widget _buildEmptyStakingView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.sp.verticalSpace,
        // Description
        Text(
          'Staking Reward lets you earn daily returns on your capital while still keeping full control of your money. You subscribe to a staking plan, your capital is locked for daily earnings, and you can withdraw it anytime.',
          style: TextStyle(
            color: const Color(0xFF757575),
            fontSize: 14.sp,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
        30.sp.verticalSpace,
        // Active Plans Section
        Text(
          'Active Plans',
          style: TextStyle(
            color: const Color(0xFF2D2D2D),
            fontSize: 18.sp,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w700,
          ),
        ),
        15.sp.verticalSpace,
        // Empty State
        Container(
          padding: EdgeInsets.all(20.sp),
          child: Column(
            children: [
              Container(
                width: 107.sp,
                height: 107.sp,
                decoration: BoxDecoration(
                  // color: const Color(0xFFF5F5F5),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/empty_stake_imaage.png'),
                  ),
                ),
                // child: Icon(
                //   Icons.inbox_outlined,
                //   size: 60.sp,
                //   color: const Color(0xFFE0E0E0),
                // ),
              ),
              20.sp.verticalSpace,
              Text(
                'You currently have not subscribed to any staking. stake and they will display here.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF757575),
                  fontSize: 14.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        40.sp.verticalSpace,
        // Stake Now Button
        AppButton(
          text: 'Stake Now',
          textColor: Colors.white,
          color: const Color(0xFF792A90),
          onTap: () {
            Navigate.toNamed(context, name: '/subscribestakingview').then((
              value,
            ) {
              if (value == true) {
                setState(() {
                  _hasActiveStaking = true;
                });
              }
            });
          },
        ),
        40.sp.verticalSpace,
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
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

  Widget _buildEarningItem(String date, String amount) {
    return Container(
      // margin: EdgeInsets.only(bottom: 1.sp),
      padding: EdgeInsets.only(
        left: 16.sp,
        right: 16.sp,
        bottom: 10.sp,
        top: 10.sp,
      ),
      decoration: BoxDecoration(
        // color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40.sp,
                height: 40.sp,
                decoration: BoxDecoration(
                  // color: Colors.green.withOpacity(0.2),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/usdt_image.png'),
                  ),
                ),
                // child: Center(
                //   child: Text(
                //     'T',
                //     style: TextStyle(
                //       color: Colors.green,
                //       fontSize: 20.sp,
                //       fontFamily: 'Satoshi',
                //       fontWeight: FontWeight.w700,
                //     ),
                //   ),
                // ),
              ),
              15.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Earnings',
                      style: TextStyle(
                        color: const Color(0xFF2D2D2D),
                        fontSize: 16.sp,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    4.sp.verticalSpace,
                    Text(
                      date,
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
              Text(
                'Received $amount USDT',
                style: TextStyle(
                  color: const Color(0xFF2D2D2D),
                  fontSize: 16.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          10.sp.verticalSpace,
          Container(
            height: 1,
            width: MediaQuery.sizeOf(context).width,
            color: Color(0xffEEEEEE),
          ),
        ],
      ),
    );
  }
}

// Confirm Withdrawal Modal
class ConfirmWithdrawalModal extends StatelessWidget {
  final double amount;
  final String token;
  final Function(String)? onConfirm;

  const ConfirmWithdrawalModal({
    super.key,
    required this.amount,
    required this.token,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final networkFee = amount * 0.01; // 1% fee example

    return Container(
      padding: EdgeInsets.all(24.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          // USDT Icon
          Container(
            width: 80.sp,
            height: 80.sp,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 60.sp,
                  height: 60.sp,
                  decoration: BoxDecoration(
                    // color: Colors.green.withOpacity(0.2),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/images/usdt_image.png'),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'T',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.sp,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          20.sp.verticalSpace,
          Text(
            'Confirm Withdrawal',
            style: TextStyle(
              color: const Color(0xFF2D2D2D),
              fontSize: 20.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w700,
            ),
          ),
          15.sp.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.sp),
            child: Text(
              'You\'re about to withdraw \$$amount $token to your selected wallet address, Please review the details below before proceeding.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF757575),
                fontSize: 14.sp,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
          ),
          30.sp.verticalSpace,
          Container(
            padding: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Amount',
                      style: TextStyle(
                        color: const Color(0xFF757575),
                        fontSize: 14.sp,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      '\$$amount $token',
                      style: TextStyle(
                        color: const Color(0xFF2D2D2D),
                        fontSize: 16.sp,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                15.sp.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Network Fee:',
                      style: TextStyle(
                        color: const Color(0xFF757575),
                        fontSize: 14.sp,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      '\$${networkFee.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: const Color(0xFF2D2D2D),
                        fontSize: 16.sp,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          30.sp.verticalSpace,
          AppButton(
            text: 'Confirm Withdraw',
            textColor: Colors.white,
            color: const Color(0xFF792A90),
            padding: EdgeInsets.zero,
            onTap: () {
              // Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                builder: (context) => ConfirmPinModal(
                  title: 'Confirm Withdrawal',
                  pinLength: 5,
                  onPinComplete: (pin) {
                    // Navigator.pop(context);
                    if (onConfirm != null) {
                      onConfirm!(pin);
                    }
                  },
                ),
              );
            },
          ),
          20.sp.verticalSpace,
        ],
      ),
    );
  }
}

// Withdraw Success Modal
class WithdrawSuccessModal extends StatelessWidget {
  final double amount;
  final String token;
  final String chain;

  const WithdrawSuccessModal({
    super.key,
    required this.amount,
    required this.token,
    required this.chain,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.all(24.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.sp,
            height: 4.sp,
            margin: EdgeInsets.only(bottom: 20.sp),
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 30.sp),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 60.sp,
                      height: 60.sp,
                      decoration: BoxDecoration(
                        // color: Colors.green.withOpacity(0.2),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/images/usdt_image.png'),
                        ),
                      ),
                      // decoration: BoxDecoration(
                      //   color: Colors.green.withOpacity(0.2),
                      //   shape: BoxShape.circle,
                      // ),
                      // child: Center(
                      //   child: Text(
                      //     'T',
                      //     style: TextStyle(
                      //       color: Colors.green,
                      //       fontSize: 30.sp,
                      //       fontFamily: 'Satoshi',
                      //       fontWeight: FontWeight.w700,
                      //     ),
                      //   ),
                      // ),
                    ),
                    Positioned(
                      left: -40.sp,
                      child: Container(
                        width: 60.sp,
                        height: 60.sp,
                        decoration: BoxDecoration(
                          color: const Color(0xFF792A90),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          size: 30.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              15.horizontalSpace,
              Text(
                '+$amount $token',
                style: TextStyle(
                  color: const Color(0xFF2D2D2D),
                  fontSize: 20.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          20.sp.verticalSpace,
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              style: TextStyle(
                color: const Color(0xFF2D2D2D),
                fontSize: 16.sp,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
              children: [
                TextSpan(text: 'An amount of '),
                TextSpan(
                  text: '$amount $token',
                  style: TextStyle(
                    color: const Color(0xFF792A90),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: ' has been successfully paid to your wallet.'),
              ],
            ),
          ),
          10.sp.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/matic_logo.png',
                width: 20.sp,
                height: 20.sp,
              ),
              8.horizontalSpace,
              Text(
                chain,
                style: TextStyle(
                  color: const Color(0xFF757575),
                  fontSize: 14.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          30.sp.verticalSpace,
          AppButton(
            text: 'Done',
            textColor: Colors.white,
            color: const Color(0xFF792A90),
            padding: EdgeInsets.all(5),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          20.sp.verticalSpace,
        ],
      ),
    );
  }
}
