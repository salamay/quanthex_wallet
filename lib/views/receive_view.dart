import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quanthex/utils/navigator.dart';
import 'package:quanthex/widgets/app_button.dart';

class ReceiveView extends StatefulWidget {
  final String? token;

  const ReceiveView({super.key, this.token});

  @override
  State<ReceiveView> createState() => _ReceiveViewState();
}

class _ReceiveViewState extends State<ReceiveView> {
  String _selectedChain = 'Ethereum (ERC-20)';
  String _depositAddress = 'bc1q7c2w0r2lry8r4t8fn0gc9x6j3cr5lw6a0p7xyf';
  String _token = 'Ethereum';

  @override
  void initState() {
    super.initState();
    if (widget.token != null) {
      _token = widget.token!;
    }
  }

  void _showChainNetworkModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      builder: (context) => ReceiveChainNetworkModal(
        currentChain: _selectedChain,
        onChainSelected: (chain) {
          setState(() {
            _selectedChain = chain;
            // Update address based on chain (mock)
            _depositAddress = _getAddressForChain(chain);
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  String _getAddressForChain(String chain) {
    // Mock addresses for different chains
    switch (chain) {
      case 'Ethereum (ERC-20)':
        return '0x91f3A27B3F8eE72c1A4f27B918c3F92c8c61b4e0';
      case 'Polygon (MATIC)':
        return '0xA4f27B918c3F92c8c61b4e0A92dC9E';
      default:
        return 'bc1q7c2w0r2lry8r4t8fn0gc9x6j3cr5lw6a0p7xyf';
    }
  }

  String _getFeeForChain(String chain) {
    switch (chain) {
      case 'Ethereum (ERC-20)':
        return '0.0043 ETH (= \$12.85)';
      case 'Polygon (MATIC)':
        return '0.00007 ETH (= \$0.21)';
      case 'Binance Smart Chain (BEP-20 / BNB Chain)':
        return '0.00011 ETH (= \$0.33)';
      case 'Bitcoin (BTC)':
        return '0.00036 ETH (= \$1.08)';
      case 'Tron (TRC-20)':
        return '0.000015 ETH (= \$0.05)';
      case 'Solana (SOL)':
        return '0.000012 ETH (= \$0.04)';
      default:
        return '0.0043 ETH (= \$12.85)';
    }
  }

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
                      'Receive',
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
                40.sp.verticalSpace,
                // Token Icon
                Container(
                  width: 80.sp,
                  height: 80.sp,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9E6FF),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/eth_logo.png',
                    width: 51.sp,
                    height: 51.sp,
                  ),
                ),
                20.sp.verticalSpace,
                Text(
                  'Receive $_token',
                  style: TextStyle(
                    color: const Color(0xFF2D2D2D),
                    fontSize: 22.sp,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                40.sp.verticalSpace,
                // QR Code Placeholder
                QrImageView(
                  data: _depositAddress,
                  version: QrVersions.auto,
                  size: 250.sp,
                ),
                // Container(
                //   width: 250.sp,
                //   height: 250.sp,
                //   decoration: BoxDecoration(
                //     color: Colors.black,
                //     borderRadius: BorderRadius.circular(12),
                //     border: Border.all(
                //       color: const Color(0xFFE0E0E0),
                //       width: 2,
                //     ),
                //   ),
                //   child: Center(
                //     child: Text(
                //       'QR CODE',
                //       style: TextStyle(
                //         color: Colors.white,
                //         fontSize: 16.sp,
                //         fontFamily: 'Satoshi',
                //         fontWeight: FontWeight.w500,
                //       ),
                //     ),
                //   ),
                // ),
                30.sp.verticalSpace,
                // Chain Network Card
                GestureDetector(
                  onTap: _showChainNetworkModal,
                  child: Container(
                    padding: EdgeInsets.all(16.sp),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Chain Network',
                                style: TextStyle(
                                  color: const Color(0xFF757575),
                                  fontSize: 12.sp,
                                  fontFamily: 'Satoshi',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              8.sp.verticalSpace,
                              Text(
                                _selectedChain,
                                style: TextStyle(
                                  color: const Color(0xFF2D2D2D),
                                  fontSize: 16.sp,
                                  fontFamily: 'Satoshi',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              8.sp.verticalSpace,
                              Text(
                                'Fee: ${_getFeeForChain(_selectedChain)}',
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
                        Icon(
                          Icons.swap_horiz,
                          size: 24.sp,
                          color: const Color(0xFF757575),
                        ),
                      ],
                    ),
                  ),
                ),
                20.sp.verticalSpace,
                // Deposit Address Card
                Container(
                  padding: EdgeInsets.all(16.sp),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Deposit Address',
                              style: TextStyle(
                                color: const Color(0xFF757575),
                                fontSize: 12.sp,
                                fontFamily: 'Satoshi',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            8.sp.verticalSpace,
                            Text(
                              _depositAddress,
                              style: TextStyle(
                                color: const Color(0xFF2D2D2D),
                                fontSize: 14.sp,
                                fontFamily: 'Satoshi',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      10.horizontalSpace,
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(
                            ClipboardData(text: _depositAddress),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Address copied to clipboard'),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.sp,
                            vertical: 8.sp,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF792A90),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.copy,
                                size: 16.sp,
                                color: Colors.white,
                              ),
                              5.horizontalSpace,
                              Text(
                                'Copy',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontFamily: 'Satoshi',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                40.sp.verticalSpace,
                AppButton(
                  text: 'Share Address',
                  textColor: Colors.white,
                  color: const Color(0xFF792A90),
                  onTap: () {
                    // Share functionality
                    Clipboard.setData(ClipboardData(text: _depositAddress));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Address copied to clipboard')),
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
}

// Receive Chain Network Modal
class ReceiveChainNetworkModal extends StatefulWidget {
  final String currentChain;
  final Function(String) onChainSelected;

  const ReceiveChainNetworkModal({
    super.key,
    required this.currentChain,
    required this.onChainSelected,
  });

  @override
  State<ReceiveChainNetworkModal> createState() =>
      _ReceiveChainNetworkModalState();
}

class _ReceiveChainNetworkModalState extends State<ReceiveChainNetworkModal> {
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
  void initState() {
    super.initState();
    _selectedChain = widget.currentChain;
  }

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
                    // color: const Color(0xFF792A90),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF792A90)),
                  ),
                  child: Center(
                    child: Text(
                      'i',
                      style: TextStyle(
                        color: const Color(0xFF792A90),
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
          Flexible(
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
