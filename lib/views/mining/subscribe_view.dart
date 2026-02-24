import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/core/constants/sub_constants.dart';
import 'package:quanthex/data/Models/assets/network_model.dart';
import 'package:quanthex/data/Models/mining/mining_dto.dart';
import 'package:quanthex/data/Models/send/send_payload.dart';
import 'package:quanthex/data/Models/subscription/subscription_dto.dart';
import 'package:quanthex/data/controllers/balance/balance_controller.dart';
import 'package:quanthex/data/controllers/mining/mining_controller.dart';
import 'package:quanthex/data/controllers/wallet_controller.dart';
import 'package:quanthex/data/services/assets/asset_service.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/data/utils/overlay_utils.dart';
import 'package:quanthex/data/utils/sub/sub_utils.dart';
import 'package:quanthex/views/home/components/coin_image.dart';
import 'package:quanthex/views/mining/components/subscription_success_modal.dart';
import 'package:quanthex/views/mining/mining_view.dart';
import 'package:quanthex/widgets/app_button.dart';
import 'package:quanthex/widgets/app_textfield.dart';
import 'package:quanthex/widgets/confirm_pin_modal.dart';
import 'package:web3dart/web3dart.dart';

import '../../core/constants/network_constants.dart';
import '../../data/Models/assets/supported_assets.dart';
import '../../data/Models/balance/CoinBalance.dart';
import '../../data/Models/mining/subscription_payload.dart';
import '../../data/Models/network/network_model.dart';
import '../../data/services/package_service/package_service.dart';
import '../../data/services/transaction/transaction_service.dart';
import '../../data/utils/assets/asset_utils.dart';
import '../../data/utils/assets/client_resolver.dart';
import '../../data/utils/assets/token_factory.dart';
import '../../data/utils/logger.dart';
import '../../data/utils/my_currency_utils.dart';
import '../../data/utils/network/gas_fee_check.dart';
import '../../data/utils/security_utils.dart';
import '../../widgets/snackbar/my_snackbar.dart';
import 'dart:math' as math;

class SubscribeView extends StatefulWidget {
  SubscribeView({super.key, required this.payload, required this.paymentToken});

  SubscriptionPayload payload;
  SupportedCoin paymentToken;

  @override
  State<SubscribeView> createState() => _SubscribeViewState();
}

class _SubscribeViewState extends State<SubscribeView> {
  double _paymentAmount = 0.0;
  double totalRewardPotential = 0.0;
  late SubscriptionPayload payload;
  SupportedCoin? rewardCoin;
  late BalanceController balanceController;
  late MiningController miningController;
  late WalletController walletController;
  final TextEditingController referralCode = TextEditingController();

  @override
  void initState() {
    balanceController = Provider.of<BalanceController>(context, listen: false);
    miningController = Provider.of<MiningController>(context, listen: false);
    walletController = Provider.of<WalletController>(context, listen: false);
    payload = widget.payload;

    _paymentAmount = widget.payload.subPrice?.toDouble() ?? 0.0;
    totalRewardPotential = SubUtils.calculateRewardPotential(payload.subPackageName ?? "");
    super.initState();
  }

