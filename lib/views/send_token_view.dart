import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/utils/navigator.dart';
import 'package:quanthex/views/qr_scan_view.dart';
import 'package:quanthex/widgets/app_button.dart';
import 'package:quanthex/widgets/app_textfield.dart';
import 'package:quanthex/widgets/confirm_pin_modal.dart';
import 'package:quanthex/widgets/transfer_success_modal.dart';

class SendTokenView extends StatefulWidget {
  const SendTokenView({super.key});

  @override
  State<SendTokenView> createState() => _SendTokenViewState();
}

class _SendTokenViewState extends State<SendTokenView> {
  String _selectedToken = 'Ethereum';
  String _selectedChain = '';
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  bool _isAddressCorrect = false;
  final double _balance = 3654.29;
  double _amount = 0.0;
  String _recipientAddress = '';

  @override
  void dispose() {
    _addressController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _validateAddress(String address) {
    setState(() {
      _isAddressCorrect = address.isNotEmpty && address.length > 10;
      _recipientAddress = address;
    });
  }

  void _showAssetsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      builder: (context) => AssetsModal(
        onTokenSelected: (token) {
          setState(() {
            _selectedToken = token;
          });
          Navigator.pop(context);
        },
      ),
    );
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

  void _showConfirmTransaction() {
    if (_selectedChain.isEmpty || _recipientAddress.isEmpty || _amount == 0) {
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ConfirmTransactionModal(
        token: _selectedToken,
        chain: _selectedChain,
        amount: _amount,
        recipientAddress: _recipientAddress,
        onConfirm: () {
          // Navigator.pop(context);
          // print("object");
          Future.delayed(Duration(milliseconds: 200), () {
            _showSuccessModal();
          });
        },
      ),
    );
  }

