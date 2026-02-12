import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/core/constants/network_constants.dart';
import 'package:quanthex/data/Models/assets/supported_assets.dart';
import 'package:quanthex/data/Models/balance/CoinBalance.dart';
import 'package:quanthex/data/Models/network/network_model.dart';
import 'package:quanthex/data/Models/send/send_payload.dart';
import 'package:quanthex/data/Models/swap/model/coin_pair.dart';
import 'package:quanthex/data/controllers/assets/asset_controller.dart';
import 'package:quanthex/data/controllers/balance/balance_controller.dart';
import 'package:quanthex/data/controllers/home/home_controller.dart';
import 'package:quanthex/data/controllers/swap/swap_controller.dart';
import 'package:quanthex/data/controllers/wallet_controller.dart';
import 'package:quanthex/data/services/swap/swap_service.dart';
import 'package:quanthex/data/services/transaction/transaction_service.dart';
import 'package:quanthex/data/utils/gas_fee_check.dart';
import 'package:quanthex/data/utils/logger.dart';
import 'package:quanthex/data/utils/my_currency_utils.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/data/utils/overlay_utils.dart';
import 'package:quanthex/views/home/components/coin_image.dart';
import 'package:quanthex/views/swap/components/confirm_swap_modal.dart';
import 'package:quanthex/views/swap/components/swap_details.dart';
import 'package:quanthex/views/swap/components/swap_token_selector_modal.dart';
import 'package:quanthex/views/swap/helper/swap_helper.dart';
import 'package:quanthex/widgets/app_button.dart';
import 'package:quanthex/widgets/app_textfield.dart';
import 'package:quanthex/widgets/loading_overlay/loading.dart';
import 'package:quanthex/widgets/quanthex_image_banner.dart';
import 'package:quanthex/widgets/chain_selector_widget.dart';
import 'package:quanthex/data/Models/assets/network_model.dart';
import 'package:quanthex/widgets/snackbar/my_snackbar.dart';
import 'package:quanthex/views/swap/token_approval_bottom_sheet.dart';
import 'package:quanthex/views/swap/transaction_fee_bottom_sheet.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'dart:math' as math;

class SwapTokenView extends StatefulWidget {
  const SwapTokenView({super.key});

  @override
  State<SwapTokenView> createState() => _SwapTokenViewState();
}

class _SwapTokenViewState extends State<SwapTokenView> {
  final String _fromToken = 'ETH';
  String _toToken = '';
  bool isLoadingQuotes = false;
  Timer? _quotesRefreshTimer;
  final Duration _quotesRefreshInterval = Duration(seconds: 10);

  late SwapController swapController;
  late AssetController assetController;
  late WalletController walletController;
  late BalanceController balanceController;
  late HomeController homeController;
  ValueNotifier<SupportedCoin?> fromNotifier = ValueNotifier(null);
  ValueNotifier<SupportedCoin?> toNotifier = ValueNotifier(null);
  ValueNotifier<CoinPair?> coinPairNotifier = ValueNotifier(null);

  ValueNotifier<bool> errorNotifier = ValueNotifier(false);
  ValueNotifier<bool> poolLoadingNotifier = ValueNotifier(false);
  ValueNotifier<bool> dataLoadingNotifiers = ValueNotifier(true);

  final formKey = GlobalKey<FormState>();
  TextEditingController fromAmountController = TextEditingController(text: '0');
  TextEditingController toAmountController = TextEditingController(text: '0');
  NetworkModel? selectedChain;
  // Available chains
  List<NetworkModel> get availableChains => [chain_bsc, chain_polygon, chain_eth];
  FocusNode fromFocusNode = FocusNode();
  String _errorText = "";

  @override
  void initState() {
    super.initState();
    swapController = Provider.of<SwapController>(context, listen: false);
    assetController = Provider.of<AssetController>(context, listen: false);
    walletController = Provider.of<WalletController>(context, listen: false);
    balanceController = Provider.of<BalanceController>(context, listen: false);
    homeController = Provider.of<HomeController>(context, listen: false);
    // Set default chain
    selectedChain = chain_bsc;
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      getData(false);
      _startQuotesRefreshTimer();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _stopQuotesRefreshTimer();
    super.dispose();
  }
  void _stopQuotesRefreshTimer() {
    _quotesRefreshTimer?.cancel();
  }

