import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/core/constants/sub_constants.dart';
import 'package:quanthex/data/Models/assets/network_model.dart';
import 'package:quanthex/data/Models/mining/mining_dto.dart';
import 'package:quanthex/data/Models/send/send_payload.dart';
import 'package:quanthex/data/Models/staking/staking_dto.dart';
import 'package:quanthex/data/Models/subscription/subscription_dto.dart';
import 'package:quanthex/data/controllers/assets/asset_controller.dart';
import 'package:quanthex/data/controllers/balance/balance_controller.dart';
import 'package:quanthex/data/controllers/mining/mining_controller.dart';
import 'package:quanthex/data/controllers/wallet_controller.dart';
import 'package:quanthex/data/services/assets/asset_service.dart';
import 'package:quanthex/data/services/mining/mining_service.dart';
import 'package:quanthex/data/utils/date_utils.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/data/utils/overlay_utils.dart';
import 'package:quanthex/data/utils/staking/staking_utils.dart';
import 'package:quanthex/data/utils/sub/sub_utils.dart';
import 'package:quanthex/views/home/components/coin_image.dart';
import 'package:quanthex/views/mining/components/subscription_success_modal.dart';
import 'package:quanthex/views/mining/mining_view.dart';
import 'package:quanthex/views/staking/components/staking_amount_item.dart';
import 'package:quanthex/views/staking/components/staking_card.dart';
import 'package:quanthex/views/staking/components/staking_success_modal.dart';
import 'package:quanthex/widgets/app_button.dart';
import 'package:quanthex/widgets/app_textfield.dart';
import 'package:quanthex/widgets/arrow_back.dart';
import 'package:quanthex/widgets/confirm_pin_modal.dart';
import 'package:web3dart/web3dart.dart';

import '../../core/constants/network_constants.dart';
import '../../data/Models/assets/supported_assets.dart';
import '../../data/Models/balance/CoinBalance.dart';
import '../../data/Models/mining/subscription_payload.dart';
import '../../data/Models/network/network_model.dart';
import '../../data/Models/staking/staking_payload.dart';
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

class SubscribeStakingView extends StatefulWidget {
  SubscribeStakingView({super.key, required this.payload, required this.paymentToken});

  StakingPayload payload;
  SupportedCoin paymentToken;

  @override
  State<SubscribeStakingView> createState() => _SubscribeStakingViewState();
}

class _SubscribeStakingViewState extends State<SubscribeStakingView> {
  double _paymentAmount = 0.0;
  late StakingPayload payload;
  SupportedCoin? rewardCoin;
  late BalanceController balanceController;
  late MiningController miningController;
  late AssetController assetController;
  late WalletController walletController;
  int _selectedDurationMonths = 6; // Default to 1 month
  final TextEditingController referralCode = TextEditingController();

  @override
  void initState() {
    balanceController = Provider.of<BalanceController>(context, listen: false);
    miningController = Provider.of<MiningController>(context, listen: false);
    assetController = Provider.of<AssetController>(context, listen: false);
    walletController = Provider.of<WalletController>(context, listen: false);
    payload = widget.payload;
    List<SupportedCoin> supportedCoins = assetController.assets.where((e) => e.symbol.toLowerCase() == "usdt" && e.networkModel!.chainId == 56).toList();
    if (supportedCoins.isEmpty) {
      showMySnackBar(context: context, message: "You don't have USDT on Bep20 to  stake, Please note that USDT is required for payment", type: SnackBarType.error);
      return;
    }
    rewardCoin = supportedCoins.first;
    // _paymentAmount= package_service.subPrice??20.0;
    _paymentAmount = 100;
    super.initState();
  }

