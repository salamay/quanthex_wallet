import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                    // color: const Color(0xFF792A90),
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