  Future<void> _showPaymentSuccessModal() async {
    print("object");
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SubscriptionSuccessModal(
        token: widget.paymentToken,
        chain: widget.paymentToken.networkModel!,
        sub: payload,
        onDoneTap: () {
          Navigate.back(context, args: true);

          // this is for back to the mine screen (i returned to true as a key to indicate the guy is subscribed)
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canPay = rewardCoin != null;
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
         appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigate.back(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.sp),
        ),
        title: Text(
          'Subscribe',
          style: TextStyle(color: Colors.white, fontSize: 18.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
        ),
      ),
      body: Container(
         padding: EdgeInsets.symmetric(horizontal: 16.sp),
         height: MediaQuery.of(context).size.height,
         width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken), image: AssetImage('assets/images/green_astro_bg.jpg'), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Consumer<BalanceController>(
                builder: (context, bCtr, _) {
                  SupportedCoin pToken = widget.paymentToken;
                  double? priceQuotes = bCtr.priceQuotes[pToken.symbol];
                  CoinBalance? balance = pToken.coinType == CoinType.TOKEN ? bCtr.balances[pToken.contractAddress!] : bCtr.balances[pToken.symbol];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Yield Token',
                        style: TextStyle(color: Colors.white70, fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                      ),
                      10.sp.verticalSpace,
                      GestureDetector(
                        onTap: () async {
                          SupportedCoin? result = await AssetUtils.selectRewardAssets(context: context);
                          if (result != null) {
                            logger("Selected Coin: ${result.name}", runtimeType.toString());
                            setState(() {
                              rewardCoin = result;
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(16.sp),
                          decoration: BoxDecoration(
                            color: rewardCoin == null ? greenColor.withOpacity(0.2) : Colors.transparent,
                            borderRadius: BorderRadius.circular(35),
                            border: Border.all(color: rewardCoin == null ? Colors.white70 : greenColor.withOpacity(0.2), width: 1),
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
                                      decoration: BoxDecoration(color: const Color(0xFF792A90).withOpacity(0.2), shape: BoxShape.circle),
                                      child: Icon(Icons.bolt, size: 20.sp, color: const Color(0xFF792A90)),
                                    ),
                                    10.horizontalSpace,
                                    Expanded(
                                      child: Text(
                                        rewardCoin == null ? 'Choose your preferred payout currency' : "${rewardCoin!.symbol} - (${rewardCoin!.networkModel!.chainSymbol.toUpperCase()})",
                                        style: TextStyle(color: Colors.white, fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.keyboard_arrow_down, size: 24.sp, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                      20.sp.verticalSpace,
        
                      // From Section
                      Container(
                        padding: EdgeInsets.all(16.sp),
                        decoration: BoxDecoration(
                          border: Border.all(color: greenColor.withOpacity(0.2)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Payment Token',
                                  style: TextStyle(color: Colors.white70, fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                                ),
                                balance != null
                                    ? Text(
                                        'Balance: ${!bCtr.hideBalance
                                            ? balance.balanceInCrypto != 0
                                                  ? "${MyCurrencyUtils.format(balance.balanceInCrypto, pToken.coinType == CoinType.TOKEN ? 2 : 6) ?? ""} ${pToken.symbol}"
                                                  : "0 ${pToken.symbol}"
                                            : "****"}',
                                        style: TextStyle(color: Colors.white70, fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                            10.sp.verticalSpace,
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    // SupportedCoin? coin = await AssetUtils.selectAssets(context: context);
                                    // if(coin!=null){
                                    //   logger("Selected Coin: ${coin.name}", runtimeType.toString());
                                    //
                                    // }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: greenColor.withOpacity(0.2)),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: Row(
                                      children: [
                                        CoinImage(imageUrl: widget.paymentToken.image, width: 32.sp, height: 32.sp),
                                        10.horizontalSpace,
                                        Text(
                                          widget.paymentToken.symbol,
                                          style: TextStyle(color: Colors.white, fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                                        ),
                                        2.horizontalSpace,
                                        Text(
                                          "(${widget.paymentToken.networkModel!.chainSymbol})",
                                          style: TextStyle(color: Colors.white70, fontSize: 10.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                                        ),
                                        Icon(Icons.keyboard_arrow_down, size: 24.sp, color: const Color(0xFF757575)),
                                      ],
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  '$_paymentAmount ${widget.paymentToken.symbol}',
                                  style: TextStyle(color: Colors.white, fontSize: 20.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      10.sp.verticalSpace,
                      Text(
                        'Referral Code',
                        style: TextStyle(color: const Color(0xFF333333), fontSize: 14, fontFamily: 'Satoshi', fontWeight: FontWeight.w700, height: 1.57, letterSpacing: -0.41),
                      ),
                      5.sp.verticalSpace,
                      AppTextfield(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: greenColor.withOpacity(0.2)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        hintText: 'Enter referral code',
                        filled: true,
                        filledColor: greenColor.withOpacity(0.2),

                         controller: referralCode
                         ),
                      20.sp.verticalSpace, // Package Details
                      Container(
                        padding: EdgeInsets.all(16.sp),
                        decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(16), border: Border.all(color: greenColor.withOpacity(0.2))),
                        child: Row(
                          children: [
                            Container(
                              width: 48.sp,
                              height: 48.sp,
                              decoration: BoxDecoration(color: greenColor.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                              child: Center(
                                child: Container(
                                  width: 24.sp,
                                  height: 24.sp,
                                  decoration: BoxDecoration(color: greenColor, shape: BoxShape.circle),
                                  child: Icon(Icons.bolt, color: Colors.white, size: 20.sp),
                                ),
                              ),
                            ),
                            15.horizontalSpace,
                            Expanded(
                              child: Text(
                                payload.subPackageName ?? "",
                                style: TextStyle(color: Colors.white, fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                              ),
                            ),
                            // Expanded(
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Text(
                            //         _package['name'] ?? 'Starter Mining Package',
                            //         style: TextStyle(
                            //           color: const Color(0xFF2D2D2D),
                            //           fontSize: 16.sp,
                            //           fontFamily: 'Satoshi',
                            //           fontWeight: FontWeight.w700,
                            //         ),
                            //       ),
                            //       5.sp.verticalSpace,
                            //       Text(
                            //         _package['duration'] ?? '365 Days',
                            //         style: TextStyle(
                            //           color: const Color(0xFF757575),
                            //           fontSize: 14.sp,
                            //           fontFamily: 'Satoshi',
                            //           fontWeight: FontWeight.w400,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            5.sp.horizontalSpace,
                            Text(
                              '$_paymentAmount ${widget.paymentToken.symbol}',
                              style: TextStyle(color: greenColor, fontSize: 18.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      20.sp.verticalSpace,
                      // Total Reward Potential
                      rewardCoin != null
                          ? Builder(
                              builder: (context) {
                                double? priceQuote = balanceController.priceQuotes[rewardCoin!.symbol] ?? 0;
                                double? estimatedOutput = totalRewardPotential / priceQuote;
                                logger("Estimated Output: $estimatedOutput", runtimeType.toString());
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Estimated Mining Output:',
                                      style: TextStyle(color: const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      '${estimatedOutput.toStringAsFixed(0)} ${rewardCoin!.symbol}',
                                      style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 18.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                );
                              },
                            )
                          : const SizedBox(),
                      40.sp.verticalSpace,
                      AppButton(
                        text: 'Pay Now',
                        textColor: Colors.white,
                        color: canPay ? greenColor : Colors.grey.withOpacity(0.5),
                        onTap: () async {
                          if (canPay) {
                            String refCode = referralCode.text.trim();
                            if (refCode.isEmpty) {
                              showMySnackBar(context: context, message: "Referral code is required", type: SnackBarType.error);
                              return;
                            }
                            bool result = await SecurityUtils.showPinDialog(context: context);
                            if (result) {
                              pay(balance, rewardCoin!);
                            }
                          }
                        },
                      ),
                      20.sp.verticalSpace,
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pay(CoinBalance? balance, SupportedCoin rewardToken) async {
    NetworkFee? fee;
    String refCode = referralCode.text.trim();
    String walletAddress = walletController.currentWallet!.walletAddress ?? "";
    try {
      if (balance == null) {
        showMySnackBar(context: context, message: "Balance not available, Please try again later", type: SnackBarType.error);
        return;
      }
      if (balance.balanceInCrypto >= _paymentAmount) {
      } else {
        showMySnackBar(context: context, message: "Insufficient balance", type: SnackBarType.error);
        return;
      }
      showOverlay(context);
      SupportedCoin asset = widget.paymentToken;
      double? priceQuote = balanceController.priceQuotes[asset.symbol] ?? 0;
      double _amountInFiat = _paymentAmount * (priceQuote ?? 0);
      String address = adminAddress;
      SendPayload sendPayload = SendPayload(amount: _paymentAmount, asset: asset, amountInFiat: _amountInFiat, recipient_address: address);
      fee = await TransactionService().getTxInfo(priceQuote: priceQuote, asset: asset, sendPayload: sendPayload!);
      sendPayload.fee = fee;
      if (fee == null) {
        showMySnackBar(context: context, message: "Unable to estimate transaction, Ensure you have enough gas fee for this transaction", type: SnackBarType.error);
        hideOverlay(context);
        return;
      }
      logger("Estimated fee: ${fee != null ? MyCurrencyUtils.format(fee.feeInFiat, 2) : "N/A"} USD", runtimeType.toString());
      NetworkModel network = widget.paymentToken.networkModel!;
      int decimal = asset.decimal!;
      bool isGas = GasFeeCheck.gasFeeCheck(bCtr: balanceController, feeInCrypto: fee.feeInCrypto, chainCurrency: network.chainCurrency);
      if (isGas) {
        double totalAmount = ((_paymentAmount) * math.pow(10, decimal));
        logger("Total amount: $totalAmount", runtimeType.toString());
        Transaction tx = await TransactionService().getTransferTx(context, sendPayload);
        String rpc = network.rpcUrl;
        int chainId = network.chainId;
        Web3Client webClient = await ClientResolver.resolveClient(rpcUrl: rpc);
        String privateKey = asset.privateKey!;
        final credentials = await TokenFactory().getCredentials(privateKey);
        Uint8List signedTransaction = await webClient.signTransaction(credentials, tx, chainId: chainId, fetchChainIdFromNetworkId: false);
        String txSigned = bytesToHex(signedTransaction, include0x: true);
        payload.subReferralCode = refCode;
        SubscriptionDto dto = await PackageService.getInstance().makeSubscription(sub: payload, paymentToken: asset, rewardToken: rewardToken, signedTx: txSigned, rpc: rpc);
        List<MiningDto> minings = await miningController.miningService.getMinings(walletAddress);
        miningController.setMinings(walletAddress, minings);
        hideOverlay(context);
        await _showPaymentSuccessModal();
        Navigate.back(context, args: true);
      } else {
        String nativeCoin = sendPayload.asset!.networkModel!.chainCurrency;
        logger("Insufficient $nativeCoin for gas, top up your balance $nativeCoin to proceed", runtimeType.toString());
        showMySnackBar(context: context, message: "Insufficient $nativeCoin for gas, top up your balance $nativeCoin to proceed", type: SnackBarType.error);
        hideOverlay(context);
        return;
      }
      // Proceed with sending the transaction using the sendPayload
    } catch (e) {
      logger(e.toString(), runtimeType.toString());
      showMySnackBar(context: context, message: e.toString().replaceAll("Exception: ", ""), type: SnackBarType.error);
      hideOverlay(context);
      return;
    }
  }
}
