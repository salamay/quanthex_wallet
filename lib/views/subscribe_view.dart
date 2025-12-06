import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/utils/navigator.dart';
import 'package:quanthex/widgets/app_button.dart';
import 'package:quanthex/widgets/confirm_pin_modal.dart';

class SubscribeView extends StatefulWidget {
  final Map<String, dynamic>? package;

  const SubscribeView({super.key, this.package});

  @override
  State<SubscribeView> createState() => _SubscribeViewState();
}

class _SubscribeViewState extends State<SubscribeView> {
  String _selectedChain = '';
  String _selectedRewardToken = '';
  final String _selectedPaymentToken = 'USDT';
  double _amount = 50.0;
  final double _balance = 3503.52;

  late Map<String, dynamic> _package;

  @override
  void initState() {
    super.initState();
    _package =
        widget.package ??
        {
          'name': 'Starter Mining Package',
          'price': 50.0,
          'duration': '365 Days',
          'icon': Icons.bolt,
        };
    _amount = _package['price'] ?? 50.0;
  }

  void _showChainNetworkModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      builder: (context) => ChainNetworkModal(
        onChainSelected: (chain) {
          setState(() {
            _selectedChain = chain;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showRewardTokenModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      builder: (context) => RewardTokenModal(
        onTokenSelected: (token) {
          setState(() {
            _selectedRewardToken = token;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showPaymentModal() {
    if (_selectedChain.isEmpty || _selectedRewardToken.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select chain network and reward token')),
      );
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
          print("pin entercomplete $pin");
          // Navigator.pop(context);
          _showPaymentSuccessModal();
        },
      ),
    );
  }

  void _showPaymentSuccessModal() {
    // print("object");
    Future.delayed(Duration(milliseconds: 200), () {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        backgroundColor: Colors.transparent,
        builder: (context) => PaymentSuccessModal(
          amount: _amount,
          token: _selectedPaymentToken,
          chain: _selectedChain,
          packageName: _package['name'] ?? 'Mining Package',
          onDoneTap: () {
            Navigator.pop(context);

            Navigator.pop(
              context,
              true,
            ); // this is for back to the mine screen (i returned to true as a key to indicate the guy is subscribed)
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final canPay =
        _selectedChain.isNotEmpty &&
        _selectedRewardToken.isNotEmpty &&
        _amount <= _balance;
    final totalRewardPotential = _amount * 14; // Example calculation

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
                    // IconButton(
                    //   icon: Container(
                    //     width: 41,
                    //     height: 41,
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 2,
                    //       vertical: 9,
                    //     ),
                    //     decoration: ShapeDecoration(
                    //       color: const Color(0x7CDADADA),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(20.50),
                    //       ),
                    //     ),
                    //     child: Image.asset(
                    //       'assets/images/history.png',
                    //       width: 19.sp,
                    //       height: 19.sp,
                    //     ),
                    //   ),
                    //   onPressed: () {
                    //     Navigate.toNamed(
                    //       context,
                    //       name: '/transactionhistoryview',
                    //     );
                    //   },
                    // ),
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
                            ? const Color(0xFFEAEAEA)
                            : const Color(0xFF792A90),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
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
                // Reward Token
                Text(
                  'Reward Token',
                  style: TextStyle(
                    color: const Color(0xFF2D2D2D),
                    fontSize: 14.sp,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                10.sp.verticalSpace,
                GestureDetector(
                  onTap: _showRewardTokenModal,
                  child: Container(
                    padding: EdgeInsets.all(16.sp),
                    decoration: BoxDecoration(
                      color: _selectedRewardToken.isEmpty
                          ? const Color(0xFFF5F5F5)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(35),
                      border: Border.all(
                        color: _selectedRewardToken.isEmpty
                            ? const Color(0xFFE0E0E0)
                            : const Color(0xFF792A90),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 32.sp,
                                height: 32.sp,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF792A90,
                                  ).withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.bolt,
                                  size: 20.sp,
                                  color: const Color(0xFF792A90),
                                ),
                              ),
                              10.horizontalSpace,
                              Expanded(
                                child: Text(
                                  _selectedRewardToken.isEmpty
                                      ? 'Choose your preferred payout currency'
                                      : _selectedRewardToken,
                                  style: TextStyle(
                                    color: _selectedRewardToken.isEmpty
                                        ? const Color(0xFF9E9E9E)
                                        : const Color(0xFF2D2D2D),
                                    fontSize: 16.sp,
                                    fontFamily: 'Satoshi',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
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
                    border: Border.all(color: const Color(0xfffeaeaea)),
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
                // Package Details
                Container(
                  padding: EdgeInsets.all(16.sp),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
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
                              _package['name'] ?? 'Starter Mining Package',
                              style: TextStyle(
                                color: const Color(0xFF2D2D2D),
                                fontSize: 16.sp,
                                fontFamily: 'Satoshi',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            5.sp.verticalSpace,
                            Text(
                              _package['duration'] ?? '365 Days',
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
                20.sp.verticalSpace,
                // Total Reward Potential
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Reward Potential:',
                      style: TextStyle(
                        color: const Color(0xFF757575),
                        fontSize: 14.sp,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '\$${totalRewardPotential.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: const Color(0xFF2D2D2D),
                        fontSize: 18.sp,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                40.sp.verticalSpace,
                AppButton(
                  text: 'Pay Now',
                  textColor: Colors.white,
                  color: canPay
                      ? const Color(0xFF792A90)
                      : const Color(0xFFB5B5B5),
                  onTap: canPay ? _showPaymentModal : null,
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

// Chain Network Modal (reusing from send_token_view)
class ChainNetworkModal extends StatefulWidget {
  final Function(String) onChainSelected;

  const ChainNetworkModal({super.key, required this.onChainSelected});

  @override
  State<ChainNetworkModal> createState() => _ChainNetworkModalState();
}

class _ChainNetworkModalState extends State<ChainNetworkModal> {
  String? _selectedChain;

  final List<Map<String, dynamic>> _chains = [
    {'name': 'Ethereum (ERC-20)', 'fee': '0.0043 ETH', 'feeUsd': '= \$12.85'},
    {'name': 'Polygon (MATIC)', 'fee': '0.00007 ETH', 'feeUsd': '= \$0.21'},
    {
      'name': 'Binance Smart Chain (BEP-20 / BNB Chain)',
      'fee': '0.00011 ETH',
      'feeUsd': '= \$0.33',
    },
    {'name': 'Bitcoin (BTC)', 'fee': '0.00036 ETH', 'feeUsd': '= \$1.08'},
    {'name': 'Tron (TRC-20)', 'fee': '0.000015 ETH', 'feeUsd': '= \$0.05'},
    {'name': 'Solana (SOL)', 'fee': '0.000012 ETH', 'feeUsd': '= \$0.04'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.sp),
      height: 700.sp,
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
              'Choose a Chain Network',
              style: TextStyle(
                color: const Color(0xFF2D2D2D),
                fontSize: 20.sp,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          20.sp.verticalSpace,
          Container(
            padding: EdgeInsets.all(12.sp),
            decoration: BoxDecoration(
              color: const Color(0xFFF9E6FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 20.sp,
                  height: 20.sp,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF792A90)),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      'i',
                      style: TextStyle(
                        color: Color(0xFF792A90),
                        fontSize: 12.sp,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  child: Text(
                    'Make sure that the chain type you make deposits to is the one you make withdrawals from.',
                    style: TextStyle(
                      color: const Color(0xFF2D2D2D),
                      fontSize: 12.sp,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          20.sp.verticalSpace,
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _chains.length,
              itemBuilder: (context, index) {
                final chain = _chains[index];
                final isSelected = _selectedChain == chain['name'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedChain = chain['name'];
                    });
                    widget.onChainSelected(chain['name']);
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 12.sp),
                    padding: EdgeInsets.all(16.sp),
                    decoration: BoxDecoration(
                      color: isSelected ? Color(0xffFAE9FF) : Color(0xffF6F6F6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF792A90)
                            : const Color(0xFFE0E0E0),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                chain['name'],
                                style: TextStyle(
                                  color: const Color(0xFF2D2D2D),
                                  fontSize: 15.sp,
                                  fontFamily: 'Satoshi',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              5.verticalSpace,
                              Text(
                                'Fee: ${chain['fee']} ${chain['feeUsd']}',
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
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: const Color(0xFF792A90),
                            size: 24.sp,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Reward Token Modal
class RewardTokenModal extends StatefulWidget {
  final Function(String) onTokenSelected;

  const RewardTokenModal({super.key, required this.onTokenSelected});

  @override
  State<RewardTokenModal> createState() => _RewardTokenModalState();
}

class _RewardTokenModalState extends State<RewardTokenModal> {
  String? _selectedToken;

  final List<Map<String, dynamic>> _tokens = [
    {
      'name': 'Stabble',
      'symbol': 'STB',
      'icon': Icons.bolt,
      'color': Colors.purple,
    },
    {
      'name': 'Dogecoin',
      'symbol': 'DOGE',
      'icon': Icons.circle,
      'color': Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.sp),
      height: 400.sp,
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
              'Reward Token',
              style: TextStyle(
                color: const Color(0xFF2D2D2D),
                fontSize: 20.sp,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          20.sp.verticalSpace,
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _tokens.length,
              itemBuilder: (context, index) {
                final token = _tokens[index];
                final isSelected = _selectedToken == token['name'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedToken = token['name'];
                    });
                    widget.onTokenSelected(token['name']);
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 12.sp),
                    padding: EdgeInsets.all(16.sp),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFFAE9FF)
                          : const Color(0xFFF6F6F6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF792A90)
                            : const Color(0xFFE0E0E0),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40.sp,
                          height: 40.sp,
                          decoration: BoxDecoration(
                            color: (token['color'] as Color).withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            token['icon'] as IconData,
                            size: 24.sp,
                            color: token['color'] as Color,
                          ),
                        ),
                        15.horizontalSpace,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                token['name'],
                                style: TextStyle(
                                  color: const Color(0xFF2D2D2D),
                                  fontSize: 15.sp,
                                  fontFamily: 'Satoshi',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              4.verticalSpace,
                              Text(
                                token['symbol'],
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
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: const Color(0xFF792A90),
                            size: 24.sp,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Payment Success Modal
class PaymentSuccessModal extends StatelessWidget {
  final double amount;
  final String token;
  final String chain;
  final String packageName;
  final void Function()? onDoneTap;

  const PaymentSuccessModal({
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
                TextSpan(text: ' is successful, Your mining package is now '),
                TextSpan(
                  text: 'active',
                  style: TextStyle(
                    color: const Color(0xFF792A90),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: ' and your HexaPower is running.'),
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
                  // Navigator.of(context).popUntil((route) => route.isFirst);
                },
          ),
          20.sp.verticalSpace,
        ],
      ),
    );
  }
}
