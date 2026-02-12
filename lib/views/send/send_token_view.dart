import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/data/Models/assets/network_model.dart';
import 'package:quanthex/data/Models/assets/supported_assets.dart';
import 'package:quanthex/data/Models/network/network_model.dart';
import 'package:quanthex/data/Models/send/send_payload.dart';
import 'package:quanthex/data/services/transaction/transaction_service.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/data/utils/overlay_utils.dart';
import 'package:quanthex/views/home/components/coin_image.dart';
import 'package:quanthex/views/qr_scan_view.dart';
import 'package:quanthex/widgets/app_button.dart';
import 'package:quanthex/widgets/app_textfield.dart';
import 'package:quanthex/widgets/snackbar/my_snackbar.dart';
import '../../core/constants/network_constants.dart';
import '../../data/Models/balance/CoinBalance.dart';
import '../../data/controllers/balance/balance_controller.dart';
import '../../data/utils/assets/asset_utils.dart';
import '../../data/utils/logger.dart';
import '../../data/utils/my_currency_utils.dart';
import '../../widgets/arrow_back.dart';
import 'components/confirm_transaction_modal.dart';

class SendTokenView extends StatefulWidget {
  SendTokenView({super.key, required this.coin});

  SupportedCoin coin;
  @override
  State<SendTokenView> createState() => _SendTokenViewState();
}

