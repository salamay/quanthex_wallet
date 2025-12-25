import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/utils/navigator.dart';
import 'package:quanthex/views/subscribe_view.dart'; // Reuse modals
import 'package:quanthex/widgets/app_button.dart';
import 'package:quanthex/widgets/confirm_pin_modal.dart';

class SubscribeStakingView extends StatefulWidget {
  final Map<String, dynamic>? package;

  const SubscribeStakingView({super.key, this.package});

  @override
  State<SubscribeStakingView> createState() => _SubscribeStakingViewState();
}

class _SubscribeStakingViewState extends State<SubscribeStakingView> {
  String _selectedChain = '';
  final String _selectedPaymentToken = 'USDT';
  double _amount = 100.0;
  final double _balance = 3503.52;

  late Map<String, dynamic> _package;

  @override
  void initState() {
    super.initState();
    _package =
        widget.package ??
        {
          'name': '\$100 Staking Package',
          'price': 100.0,
          'description': 'Can be withdrawn anytime',
          'icon': Icons.bolt,
        };
    _amount = _package['price'] ?? 100.0;
  }

  void _showChainNetworkModal() {
    // showModalBottomSheet(
    //   context: context,
    //   isScrollControlled: true,
    //   backgroundColor: Colors.white,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
    //   ),
    //   builder: (context) => ChainNetworkModal(
    //     onChainSelected: (chain) {
    //       setState(() {
    //         _selectedChain = chain;
    //       });
    //       Navigator.pop(context);
    //     },
    //   ),
    // );
  }

  void _showPaymentModal() {
    if (_selectedChain.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please select chain network')));
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      builder: (context) => ConfirmPinModal(
        title: 'Confirm Pay',
        pinLength: 5,
        onPinComplete: (pin) {
          // Navigator.pop(context);
          _showPaymentSuccessModal();
        },
      ),
    );
  }

  void _showPaymentSuccessModal() {
    Future.delayed(Duration(milliseconds: 200), () {
      if (!mounted) return;
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        backgroundColor: Colors.transparent,
        builder: (context) => StakingPaymentSuccessModal(
          amount: _amount,
          token: _selectedPaymentToken,
          chain: _selectedChain,
          packageName: _package['name'] ?? 'Staking Package',
          onDoneTap: () {
            Navigator.pop(context);
            Navigator.pop(context, true);
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final canPay = _selectedChain.isNotEmpty && _amount <= _balance;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                      'Subscribe',
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
                // Chain Network
                Text(
                  'Chain Network',
                  style: TextStyle(
                    color: const Color(0xFF2D2D2D),
                    fontSize: 14.sp,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                10.sp.verticalSpace,
                GestureDetector(
                  onTap: _showChainNetworkModal,
                  child: Container(
                    padding: EdgeInsets.all(16.sp),
                    decoration: BoxDecoration(
                      color: _selectedChain.isEmpty
                          ? const Color(0xFFF5F5F5)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(35),
                      border: Border.all(
                        color: _selectedChain.isEmpty
                            ? const Color(0xFFE0E0E0)
                            : const Color(0xFF792A90),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _selectedChain.isEmpty
                                ? 'Select your chain network'
                                : _selectedChain,
                            style: TextStyle(
                              color: _selectedChain.isEmpty
                                  ? const Color(0xFF9E9E9E)
                                  : const Color(0xFF2D2D2D),
                              fontSize: 16.sp,
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 24.sp,
                          color: const Color(0xFF757575),
                        ),
                      ],
                    ),
                  ),
                ),
                20.sp.verticalSpace,
                // From Section
                Container(
                  padding: EdgeInsets.all(16.sp),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFEAEAEA)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'From',
                            style: TextStyle(
                              color: const Color(0xFF757575),
                              fontSize: 14.sp,
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Balance: \$$_balance',
                            style: TextStyle(
                              color: const Color(0xFF757575),
                              fontSize: 14.sp,
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      10.sp.verticalSpace,
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 3,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xffEAEAEA)),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 32.sp,
                                  height: 32.sp,

                                  // decoration: BoxDecoration(
                                  //   color: Colors.green.withOpacity(0.2),
                                  //   shape: BoxShape.circle,
                                  // ),
                                  decoration: BoxDecoration(
                                    // color: Colors.green.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage(
                                        'assets/images/usdt_image.png',
                                      ),
                                    ),
                                  ),
                                  // child: Center(
                                  //   child: Text(
                                  //     'T',
                                  //     style: TextStyle(
                                  //       color: Colors.green,
                                  //       fontSize: 18.sp,
                                  //       fontFamily: 'Satoshi',
                                  //       fontWeight: FontWeight.w700,
                                  //     ),
                                  //   ),
                                  // ),
                                ),
                                10.horizontalSpace,
                                Text(
                                  _selectedPaymentToken,
                                  style: TextStyle(
                                    color: const Color(0xFF2D2D2D),
                                    fontSize: 16.sp,
                                    fontFamily: 'Satoshi',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 24.sp,
                                  color: const Color(0xFF757575),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Text(
                            '$_amount $_selectedPaymentToken',
                            style: TextStyle(
                              color: const Color(0xFF2D2D2D),
                              fontSize: 20.sp,
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
                // Staking Package Details
                Container(
                  padding: EdgeInsets.all(16.sp),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAE9FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48.sp,
                        height: 48.sp,
                        decoration: BoxDecoration(
                          color: Color(0xffF7DBFF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Container(
                            width: 24.sp,
                            height: 24.sp,
                            decoration: BoxDecoration(
                              color: const Color(0xFF792A90),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _package['icon'] ?? Icons.bolt,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ),
                      15.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _package['name'] ?? '\$100 Staking Package',
                              style: TextStyle(
                                color: const Color(0xFF2D2D2D),
                                fontSize: 16.sp,
                                fontFamily: 'Satoshi',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            5.sp.verticalSpace,
                            Text(
                              _package['description'] ??
                                  'Can be withdrawn anytime',
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
                      Text(
                        '$_amount USDT',
                        style: TextStyle(
                          color: const Color(0xFF792A90),
                          fontSize: 18.sp,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                40.sp.verticalSpace,
                AppButton(
                  text: 'Pay Now',
                  textColor: Colors.white,
                  color: canPay
                      ? const Color(0xFF792A90)
                      : const Color(0xFFB5B5B5),
                  onTap: (){
                    if(canPay){
                      _showPaymentModal();
                    }
                  } ,
                ),
                20.sp.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Staking Payment Success Modal
class StakingPaymentSuccessModal extends StatelessWidget {
  final double amount;
  final String token;
  final String chain;
  final String packageName;
  final void Function()? onDoneTap;

  const StakingPaymentSuccessModal({
    super.key,
    required this.amount,
    required this.token,
    required this.chain,
    required this.packageName,
    this.onDoneTap,
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
                      // decoration: BoxDecoration(
                      //   color: Colors.green.withOpacity(0.2),
                      //   shape: BoxShape.circle,
                      // ),
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
                '-$amount $token',
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
                TextSpan(text: 'Payment of '),
                TextSpan(
                  text: '$amount $token',
                  style: TextStyle(
                    color: const Color(0xFF792A90),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: ' is successful, Your staking package is now '),
                TextSpan(
                  text: 'active.',
                  style: TextStyle(
                    color: const Color(0xFF792A90),
                    fontWeight: FontWeight.w700,
                  ),
                ),
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
            onTap:
                onDoneTap ??
                () {
                  Navigator.pop(context);
                },
          ),
          20.sp.verticalSpace,
        ],
      ),
    );
  }
}