  //
  Future<void> _showPaymentSuccessModal() async {
    print("object");
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StakingSuccessModal(
        token: widget.paymentToken,
        chain: widget.paymentToken.networkModel!,
        stake: payload,
        onDoneTap: () {
          Navigate.back(context);
          // this is for back to the mine screen (i returned to true as a key to indicate the guy is subscribed)
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canPay = rewardCoin != null;

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: ArrowBack(iconColor: Colors.white),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(8.sp),
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
                  return SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Text(
                          'Yield Token',
                          style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                        ),
                        10.sp.verticalSpace,
                        GestureDetector(
                          onTap: () async {
                            // SupportedCoin? result = await AssetUtils.selectRewardAssets(context: context);
                            // if(result!=null){
                            //   logger("Selected Coin: ${result.name}", runtimeType.toString());
                            //   setState(() {
                            //     rewardCoin=result;
                            //   });
                            // }
                          },
                          child: StakingCard(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 32.sp,
                                        height: 32.sp,
                                        decoration: BoxDecoration(color: greenColor.withOpacity(0.2), shape: BoxShape.circle),
                                        child: Icon(Icons.bolt, size: 20.sp, color: greenColor.withOpacity(0.3)),
                                      ),
                                      10.horizontalSpace,
                                      Expanded(
                                        child: Text(
                                          rewardCoin == null ? 'Yield Token N/A' : "${rewardCoin!.symbol} - (${rewardCoin!.networkModel!.chainSymbol.toUpperCase()})",
                                          style: TextStyle(color: rewardCoin == null ? const Color(0xFF9E9E9E) : Colors.white, fontSize: 16, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Icon(
                                //   Icons.keyboard_arrow_down,
                                //   size: 24.sp,
                                //   color: const Color(0xFF757575),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        20.sp.verticalSpace,
                        // Duration Selection
                        Text(
                          'Duration',
                          style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                        ),
                        10.sp.verticalSpace,
                        StakingCard(
                          child: DropdownButton<int>(
                            padding: EdgeInsets.zero,
                            value: _selectedDurationMonths,
                            isExpanded: true,
                            dropdownColor: Colors.black,
                            underline: const SizedBox(),
          
                            icon: Icon(Icons.keyboard_arrow_down, size: 24.sp, color: const Color(0xFF757575)),
                            style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                            items: [6, 12, 24].map((int months) {
                              return DropdownMenuItem<int>(
                                value: months,
                                child: Text(
                                  '$months ${months == 1 ? 'Month' : 'Months'}',
                                  style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                                ),
                              );
                            }).toList(),
                            onChanged: (int? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedDurationMonths = newValue;
                                });
                              }
                            },
                          ),
                        ),
                        10.sp.verticalSpace,
                        // Display End Date
                        StakingCard(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Staking End Date',
                                style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                              ),
                              Text(
                                MyDateUtils.dateToSingleFormatWithTime(_getEndDate(), false),
                                style: TextStyle(color: Colors.white60, fontSize: 14, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        10.verticalSpace,
                        Text(
                          'Select amount',
                          style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                        ),
                        10.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _paymentAmount = 100;
                                setState(() {});
                              },
                              child: StakingAmountItem(content: "\$100", borderColor: greenColor, bgColor:_paymentAmount==100?greenColor.withOpacity(0.7): greenColor.withOpacity(0.2), textColor: Colors.white),
                            ),
                             GestureDetector(
                              onTap: () {
                                _paymentAmount = 200;
                                setState(() {});
                              },
                              child: StakingAmountItem(content: "\$200", borderColor: greenColor, bgColor: _paymentAmount == 200 ? greenColor.withOpacity(0.7) : greenColor.withOpacity(0.2), textColor: Colors.white),
                            ),
                             GestureDetector(
                              onTap: () {
                                _paymentAmount = 500;
                                setState(() {});
                              },
                              child: StakingAmountItem(content: "\$500", borderColor: greenColor, bgColor: _paymentAmount == 500 ? greenColor.withOpacity(0.7) : greenColor.withOpacity(0.2), textColor: Colors.white),
                            ),
                             GestureDetector(
                              onTap: () {
                                _paymentAmount = 1000;
                                setState(() {});
                              },
                              child: StakingAmountItem(content: "\$1000", borderColor: greenColor, bgColor: _paymentAmount == 1000 ? greenColor.withOpacity(0.7) : greenColor.withOpacity(0.2), textColor: Colors.white),
                            ),
                            GestureDetector(
                              onTap: () {
                                _paymentAmount = 1500;
                                setState(() {});
                              },
                              child: StakingAmountItem(content: "\$1500", borderColor: greenColor, bgColor: _paymentAmount == 1500 ? greenColor.withOpacity(0.7) : greenColor.withOpacity(0.2), textColor: Colors.white),
                            ),                        ],
                        ),
                        10.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                             GestureDetector(
                              onTap: () {
                                _paymentAmount = 2000;
                                setState(() {});
                              },
                              child: StakingAmountItem(content: "\$2000", borderColor: greenColor, bgColor: _paymentAmount == 2000 ? greenColor.withOpacity(0.7) : greenColor.withOpacity(0.2), textColor: Colors.white),
                            ),
                            GestureDetector(
                              onTap: () {
                                _paymentAmount = 3000;
                                setState(() {});
                              },
                              child: StakingAmountItem(content: "\$3000", borderColor: greenColor, bgColor: _paymentAmount == 3000 ? greenColor.withOpacity(0.7) : greenColor.withOpacity(0.2), textColor: Colors.white),
                            ),
                             GestureDetector(
                              onTap: () {
                                _paymentAmount = 5000;
                                setState(() {});
                              },
                              child: StakingAmountItem(content: "\$5000", borderColor: greenColor, bgColor: _paymentAmount == 5000 ? greenColor.withOpacity(0.7) : greenColor.withOpacity(0.2), textColor: Colors.white),
                            ),
                          ],
                        ),
                        15.verticalSpace,
                        // From Section
                        StakingCard(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Payment Token',
                                    style: TextStyle(color: Colors.white, fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                                  ),
                                  balance != null
                                      ? Text(
                                          'Balance: ${!bCtr.hideBalance
                                              ? balance.balanceInCrypto != 0
                                                    ? "${MyCurrencyUtils.formatCurrency2(balance.balanceInCrypto)} ${pToken.symbol}"
                                                    : "0 ${pToken.symbol}"
                                              : "****"}',
                                          style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                              10.verticalSpace,
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
                                    child: StakingCard(
                                      child: Row(
                                        children: [
                                          CoinImage(imageUrl: widget.paymentToken.image, width: 32, height: 32.sp),
                                          10.horizontalSpace,
                                          Text(
                                            widget.paymentToken.symbol,
                                            style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                                          ),
                                          2.horizontalSpace,
                                          Text(
                                            "(${widget.paymentToken.networkModel!.chainSymbol})",
                                            style: TextStyle(color: Colors.white60, fontSize: 10, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                                          ),
                                          // Icon(Icons.keyboard_arrow_down, size: 24.sp, color: const Color(0xFF757575)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    '$_paymentAmount ${widget.paymentToken!.symbol}',
                                    style: TextStyle(color: Colors.white60, fontSize: 20, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        10.sp.verticalSpace,
                        Text(
                          'Referral Code',
                          style: TextStyle(color: Colors.white, fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                        ),
                        5.sp.verticalSpace,
                        AppTextfield(
                          filledColor: greenColor.withOpacity(0.1),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                          hintText: 'Enter referral code',
                          controller: referralCode,
                        ),
                        15.sp.verticalSpace,
                        // Package Details
                        Container(
                          padding: EdgeInsets.all(8.sp),
                          decoration: BoxDecoration(color: greenColor.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
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
                                    decoration: BoxDecoration(color: greenColor.withOpacity(0.3), shape: BoxShape.circle),
                                    child: Icon(Icons.bolt, color: Colors.white, size: 20.sp),
                                  ),
                                ),
                              ),
                              8.horizontalSpace,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Staking Package',
                                      style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                                    ),
                                    2.sp.verticalSpace,
                                    Text(
                                      'Can be withdrawn anytime',
                                      style: TextStyle(color: Colors.white60, fontSize: 14, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '100 USDT minimum',
                                style: TextStyle(color: Colors.white, fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                        // Total Reward Potential
                        20.sp.verticalSpace,
                        GestureDetector(
                          onTap: () async {
                            if (canPay) {
                              bool result = await SecurityUtils.showPinDialog(context: context);
                              if (result) {
                                pay(balance, rewardCoin!);
                              }
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 14.sp),
                            decoration: BoxDecoration(color: greenColor.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                            child: Center(
                              child: Text(
                                'Stake',
                                style: TextStyle(color: Colors.white, fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700, letterSpacing: 0.5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
    try {
      NetworkFee? fee;
      String refCode = referralCode.text.trim();
      if (refCode.isEmpty) {
        showMySnackBar(context: context, message: "Referral code is required", type: SnackBarType.error);
        return;
      }
      if (balance == null) {
        showMySnackBar(context: context, message: "Balance not available, Please try again later", type: SnackBarType.error);
        return;
      }
      if (balance.balanceInCrypto >= _paymentAmount) {
      } else {
        showMySnackBar(context: context, message: "Insufficient balance", type: SnackBarType.error);
        return;
      }
      String planName = StakingUtils().mapMonthsToPlanName(_paymentAmount);
      showOverlay(context);
      SupportedCoin asset = widget.paymentToken;
      double? priceQuote = balanceController.priceQuotes[asset.symbol] ?? 0;
      double _amountInFiat = _paymentAmount * (priceQuote ?? 0);
      String address = adminAddress;
      SendPayload sendPayload = SendPayload(amount: _paymentAmount, asset: asset, amountInFiat: _amountInFiat, recipient_address: address);
      try {
        fee = await TransactionService().getTxInfo(priceQuote: priceQuote, asset: asset, sendPayload: sendPayload!);
        sendPayload.fee = fee;
      } catch (e) {
        logger(e.toString(), runtimeType.toString());
        showMySnackBar(context: context, message: "An error occurred when estimating gas, Please check the address and make sure you have good internet or enough gas fee", type: SnackBarType.error);
        hideOverlay(context);
        return;
      }
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
        Uint8List signedTransaction;
        String txSigned;
        try {
          signedTransaction = await webClient.signTransaction(credentials, tx, chainId: chainId, fetchChainIdFromNetworkId: false);
          txSigned = bytesToHex(signedTransaction, include0x: true);
        } catch (e) {
          logger(e.toString(), runtimeType.toString());
          showMySnackBar(context: context, message: "An error occurred when signing transaction, Please check the address and make sure you have good internet or enough gas fee", type: SnackBarType.error);
          hideOverlay(context);
          return;
        }
        StakingPayload stake = payload;
        stake.stakedAssetSymbol = asset.symbol ?? "";
        stake.stakedAssetContract = asset.contractAddress ?? "";
        stake.stackedAssetDecimals = asset.decimal ?? 18;
        stake.stakedAssetName = asset.name ?? "";
        stake.stakedAssetImage = asset.image ?? "";
        stake.stakingRewardContract = rewardToken.contractAddress ?? "";
        stake.stakingRewardChainId = rewardToken.networkModel!.chainId ?? 56;
        stake.stakingRewardAssetName = rewardToken.name ?? "";
        stake.stakedAmountCrypto = _paymentAmount.toString();
        stake.stakedAmountFiat = _amountInFiat.toString();
        stake.signedTx = txSigned;
        stake.rpc = rpc;
        stake.duration = _selectedDurationMonths.toString();
        stake.endDate = _getEndDate().millisecondsSinceEpoch.toString();
        stake.startDate = DateTime.now().millisecondsSinceEpoch.toString();
        stake.stakingReferralCode = refCode;
        stake.stakingPlan = planName;
        StakingDto dto = await PackageService.getInstance().stake(stake: stake);
        String walletAddress = walletController.currentWallet!.walletAddress ?? "";
        List<StakingDto> stakings = await MiningService.getInstance().getStakings(walletAddress, active);
        miningController.setStakings(walletAddress, stakings);
        hideOverlay(context);
        await _showPaymentSuccessModal();
        Navigate.back(context, args: true);
      } else {
        String nativeCoin = sendPayload.asset!.networkModel!.chainCurrency;
        logger("Insufficient $nativeCoin for gas, top up your balance $nativeCoin to proceed", runtimeType.toString());
        hideOverlay(context);
        return;
      }
      // Proceed with sending the transaction using the sendPayload
    } catch (e) {
      logger(e.toString(), runtimeType.toString());
      hideOverlay(context);
      return;
    }
  }

  DateTime _getEndDate() {
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month + _selectedDurationMonths, now.day, now.hour, now.minute, now.second);
  }
}