class _SendTokenViewState extends State<SendTokenView> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  bool _isAddressCorrect = false;
  double _amountInFiat = 0.0;
  String _recipientAddress = '';
  late NetworkModel _selectedChain;
  late SupportedCoin _selectedCoin;
  late BalanceController balanceController;
  SendPayload? sendPayload;

  @override
  void initState() {
    // TODO: implement initState
    _selectedCoin = widget.coin;
    _selectedChain = widget.coin.networkModel!;
    balanceController = Provider.of<BalanceController>(context, listen: false);
    super.initState();
  }

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

  void _showAssetsModal() async {
    SupportedCoin? result = await AssetUtils.selectAssets(context: context);
    if (result != null) {
      logger("Selected Coin: ${result.name}", runtimeType.toString());
      _selectedCoin = result;
      _selectedChain = result.networkModel!;
      setState(() {});
    }
  }

  Future<String?> _showConfirmTransaction(BuildContext context)async {
    if (_recipientAddress.isEmpty || _amountInFiat == 0) {
      return null;
    }
    if (sendPayload != null) {
      return await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => ConfirmTransactionModal(sendPayload: sendPayload!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final canSend = _recipientAddress.isNotEmpty && _amountInFiat > 0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigate.back(context);
          },
          child: ArrowBack(),
        ),

        title: Text(
          'Send ${_selectedCoin.symbol}',
          style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 18.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height - 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                              style: TextStyle(color: const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                            ),
                            Consumer<BalanceController>(
                              builder: (context, bCtr, child) {
                                double? priceQuotes = bCtr.priceQuotes[_selectedCoin.symbol];
                                CoinBalance? balance = _selectedCoin.coinType == CoinType.TOKEN ? bCtr.balances[_selectedCoin.contractAddress!] : bCtr.balances[_selectedCoin.symbol];
                                return balance != null
                                    ? Text(
                                        'Balance: ${!bCtr.hideBalance
                                            ? balance.balanceInCrypto != 0
                                                  ? "${MyCurrencyUtils.format(balance.balanceInCrypto, _selectedCoin.coinType == CoinType.TOKEN ? 2 : 6) ?? ""} ${_selectedCoin.symbol}"
                                                  : "0 ${_selectedCoin.symbol}"
                                            : "****"}',
                                        style: TextStyle(color: const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                                      )
                                    : const SizedBox();
                              },
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
                                  border: Border.all(color: const Color(0xFFEAEAEA)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 32.sp,
                                      height: 32.sp,
                                      decoration: BoxDecoration(color: const Color(0xFF792A90).withOpacity(0.2), shape: BoxShape.circle),
                                      child: CoinImage(imageUrl: _selectedCoin.image, width: 20.sp, height: 20.sp),
                                    ),
                                    10.horizontalSpace,
                                    Text(
                                      _selectedCoin.name,
                                      style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                                    ),
                                    // Spacer(),
                                    Icon(Icons.keyboard_arrow_down, size: 24.sp, color: const Color(0xFF757575)),
                                  ],
                                ),
                              ),
                            ),
                            10.sp.horizontalSpace,
                            Consumer<BalanceController>(
                              builder: (context, bCtr, child) {
                                double? priceQuotes = bCtr.priceQuotes[_selectedCoin.symbol];
                                return priceQuotes != null
                                    ? Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                controller: _amountController,
                                                style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 28.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                textAlign: TextAlign.right,
                                                decoration: InputDecoration(
                                                  hintText: '0',
                                              
                                                  hintStyle: TextStyle(color: const Color(0xFF9E9E9E), fontSize: 28.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                                                  border: InputBorder.none,
                                                ),
                                                onChanged: (value) {
                                                  try {
                                                    double input = double.tryParse(value) ?? 0.0;
                                                    setState(() {
                                                      _amountInFiat = input * priceQuotes;
                                                    });
                                                  } catch (e) {
                                                    logger("Error parsing amount: $e", runtimeType.toString());
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox();
                              },
                            ),
                          ],
                        ),
                        20.sp.verticalSpace,

                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            _amountInFiat > 0 ? '\$${MyCurrencyUtils.format(_amountInFiat, _selectedCoin.coinType == CoinType.TOKEN ? 2 : 6)}' : '',
                            style: TextStyle(color: const Color(0xFF515151), fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),

                  20.sp.verticalSpace,
                  // Recipients Address
                  Text(
                    'Recipients Address',
                    style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                  ),
                  10.sp.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 8,
                        child: AppTextfield(
                          controller: _addressController,
                          hintText: 'Enter your receiver\'s address',
                          maxLines: 1,
                          borderColor: _isAddressCorrect ? const Color(0xFF792A90) : const Color(0xFFE0E0E0),
                          radius: 25,
                          onChanged: _validateAddress,
                          filledColor: _isAddressCorrect ? Colors.transparent : const Color(0xffF5F5F5),
                          useFill: true,
                        ),
                      ),
                      10.horizontalSpace,
                      GestureDetector(
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
                    ],
                  ),
                  if (_isAddressCorrect) ...[
                    10.sp.verticalSpace,
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 6.sp),
                      decoration: BoxDecoration(color: const Color(0xFFF9E6FF), borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        'Address Correct',
                        style: TextStyle(color: const Color(0xFF792A90), fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                  Spacer(),
                  // 30.sp.verticalSpace,
                  AppButton(
                    text: 'Send Token',
                    textColor: Colors.white,
                    color: canSend ? const Color(0xFF792A90) : const Color(0xFFB5B5B5),
                    onTap: () async{
                      if (canSend) {
                       await send(context: context);
                      }
                    },
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

  Future<void> send({required BuildContext context}) async {
    // Implement the logic to send the token
    try {
      showOverlay(context);
      CoinBalance? balance;
      SupportedCoin asset = _selectedCoin;
      String input = _amountController.text.trim();
      double amount = double.parse(input);
      String address = _addressController.text.trim();
      if (asset.coinType == CoinType.TOKEN) {
        balance = balanceController.balances[asset.contractAddress!];
      } else {
        balance = balanceController.balances[asset.symbol];
      }
      if (balance == null) {
        showMySnackBar(context: context, message: "Unable to get balance", type: SnackBarType.error);
        hideOverlay(context);
        return;
      }

      if (balance.balanceInCrypto >= amount) {
      } else {
        showMySnackBar(context: context, message: "Insufficient balance", type: SnackBarType.error);
        hideOverlay(context);
        return;
      }
      sendPayload = SendPayload(amount: amount, asset: asset, amountInFiat: _amountInFiat, recipient_address: address);
      NetworkFee? fee;
      try {
        double? priceQuote = balanceController.priceQuotes[asset.symbol] ?? 0;
        fee = await TransactionService().getTxInfo(priceQuote: priceQuote, asset: asset, sendPayload: sendPayload!);
        sendPayload!.fee = fee;
        logger("Estimated fee: ${fee != null ? MyCurrencyUtils.format(fee.feeInFiat, 2) : "N/A"} USD", runtimeType.toString());
        // Proceed with sending the transaction using the sendPayload
      } catch (e) {
        showMySnackBar(context: context, message: "An error occurred when estimating gas, Please check the address and make sure you have good internet or enough gas fee", type: SnackBarType.error);
        hideOverlay(context);
        return;
      }
      hideOverlay(context);
      String? txId= await _showConfirmTransaction(context);
      if (txId != null) {
        _addressController.text = '';
        _amountController.text = '';
        _amountInFiat = 0;
        _recipientAddress = '';
        _isAddressCorrect = false;
        setState(() {});
      }
    } catch (e) {
      hideOverlay(context);
      showMySnackBar(context: context, message: "An error occurred", type: SnackBarType.error);
    }
  }
}