  void _showSuccessModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TransferSuccessModal(
        token: _selectedToken,
        chain: _selectedChain,
        amount: _amount,
        recipientAddress: _recipientAddress,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canSend =
        _selectedChain.isNotEmpty &&
        _recipientAddress.isNotEmpty &&
        _amount > 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height - 100,
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
                        'Send Token',
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
                          child: Image.asset(
                            'assets/images/history.png',
                            width: 19.sp,
                            height: 19.sp,
                          ),
                        ),
                        onPressed: () {
                          Navigate.toNamed(
                            context,
                            name: '/transactionhistoryview',
                          );
                        },
                      ),
                    ],
                  ),
                  30.sp.verticalSpace,
                  // From Section
                  Container(
                    padding: EdgeInsets.all(16.sp),
                    decoration: BoxDecoration(
                      // color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFEAEAEA)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        15.sp.verticalSpace,
                        Row(
                          children: [
                            GestureDetector(
                              onTap: _showAssetsModal,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  border: Border.all(
                                    color: const Color(0xFFEAEAEA),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
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
                                      child: Image.asset(
                                        'assets/images/eth_logo.png',
                                        width: 20.sp,
                                        height: 20.sp,
                                      ),
                                    ),
                                    10.horizontalSpace,
                                    Text(
                                      _selectedToken,
                                      style: TextStyle(
                                        color: const Color(0xFF2D2D2D),
                                        fontSize: 16.sp,
                                        fontFamily: 'Satoshi',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    // Spacer(),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 24.sp,
                                      color: const Color(0xFF757575),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            10.sp.horizontalSpace,
                            Expanded(
                              child: TextField(
                                controller: _amountController,

                                style: TextStyle(
                                  color: const Color(0xFF2D2D2D),

                                  fontSize: 28.sp,
                                  fontFamily: 'Satoshi',
                                  fontWeight: FontWeight.w700,
                                ),
                                keyboardType: TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                textAlign: TextAlign.right,
                                decoration: InputDecoration(
                                  hintText: '0',

                                  hintStyle: TextStyle(
                                    color: const Color(0xFF9E9E9E),
                                    fontSize: 28.sp,
                                    fontFamily: 'Satoshi',
                                    fontWeight: FontWeight.w700,
                                  ),
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _amount = double.tryParse(value) ?? 0.0;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        20.sp.verticalSpace,

                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            _amount > 0
                                ? '\$${(_amount * 3088.07).toStringAsFixed(2)}'
                                : 'null',
                            style: TextStyle(
                              color: const Color(0xFF515151),
                              fontSize: 12.sp,
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  20.sp.verticalSpace,
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
                      padding: EdgeInsets.all(10.sp),
                      decoration: BoxDecoration(
                        color: _selectedChain.isEmpty
                            ? const Color(0xffF5F5F5)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(25),
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
                  // Recipients Address
                  Text(
                    'Recipients Address',
                    style: TextStyle(
                      color: const Color(0xFF2D2D2D),
                      fontSize: 14.sp,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  10.sp.verticalSpace,
                  Stack(
                    children: [
                      AppTextfield(
                        controller: _addressController,
                        hintText: 'Enter your receiver\'s address',
                        borderColor: _isAddressCorrect
                            ? const Color(0xFF792A90)
                            : const Color(0xFFE0E0E0),
                        radius: 25,
                        onChanged: _validateAddress,
                        filledColor: _isAddressCorrect
                            ? Colors.transparent
                            : const Color(0xffF5F5F5),
                        useFill: true,
                      ),
                      Positioned(
                        right: 15.sp,
                        top: 15.sp,
                        child: GestureDetector(
                          onTap: () async {
                            // Simulate QR scan - in real app, open QR scanner
                            final scanned = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const QRScanView(),
                              ),
                            );
                            if (context.mounted &&
                                scanned != null &&
                                scanned is String) {
                              _addressController.text = scanned;
                              _validateAddress(scanned);
                            }
                          },
                          child: Icon(
                            Icons.qr_code_scanner,
                            size: 24.sp,
                            color: const Color(0xFF757575),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_isAddressCorrect) ...[
                    10.sp.verticalSpace,
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.sp,
                        vertical: 6.sp,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9E6FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Address Correct',
                        style: TextStyle(
                          color: const Color(0xFF792A90),
                          fontSize: 12.sp,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                  Spacer(),
                  // 30.sp.verticalSpace,
                  AppButton(
                    text: 'Send Token',
                    textColor: Colors.white,
                    color: canSend
                        ? const Color(0xFF792A90)
                        : const Color(0xFFB5B5B5),
                    onTap: canSend ? _showConfirmTransaction : null,
                  ),
                  20.sp.verticalSpace,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Chain Network Modal
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

// Assets Modal (reusing similar structure)
class AssetsModal extends StatefulWidget {
  final Function(String) onTokenSelected;

  const AssetsModal({super.key, required this.onTokenSelected});

  @override
  State<AssetsModal> createState() => _AssetsModalState();
}

class _AssetsModalState extends State<AssetsModal> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _tokens = [
    {
      'name': 'Tether',
      'symbol': 'USDT',
      'balance': '23.61',
      'color': Colors.green,
    },
    {
      'name': 'Bitcoin',
      'symbol': 'BTC',
      'balance': '0.00004273',
      'color': Colors.orange,
    },
    {'name': 'Tron', 'symbol': 'TRX', 'balance': '527', 'color': Colors.red},
    {'name': 'XRP', 'symbol': 'XRP', 'balance': '23.61', 'color': Colors.grey},
    {
      'name': 'BNB',
      'symbol': 'BNB',
      'balance': '2.6518',
      'color': Colors.yellow,
    },
    {
      'name': 'Solana',
      'symbol': 'SOL',
      'balance': '0.27341',
      'color': Colors.purple,
    },
    {
      'name': 'Dogecoin',
      'symbol': 'DOGE',
      'balance': '0.0006328',
      'color': Colors.yellow,
    },
    {
      'name': 'Cardano',
      'symbol': 'ADA',
      'balance': '0.0002332',
      'color': Colors.blue,
    },
    {
      'name': 'Stellar',
      'symbol': 'XLM',
      'balance': '1.2722',
      'color': Colors.black,
    },
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
              'Assets',
              style: TextStyle(
                color: const Color(0xFF2D2D2D),
                fontSize: 20.sp,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          20.sp.verticalSpace,
          AppTextfield(
            controller: _searchController,
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
          20.sp.verticalSpace,
          Text(
            'Favorites',
            style: TextStyle(
              color: const Color(0xFF2D2D2D),
              fontSize: 16.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w600,
            ),
          ),
          15.sp.verticalSpace,
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _tokens.length,
              itemBuilder: (context, index) {
                final token = _tokens[index];
                return GestureDetector(
                  onTap: () {
                    widget.onTokenSelected(token['name']);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.sp),
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
                            Icons.circle,
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
                        Text(
                          token['balance'],
                          style: TextStyle(
                            color: const Color(0xFF2D2D2D),
                            fontSize: 15.sp,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w600,
                          ),
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

// Confirm Transaction Modal
class ConfirmTransactionModal extends StatefulWidget {
  final String token;
  final String chain;
  final double amount;
  final String recipientAddress;
  final VoidCallback onConfirm;

  const ConfirmTransactionModal({
    super.key,
    required this.token,
    required this.chain,
    required this.amount,
    required this.recipientAddress,
    required this.onConfirm,
  });

  @override
  State<ConfirmTransactionModal> createState() =>
      _ConfirmTransactionModalState();
}

class _ConfirmTransactionModalState extends State<ConfirmTransactionModal> {
  @override
  Widget build(BuildContext context) {
    final amountUsd = widget.amount * 3088.07;
    final isPolygon = widget.chain.contains('Polygon');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      height: 700.sp,
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
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 80.sp,
                height: 80.sp,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9E6FF),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/images/eth_logo.png',
                  width: 60.sp,
                  height: 60.sp,
                ),
              ),
              // if (isPolygon)
              Positioned(
                bottom: -5.sp,
                right: -5.sp,
                child: Container(
                  width: 40.sp,
                  height: 40.sp,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/matic_logo.png',
                    width: 24.sp,
                    height: 24.sp,
                  ),
                ),
              ),
            ],
          ),
          20.sp.verticalSpace,
          Text(
            'Confirm Transaction',
            style: TextStyle(
              color: const Color(0xFF2D2D2D),
              fontSize: 22.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w700,
            ),
          ),
          10.sp.verticalSpace,
          Text(
            'Review and confirm your transaction\nbefore sending.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF757575),
              fontSize: 14.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w400,
            ),
          ),
          20.sp.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/swapduo.png',
                width: 39.sp,
                height: 22.sp,
              ),
              10.horizontalSpace,
              Text(
                '${widget.amount} ETH (${widget.chain.contains('Polygon') ? 'MATIC' : 'ETH'})',
                style: TextStyle(
                  color: const Color(0xFF2D2D2D),
                  fontSize: 24.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          5.sp.verticalSpace,
          Text(
            '≈ \$${amountUsd.toStringAsFixed(2)} USD',
            style: TextStyle(
              color: const Color(0xFF757575),
              fontSize: 14.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
            ),
          ),
          25.sp.verticalSpace,
          Container(
            padding: EdgeInsets.all(16.sp),
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildDetailRow('From', 'Main Wallet\n9vVJj3E.....9MoH'),
                15.sp.verticalSpace,
                _buildDetailRow(
                  'To',
                  widget.recipientAddress.length > 20
                      ? '${widget.recipientAddress.substring(0, 10)}...${widget.recipientAddress.substring(widget.recipientAddress.length - 10)}'
                      : widget.recipientAddress,
                ),
                15.sp.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Network',
                      style: TextStyle(
                        color: const Color(0xFF757575),
                        fontSize: 14.sp,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    10.sp.horizontalSpace,
                    Expanded(
                      child: Row(
                        children: [
                          // if (isPolygon)
                          Image.asset(
                            'assets/images/matic_logo.png',
                            width: 20.sp,
                            height: 20.sp,
                          ),
                          8.horizontalSpace,
                          Expanded(
                            child: Text(
                              widget.chain,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: const Color(0xFF792A90),
                                fontSize: 14.sp,
                                fontFamily: 'Satoshi',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          20.sp.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Network Fee',
                style: TextStyle(
                  color: const Color(0xFF757575),
                  fontSize: 14.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                '\$0.21',
                style: TextStyle(
                  color: const Color(0xFF2D2D2D),
                  fontSize: 14.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          10.sp.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  color: const Color(0xFF2D2D2D),
                  fontSize: 16.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${widget.amount} ETH',
                style: TextStyle(
                  color: const Color(0xFF2D2D2D),
                  fontSize: 16.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          30.sp.verticalSpace,
          AppButton(
            text: 'Send Token',
            color: Color(0xff792A90),
            textColor: Color(0xffffffff),
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                builder: (context) => ConfirmPinModal(
                  title: 'Confirm Swap',
                  pinLength: 6,
                  onPinComplete: (pin) {
                    // Navigator.pop(context);
                    print("widget.onConfirm called");
                    widget.onConfirm();
                  },
                ),
              );
            },
          ),
          10.sp.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/security-safe.png',
                width: 16.sp,
                height: 16.sp,
              ),
              Text(
                'Your transaction is secured by a smart contract',
                style: TextStyle(
                  color: const Color(0xFF7E7E7E),
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
          20.sp.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: const Color(0xFF2D2D2D),
              fontSize: 14.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