  void _startQuotesRefreshTimer() {
    _quotesRefreshTimer?.cancel();
    _quotesRefreshTimer = Timer.periodic(_quotesRefreshInterval, (timer) async {
      if (!mounted) {
        return;
      }
      try {
        if (homeController.index == 1) {
          isLoadingQuotes = true;
          logger("Refreshing quotes", "SwapTokenView");

          setState(() {});
          await balanceController.getTokenQuotes(tokens: swapController.tokens);
          isLoadingQuotes = false;  setState(() {});
        } else {
          logger("Not in swap view, skipping quotes refresh", "SwapTokenView");
          isLoadingQuotes = false;
          setState(() {});
          }
        } catch (e) {
          isLoadingQuotes = false;
          setState(() {});
          logger(e.toString(), "SwapTokenView");
        }
      },
    );
  }

  void getData(bool showError) async {
    if (selectedChain == null) return;
    if (!mounted) {
      return;
    }
    String address = walletController.currentWallet?.walletAddress ?? "";
    String privateKey = walletController.currentWallet?.privateKey ?? "";

    if (address.isEmpty || privateKey.isEmpty) {
      return;
    }

    try {
      // Load tokens for the selected chain
      dataLoadingNotifiers.value = true;
      errorNotifier.value = false;
      await swapController.getTokens(network: selectedChain!, address: address, privateKey: privateKey);
      // Filter tokens from asset controller that match the selected chain
      List<SupportedCoin> chainTokens = assetController.assets.where((asset) => asset.networkModel?.chainId == selectedChain!.chainId).toList();

      // Combine swap controller tokens with asset controller tokens
      List<SupportedCoin> allTokens = [...swapController.tokens];

      // Add native token for the chain if not already present
      bool hasNativeToken = allTokens.any((token) => token.coinType == CoinType.NATIVE_TOKEN && token.networkModel?.chainId == selectedChain!.chainId);

      if (!hasNativeToken) {
        SupportedCoin nativeToken = SupportedCoin(
          name: selectedChain!.chainName,
          symbol: selectedChain!.chainCurrency.toUpperCase(),
          image: selectedChain!.imageUrl,
          walletAddress: address,
          privateKey: privateKey,
          networkModel: selectedChain!,
          coinType: CoinType.NATIVE_TOKEN,
          decimal: 18,
          contractAddress: "",
        );
        allTokens.insert(0, nativeToken);
      }

      // Add other tokens from asset controller that match the chain
      for (var token in chainTokens) {
        if (!allTokens.any((t) => t.contractAddress?.toLowerCase() == token.contractAddress?.toLowerCase() && t.networkModel?.chainId == token.networkModel?.chainId)) {
          allTokens.add(token);
        }
      }

      // Update swap controller tokens
      swapController.tokens = allTokens;

      // Set default from/to tokens if available
      if (allTokens.isNotEmpty) {
        fromNotifier.value = allTokens.first;
        if (allTokens.length > 1) {
          toNotifier.value = allTokens[2];
          await getRoute(context, showError);
        } else {
          toNotifier.value = null;
        }
      } else {
        fromNotifier.value = null;
        toNotifier.value = null;
      }
      dataLoadingNotifiers.value = false;
    } catch (e) {
      // Handle error - tokens might not be available for this chain
      fromNotifier.value = null;
      toNotifier.value = null;
      dataLoadingNotifiers.value = false;
      errorNotifier.value = true;
    }
  }

  void _showTokenSelector({required bool isFrom}) async {
    SupportedCoin? result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => SwapTokenSelectorModal(
        tokens: swapController.tokens,
        selectedChain: selectedChain,
        currentFromToken: fromNotifier.value,
        currentToToken: toNotifier.value,
        isFrom: isFrom,
        onTokenSelected: (token) async {
          if (isFrom) {
            fromNotifier.value = token;
            // If selected token is same as "to" token, clear "to"
            if (token.coinType != CoinType.NATIVE_TOKEN) {
              if (fromNotifier.value?.contractAddress?.toLowerCase() == toNotifier.value?.contractAddress?.toLowerCase() && toNotifier.value?.networkModel?.chainId == token.networkModel?.chainId) {
                toNotifier.value = null;
              } else {
                if (fromNotifier.value?.symbol.toLowerCase() == toNotifier.value?.symbol.toLowerCase() && toNotifier.value?.networkModel?.chainId == token.networkModel?.chainId) {
                  toNotifier.value = null;
                }
              }
            }
          } else {
            toNotifier.value = token;
            // If selected token is same as "from" token, clear "from"
            if (token.coinType != CoinType.NATIVE_TOKEN) {
              if (toNotifier.value?.contractAddress?.toLowerCase() == fromNotifier.value?.contractAddress?.toLowerCase() && fromNotifier.value?.networkModel?.chainId == token.networkModel?.chainId) {
                fromNotifier.value = null;
              }
            } else {
              if (toNotifier.value?.symbol.toLowerCase() == fromNotifier.value?.symbol.toLowerCase() && fromNotifier.value?.networkModel?.chainId == token.networkModel?.chainId) {
                fromNotifier.value = null;
              }
            }
          }
          Navigate.back(context, args: token);
        },
      ),
    );
    if (result != null) {
      await getRoute(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        fromFocusNode.unfocus();
      },
      child: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        padding: EdgeInsets.all(8.sp),
        child: RefreshIndicator(
          onRefresh: () async {
            getData(true);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ValueListenableBuilder(
              valueListenable: dataLoadingNotifiers,
              builder: (context, dataLoading, _) {
                return Skeletonizer(
                  ignoreContainers: false,
                  enabled: dataLoading,
                  effect: ShimmerEffect(duration: Duration(milliseconds: 1000), baseColor: Colors.grey.withOpacity(0.4), highlightColor: Colors.white54),

                  child: Column(
                    children: [
                      // Header
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Swap',
                                style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 20.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                              ),
                              const Spacer(),
                              QuanthexImageBanner(width: 110.sp, height: 60.sp),
                            ],
                          ),
                          // Chain Selector
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ChainSelectorModal(
                              networks: availableChains,
                              selectedNetwork: selectedChain,
                              onChainSelected: (network) {
                                setState(() {
                                  selectedChain = network;
                                  // Reset token selections when chain changes
                                  fromNotifier.value = null;
                                  toNotifier.value = null;
                                  fromAmountController.clear();
                                  toAmountController.clear();
                                });
                                // Reload tokens for the new chain
                                getData(true);
                              },
                              title: 'Select Chain',
                              showSearch: true,
                            ),
                          ),
                          10.sp.verticalSpace,
                        ],
                      ),
                      // Quanthex Image Banner
                      Form(
                        key: formKey,
                        onChanged: () {
                          if (formKey.currentState!.validate()) {
                            // calculate();
                          }
                        },
                        child: Column(
                          children: [
                            // From Section
                            Stack(
                              alignment: AlignmentGeometry.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: MediaQuery.sizeOf(context).width,
                                      height: 260.h,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: ValueListenableBuilder(
                                              valueListenable: fromNotifier,
                                              builder: (context, from, _) {
                                                return Consumer<BalanceController>(
                                                  builder: (context, bCtr, child) {
                                                    double? priceQuotes;
                                                    CoinBalance? fromBalance;
                                                    if (from != null) {
                                                      priceQuotes = bCtr.priceQuotes[from.symbol];
                                                      fromBalance = from.coinType == CoinType.TOKEN ? bCtr.balances[from.contractAddress!] : bCtr.balances[from.symbol];
                                                    } else {
                                                      fromBalance = null;
                                                      priceQuotes = null;
                                                    }
                                                    return Container(
                                                      padding: EdgeInsets.all(16.sp),
                                                      decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(16)),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'From',
                                                                style: TextStyle(color: const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                                                              ),
                                                              Spacer(),
                                                              Text(
                                                                '${fromBalance != null
                                                                    ? fromBalance.balanceInCrypto != 0
                                                                          ? MyCurrencyUtils.format(fromBalance.balanceInCrypto, from != null
                                                                                ? from.coinType == CoinType.TOKEN
                                                                                      ? 2
                                                                                      : 6
                                                                                : 6)
                                                                          : "0"
                                                                    : ""} ${from != null ? from.symbol : ""}',
                                                                style: TextStyle(color: const Color(0xFF757575), fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                                                              ),
                                                              8.horizontalSpace,
                                                              GestureDetector(
                                                                onTap: () {
                                                                  if (fromBalance == null) {
                                                                    return;
                                                                  }
                                                                  if (fromBalance.balanceInCrypto > 0) {
                                                                    fromAmountController.text = fromBalance.balanceInCrypto.toString().trim();
                                                                    String value = fromAmountController.text.trim();
                                                                    checkForError(value, fromBalance);
                                                                    calculate();
                                                                  }
                                                                },
                                                                child: Text(
                                                                  'Max',
                                                                  style: TextStyle(color: Color(0xFF792A90), fontSize: 13.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          10.sp.verticalSpace,
                                                          GestureDetector(
                                                            onTap: () {
                                                              _showTokenSelector(isFrom: true);
                                                            },
                                                            child: Row(
                                                              children: [
                                                                from != null ? CoinImage(imageUrl: from.image, height: 32.sp, width: 32.sp) : Container(height: 32.sp, width: 32.sp),
                                                                8.horizontalSpace,
                                                                Text(
                                                                  from != null ? from.symbol : "",
                                                                  style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                                                                ),
                                                                Icon(Icons.keyboard_arrow_down, size: 20.sp, color: const Color.fromRGBO(117, 117, 117, 1)),
                                                                Spacer(),
                                                                Container(
                                                                  width: 100.w,
                                                                  child: AppTextfield(
                                                                    focusNode: fromFocusNode,
                                                                    textAlign: TextAlign.right,
                                                                    controller: fromAmountController,
                                                                    hintText: '0',
                                                                    maxLines: 1,
                                                                    errorMaxLines: 1,
                                                                    hintStyle: TextStyle(color: const Color.fromRGBO(117, 117, 117, 1)),
                                                                    contentPadding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 0),
                                                                    border: InputBorder.none,
                                                                    keyboardType: TextInputType.number,
                                                                    onChanged: (val) {
                                                                      checkForError(val, fromBalance);
                                                                      CoinPair? pair = coinPairNotifier.value;
                                                                      if (pair != null) {
                                                                        if (val.isEmpty) {
                                                                          toAmountController.text = '';
                                                                          return;
                                                                        }
                                                                        try {
                                                                          double amount = double.tryParse(val) ?? 0;
                                                                          double receiverAmount = pair.token0Price * amount;
                                                                          toAmountController.text = receiverAmount.toString();
                                                                        } catch (e) {
                                                                          toAmountController.text = '';
                                                                        }
                                                                      }
                                                                    },
                                                                    onEditingComplete: () {
                                                                      calculate();
                                                                      fromFocusNode.unfocus();
                                                                    },
                                                                    onFieldSubmitted: (value) {
                                                                      calculate();
                                                                      fromFocusNode.unfocus();
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment: Alignment.centerRight,
                                                            child: Text(
                                                              _errorText,
                                                              style: TextStyle(color: Colors.red, fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                          10.sp.verticalSpace,
                                          Expanded(
                                            flex: 5,
                                            child: ValueListenableBuilder(
                                              valueListenable: toNotifier,
                                              builder: (context, to, _) {
                                                return Container(
                                                  padding: EdgeInsets.all(16.sp),
                                                  decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(16)),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'To',
                                                            style: TextStyle(color: const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                                                          ),
                                                          Spacer(),
                                                        ],
                                                      ),
                                                      10.sp.verticalSpace,
                                                      GestureDetector(
                                                        onTap: () {
                                                          _showTokenSelector(isFrom: false);
                                                        },
                                                        child: Row(
                                                          children: [
                                                            to != null ? CoinImage(imageUrl: to.image, height: 32.sp, width: 32.sp) : Container(height: 32.sp, width: 32.sp),
                                                            8.horizontalSpace,
                                                            Text(
                                                              to != null ? to.symbol : "",
                                                              style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                                                            ),
                                                            Icon(Icons.keyboard_arrow_down, size: 20.sp, color: const Color.fromRGBO(117, 117, 117, 1)),
                                                            Spacer(),
                                                            Container(
                                                              width: 100.w,
                                                              child: AppTextfield(
                                                                enable: false,
                                                                textAlign: TextAlign.right,
                                                                controller: toAmountController,
                                                                hintText: '',
                                                                maxLines: 1,
                                                                errorMaxLines: 1,
                                                                hintStyle: TextStyle(color: const Color.fromRGBO(117, 117, 117, 1)),
                                                                contentPadding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 0),
                                                                border: InputBorder.none,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                // Swap Direction Button
                                GestureDetector(
                                  onTap: () {
                                    swapDirection();
                                  },
                                  child: Container(
                                    width: 40.w,
                                    height: 40.h,
                                    padding: const EdgeInsets.all(3),
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFD9D9D9),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                                    ),
                                    child: Icon(Icons.swap_vert, size: 24.sp, color: const Color(0xFF2D2D2D)),
                                  ),
                                ),
                              ],
                            ),
                            10.sp.verticalSpace,
                            // Swap Details
                            ValueListenableBuilder(
                              valueListenable: errorNotifier,
                              builder: (context, isError, _) {
                                if (isError) {
                                  return GestureDetector(
                                    onTap: () {
                                      getRoute(context, true);
                                    },
                                    child: Text(
                                      'Unable to find a route, click to try again',
                                      style: TextStyle(color: Colors.red, fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                                    ),
                                  );
                                }
                                return ValueListenableBuilder(
                                  valueListenable: poolLoadingNotifier,
                                  builder: (context, poolLoading, _) {
                                    return ValueListenableBuilder(
                                      valueListenable: coinPairNotifier,
                                      builder: (context, coinPair, _) {
                                        if (coinPair == null && poolLoading == false) {
                                          return Text(
                                            'No route found, Change the pair',
                                            style: TextStyle(color: Colors.red, fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                                          );
                                        } else if (coinPair == null && poolLoading == true) {
                                          return Loading(size: 20.sp);
                                        } else {
                                          if (coinPair == null) {
                                            return const SizedBox();
                                          }
                                          return Skeletonizer(
                                            ignoreContainers: false,
                                            enabled: poolLoading,
                                            effect: ShimmerEffect(duration: Duration(milliseconds: 1000), baseColor: Colors.grey.withOpacity(0.4), highlightColor: Colors.white54),
                                            child: Builder(
                                              builder: (context) {
                                                String token0Symbol = coinPair.token0.symbol;
                                                String token1Symbol = coinPair.token1.symbol;
                                                String token0Price = coinPair.token0Price.toString();
                                                String token1Price = coinPair.token1Price.toString();
                                                String swapRate = '1 $token0Symbol = ${MyCurrencyUtils.format(double.parse(token0Price), coinPair.token1.coinType == CoinType.TOKEN ? 6 : 6)} $token1Symbol';
                                                String estimatedReceive = toAmountController.text.trim().isEmpty ? '0.00' : toAmountController.text.trim();
                                                return isLoadingQuotes ? Loading(size: 20.sp) : Column(
                                                  children: [
                                                    SwapDetails(label: 'Swap Rate', value: swapRate),
                                                    // Divider(height: 20.sp),
                                                    15.sp.verticalSpace,
                                                    SwapDetails(label: 'Min Receive', value: '${MyCurrencyUtils.format(double.parse(estimatedReceive), coinPair.token1.coinType == CoinType.TOKEN ? 2 : 6)} $token1Symbol'),
                                                    // Divider(height: 20.sp),
                                                    15.sp.verticalSpace,
                                                    // Row(
                                                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    //   children: [
                                                    //     Text(
                                                    //       'Route',
                                                    //       style: TextStyle(color: const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                                                    //     ),
                                                    //     Row(
                                                    //       children: [
                                                    //         // Container(
                                                    //         //   width: 24.sp,
                                                    //         //   height: 24.sp,
                                                    //         //   decoration: BoxDecoration(
                                                    //         //     color: Colors.blue,
                                                    //         //     shape: BoxShape.circle,
                                                    //         //   ),
                                                    //         //   child: Center(
                                                    //         //     child: Text(
                                                    //         //       'T',
                                                    //         //       style: TextStyle(
                                                    //         //         color: Colors.white,
                                                    //         //         fontSize: 12.sp,
                                                    //         //         fontFamily: 'Satoshi',
                                                    //         //         fontWeight: FontWeight.w700,
                                                    //         //       ),
                                                    //         //     ),
                                                    //         //   ),
                                                    //         // ),
                                                    //         Container(
                                                    //           width: 21.sp,
                                                    //           height: 21.sp,
                                                    //           decoration: ShapeDecoration(
                                                    //             image: DecorationImage(image: AssetImage("assets/images/transit_icon.png"), fit: BoxFit.cover),
                                                    //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                                    //           ),
                                                    //         ),
                                                    //         8.horizontalSpace,
                                                    //         Text(
                                                    //           'Transit',
                                                    //           style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                                                    //         ),
                                                    //       ],
                                                    //     ),
                                                    //   ],
                                                    // ),
                                                    30.sp.verticalSpace,
                                                    !poolLoading
                                                        ? AppButton(
                                                            text: 'Swap',
                                                            textColor: Colors.white,
                                                            color: const Color(0xFF792A90),
                                                            onTap: () async {
                                                              if (formKey.currentState!.validate()) {
                                                                  if (toAmountController.text.trim().isEmpty) {
                                                                    showMySnackBar(context: context, message: 'Please enter an amount', type: SnackBarType.error);
                                                                    return;
                                                                  }
                                                                  String walletAddress = walletController.currentWallet?.walletAddress ?? "";
                                                                  String inputAmount = fromAmountController.text.trim();
                                                                  String outputAmount = toAmountController.text.trim();
                                                                  String privateKey = walletController.currentWallet?.privateKey ?? "";
                                                                  await SwapHelper.startSwap(
                                                                    context: context,
                                                                    coinPair: coinPair,
                                                                    walletAddress: walletAddress,
                                                                    privateKey: privateKey,
                                                                    inputAmount: inputAmount,
                                                                    outputAmount: outputAmount,
                                                                    selectedChain: selectedChain!,
                                                                    onDone: () {
                                                                      clear();
                                                                    },
                                                                  );
                                                                  hideOverlay(context);
                                                                
                                                              }
                                                            },
                                                          )
                                                        : const SizedBox(),
                                                    20.sp.verticalSpace,
                                                  ],
                                                );
                                              },
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ],
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
    );
  }

  bool checkForError(String value, CoinBalance? fromBalance) {
    if (value.isEmpty) {
      _errorText = 'Amount is required';
      setState(() {});
      return false;
    }
    if (double.tryParse(value) == null) {
      _errorText = 'Invalid amount';
      setState(() {});
      return false;
    }
    if (double.tryParse(value)! < 0) {
      _errorText = 'Amount must be greater than 0';
      setState(() {});
      return false;
    }
    if (double.tryParse(value)! > fromBalance!.balanceInCrypto) {
      _errorText = 'Insufficient balance';
      setState(() {});
      return false;
    }
    _errorText = '';
    setState(() {});
    return true;
  }

  Future<void> getRoute(BuildContext context, bool showError) async {
    try {
      logger("Getting route for ${fromNotifier.value?.symbol} and ${toNotifier.value?.symbol}", "SwapTokenView");
      poolLoadingNotifier.value = true;
      errorNotifier.value = false;
      SupportedCoin? token0 = fromNotifier.value;
      SupportedCoin? token1 = toNotifier.value;
      if (token0 == null || token1 == null) {
        return;
      }
      CoinPair? coinPair;
      if (token0.coinType == CoinType.TOKEN && token1.coinType == CoinType.TOKEN) {
        coinPair = await swapController.getPool(chainSymbol: selectedChain!.chainSymbol, token0: token0, token1: token1);
        if (coinPair == null) {
          if (showError) {
            showMySnackBar(context: context, message: 'Pool not found, no route found for this pair', type: SnackBarType.error);
          }
          return;
        }
        poolLoadingNotifier.value = false;
      } else if (token0.coinType == CoinType.TOKEN && token1.coinType == CoinType.NATIVE_TOKEN) {
        String wethContractAddress = SwapService.getInstance().getWETHContractAddress(chainId: selectedChain!.chainId);
        logger("Weth contract address: $wethContractAddress", "SwapTokenView");
        List<SupportedCoin> wethTokens = assetController.assets.where((element) => element.contractAddress?.toLowerCase() == wethContractAddress.toLowerCase()).toList();
        if (wethTokens.isNotEmpty) {
          SupportedCoin wethToken = wethTokens.first;
          coinPair = await swapController.getPool(chainSymbol: selectedChain!.chainSymbol, token0: token0, token1: wethToken);
          //This is because the token1 is the native token and we need to set it to the coinPair so the UI shows the correct token
          coinPair?.token1 = token1;
          coinPair?.weth = wethToken;
          logger("Weth token: ${coinPair?.weth?.symbol}", "SwapTokenView");
        } else {
          coinPair = null;
        }
        poolLoadingNotifier.value = false;
      } else if (token0.coinType == CoinType.NATIVE_TOKEN && token1.coinType == CoinType.TOKEN) {
        String wethContractAddress = SwapService.getInstance().getWETHContractAddress(chainId: selectedChain!.chainId);
        logger("Weth contract address: $wethContractAddress", "SwapTokenView");
        List<SupportedCoin> wethTokens = assetController.assets.where((element) => element.contractAddress?.toLowerCase() == wethContractAddress.toLowerCase()).toList();
        if (wethTokens.isNotEmpty) {
          SupportedCoin wethToken = wethTokens.first;
          coinPair = await swapController.getPool(chainSymbol: selectedChain!.chainSymbol, token0: wethToken, token1: token1);
          if (coinPair == null) {
            poolLoadingNotifier.value = false;
            coinPairNotifier.value = null;
            if (showError) {
              showMySnackBar(context: context, message: 'Pool not found, no route found for this pair', type: SnackBarType.error);
            }
            return;
          }
          coinPair?.token0 = token0;
          coinPair?.token1 = token1;
          coinPair?.weth = wethToken;
          logger("Weth token: ${coinPair?.weth?.symbol}", "SwapTokenView");
        } else {
          coinPair = null;
        }
        poolLoadingNotifier.value = false;
      } else {}
      coinPairNotifier.value = coinPair;
      poolLoadingNotifier.value = false;
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        poolLoadingNotifier.value = false;
        errorNotifier.value = true;
        coinPairNotifier.value = null;
        if (showError) {
          showMySnackBar(context: context, message: 'Unable to get route', type: SnackBarType.error);
        }
      });

      logger(e.toString(), "SwapTokenView");
    }
  }

  Future<void> calculate() async {
    try {
      if (fromAmountController.text.trim().isEmpty) {
        return;
      }
      logger("Calculating...", "SwapTokenView");
      poolLoadingNotifier.value = true;
      double amount = double.parse(fromAmountController.text.trim());
      CoinPair? pair = coinPairNotifier.value;
      if (pair != null) {
        double receiverAmount = pair.token0Price * amount;
        toAmountController.text = receiverAmount.toString();
      }

      poolLoadingNotifier.value = false;
    } catch (e) {
      logger(e.toString(), "SwapTokenView");
      poolLoadingNotifier.value = false;
    }
  }

  void swapDirection() {
    SupportedCoin? temp = fromNotifier.value;
    fromNotifier.value = toNotifier.value;
    toNotifier.value = temp;
    getRoute(context, true);
    calculate();
  }

  void clear() {
    fromAmountController.text = '';
    toAmountController.text = '';
    poolLoadingNotifier.value = false;
  }
}
