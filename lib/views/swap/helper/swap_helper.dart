import 'package:flutter/material.dart';
import 'package:quanthex/core/constants/network_constants.dart';
import 'package:quanthex/data/Models/assets/network_model.dart';
import 'package:quanthex/data/Models/network/network_model.dart';
import 'package:quanthex/data/Models/swap/model/coin_pair.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/data/utils/overlay_utils.dart';
import 'package:quanthex/views/swap/token_approval_bottom_sheet.dart';
import 'package:quanthex/views/swap/transaction_fee_bottom_sheet.dart';
import 'package:quanthex/data/services/swap/swap_service.dart';
import 'package:quanthex/data/services/transaction/transaction_service.dart';
import 'package:quanthex/data/utils/logger.dart';
import 'package:quanthex/data/utils/network/gas_fee_check.dart';
import 'package:quanthex/widgets/snackbar/my_snackbar.dart';
import 'dart:math' as math;

import '../../../data/Models/assets/network_model.dart';
import '../../../data/Models/network/network_model.dart';
import '../../../data/Models/swap/model/coin_pair.dart';
import '../../../data/utils/navigator.dart';
import '../token_approval_bottom_sheet.dart';
import '../transaction_fee_bottom_sheet.dart';
import '../../../data/controllers/balance/balance_controller.dart';
import 'package:provider/provider.dart';

class SwapHelper {
  static Future<String?> showTokenApprovalBottomSheet({
    required BuildContext context,
    required String title,
    required String spenderAddress,
    required String spenderName,
    required String actionButtonText,
    required bool showCloseButton,
    required double approvalAmount,
    required bool isUnlimited,
    required NetworkFee networkFee,
    required CoinPair coinPair,
    required String inputAmount,
  }) async {
    String? txId = await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => TokenApprovalBottomSheet(
        title: title,
        token: coinPair.token0,
        networkFee: networkFee,
        spenderAddress: spenderAddress,
        spenderName: spenderName,
        actionButtonText: actionButtonText,
        showCloseButton: true,
        approvalAmount: double.parse(inputAmount),
        isUnlimited: isUnlimited,
        onDismiss: () {
          Navigate.back(context);
        },
      ),
    );
    return txId;
  }

  static Future<bool?> showTransactionFeeBottomSheet({required BuildContext context, required String title, required NetworkFee networkFee, required String networkSymbol, required String actionButtonText, required CoinPair coinPair, required String chainSymbol}) async {
    return await showModalBottomSheet<bool?>(
      context: context,
      builder: (context) => TransactionFeeBottomSheet(title: title, networkFee: networkFee, networkSymbol: networkSymbol, actionButtonText: actionButtonText),
    );
  }

  static Future<void> startSwap({required BuildContext context, required CoinPair coinPair, required walletAddress, required String privateKey, required String inputAmount, required String outputAmount, required NetworkModel selectedChain, required Function onDone}) async {
    showOverlay(context);
    BalanceController balanceController = Provider.of<BalanceController>(context, listen: false);
    String chainSymbol = selectedChain.chainSymbol;
    String spender = SwapService.getInstance().getUniswapSwapRouterAddress(chainId: selectedChain!.chainId);
    double slippage = 0.1;
    double amountOutMinDouble = double.parse(outputAmount) * (1 - slippage);
    BigInt amountIn = BigInt.from(double.parse(inputAmount) * math.pow(10, coinPair.token0.decimal!));
    BigInt amountOutMin = BigInt.from(double.parse(amountOutMinDouble.toString()) * math.pow(10, coinPair.token1.decimal!));
    String contractAddress = coinPair.token0.contractAddress ?? "";
    String rpcUrl = selectedChain.rpcUrl ?? "";
    BigInt poolFee = BigInt.from(coinPair.fee);
    logger("Amount in: $amountIn", "SwapTokenView");
    logger("Amount out min: $amountOutMin", "SwapTokenView");
    logger("Pool fee: $poolFee", "SwapTokenView");
    double? priceQuote = balanceController.priceQuotes[coinPair.token0.symbol] ?? 0;
    BigInt gasFee = BigInt.zero;
    try {
      gasFee = await TransactionService().getChainNetworkFee(rpcUrl: rpcUrl, chainId: selectedChain!.chainId);
    } catch (e) {
      logger(e.toString(), "SwapTokenView");
      hideOverlay(context);
      showMySnackBar(context: context, message: "An error occurred while getting network fee", type: SnackBarType.error);
      return;
    }
    if (coinPair.token0.coinType == CoinType.TOKEN && coinPair.token1.coinType == CoinType.TOKEN) {
      logger("Token to Token Swap", "SwapTokenView");
      // double amountInFiat = double.parse(inputAmount) * priceQuote;
      BigInt approveGas = BigInt.zero;
      NetworkFee? approveFee = null;
      try {
        approveGas = await SwapService.getInstance().estimateApprove2Tx(privateKey: privateKey, spender: spender, amountIn: amountIn, contractAddress: contractAddress, rpcUrl: rpcUrl);
        approveFee = await TransactionService().calcNetworkFee(gas: approveGas, gasPrice: gasFee, currentPrice: priceQuote, chainCurrency: selectedChain!.chainCurrency, from: coinPair.token0);
      } catch (e) {
        logger(e.toString(), "SwapTokenView");
        hideOverlay(context);
        showMySnackBar(context: context, message: "Unable to estimate approval transaction, Ensure you have enough gas fee for this transaction and try again", type: SnackBarType.error);
        return;
      }
      hideOverlay(context);
      String? txId = await SwapHelper.showTokenApprovalBottomSheet(
        context: context,
        title: "Approve ${coinPair.token0.symbol} for Swap",
        coinPair: coinPair,
        spenderAddress: spender,
        spenderName: "Uniswap",
        actionButtonText: "Approve",
        showCloseButton: true,
        approvalAmount: double.parse(inputAmount),
        isUnlimited: false,
        networkFee: approveFee,
        inputAmount: inputAmount,
      );
      if (txId != null) {
        showOverlay(context);
        BigInt tokenToTokenSwapGas = BigInt.zero;
        NetworkFee? swapFee = null;
        try {
          tokenToTokenSwapGas = await SwapService.getInstance().estimateSwapTx(pair: coinPair, privateKey: privateKey, fromAddress: walletAddress, amountIn: amountIn, rpcUrl: rpcUrl, poolFee: poolFee);
          swapFee = await TransactionService().calcNetworkFee(gas: tokenToTokenSwapGas, gasPrice: gasFee, currentPrice: priceQuote, chainCurrency: selectedChain!.chainCurrency, from: coinPair.token0);
        } catch (e) {
          logger(e.toString(), "SwapTokenView");
          hideOverlay(context);
          showMySnackBar(context: context, message: "Unable to estimate this swaptransaction, Ensure you have enough gas fee for this transaction and try again", type: SnackBarType.error);
          return;
        }
        if (!GasFeeCheck.gasFeeCheck(bCtr: balanceController, chainCurrency: selectedChain!.chainCurrency, feeInCrypto: swapFee.feeInCrypto)) {
          showMySnackBar(context: context, message: "Insufficient gas fee", type: SnackBarType.error);
          hideOverlay(context);
          return;
        }
        hideOverlay(context);
        bool? result = await SwapHelper.showTransactionFeeBottomSheet(
          context: context,
          title: "Swap ${coinPair.token0.symbol} for ${coinPair.token1.symbol}",
          networkFee: swapFee,
          networkSymbol: selectedChain.chainSymbol,
          actionButtonText: "Swap",
          coinPair: coinPair,
          chainSymbol: selectedChain.chainSymbol,
        );
        if (result == null) {
          hideOverlay(context);
          return;
        }
        if (result == true) {
          showOverlay(context);
          String swapTxId = "";
          try {
            swapTxId = await SwapService.getInstance().swap(poolFee: poolFee, pair: coinPair, amountIn: amountIn, amountOutMin: amountOutMin, fee: swapFee, rpcUrl: rpcUrl, chainSymbol: selectedChain!.chainSymbol, chainId: selectedChain!.chainId);
          } catch (e) {
            logger(e.toString(), "SwapTokenView");
            hideOverlay(context);
            showMySnackBar(context: context, message: "An error occurred while swapping", type: SnackBarType.error);
            return;
          }
          TransactionStatus transactionStatus = await TransactionService().waitForTransactionConfirmation(txHash: swapTxId, rpcUrl: rpcUrl, pollInterval: 4);
          if (transactionStatus.isSuccess) {
            showMySnackBar(context: context, message: "Transaction successful", type: SnackBarType.success);
            onDone();
          } else {
            showMySnackBar(context: context, message: "Transaction failed", type: SnackBarType.error);
          }
        }
        hideOverlay(context);
      } else {
        hideOverlay(context);
      }
    } else if (coinPair.token0.coinType == CoinType.TOKEN && coinPair.token1.coinType == CoinType.NATIVE_TOKEN) {
      logger("Token to Native Swap", "SwapTokenView");
      logger("Token0 symbol: ${coinPair.token0.symbol}", "SwapTokenView");
      logger("Token1 symbol: ${coinPair.token1.symbol}", "SwapTokenView");
      logger("Token0 decimal: ${coinPair.token0.decimal}", "SwapTokenView");
      logger("Token1 decimal: ${coinPair.token1.decimal}", "SwapTokenView");
      logger("Input amount: $inputAmount", "SwapTokenView");
      logger("Weth address: ${coinPair.weth?.contractAddress}", "SwapTokenView");
      showOverlay(context);
      String permit2Address = SwapService.permit2ContractAddress;
      BigInt approveGas = BigInt.zero;
      NetworkFee? approveFee = null;
      try {
        approveGas = await SwapService.getInstance().estimateApprove2Tx(privateKey: privateKey, spender: permit2Address, amountIn: amountIn, contractAddress: contractAddress, rpcUrl: rpcUrl);
        approveFee = await TransactionService().calcNetworkFee(gas: approveGas, gasPrice: gasFee, currentPrice: priceQuote, chainCurrency: selectedChain!.chainCurrency, from: coinPair.token0);
      } catch (e) {
        logger(e.toString(), "SwapTokenView");
        hideOverlay(context);
        showMySnackBar(context: context, message: "Unable to estimate approval transaction, Ensure you have enough gas fee for this transaction and try again", type: SnackBarType.error);
        return;
      }
      hideOverlay(context);
      String? approvalTxId = await SwapHelper.showTokenApprovalBottomSheet(
        context: context,
        title: "Permit",
        coinPair: coinPair,
        spenderAddress: permit2Address,
        spenderName: "Uniswap",
        actionButtonText: "Approve",
        showCloseButton: true,
        approvalAmount: double.parse(inputAmount),
        isUnlimited: false,
        networkFee: approveFee,
        inputAmount: inputAmount,
      );
      if (approvalTxId == null) {
        hideOverlay(context);
        showMySnackBar(context: context, message: "Approval failed", type: SnackBarType.error);
        return;
      }
      showOverlay(context);
      TransactionStatus permitTransactionStatus = await TransactionService().waitForTransactionConfirmation(txHash: approvalTxId, rpcUrl: rpcUrl, pollInterval: 4);
      if (!permitTransactionStatus.isSuccess) {
        showMySnackBar(context: context, message: "Approval failed", type: SnackBarType.error);
        hideOverlay(context);
        return;
      }
      // logger("Uniswap universal router address: $uniswapUniversalRouterAddress", "SwapTokenView");
      BigInt wethAmountInMin = BigInt.from((double.parse(inputAmount) * coinPair.token0Price) * math.pow(10, coinPair.weth!.decimal!)) * BigInt.from((1 - slippage));
      logger(coinPair.poolAddress, "SwapTokenView");
      logger(poolFee.toString(), "SwapTokenView");
      BigInt swapGas = BigInt.zero;
      NetworkFee? swapFee = null;
      try {
        swapGas = await SwapService.getInstance().estimateTokenToNativeSwapTx(pair: coinPair, amountIn: amountIn, wethAmountMin: wethAmountInMin, poolFee: poolFee, isIntermediary: false);
        swapFee = await TransactionService().calcNetworkFee(gas: swapGas, gasPrice: gasFee, currentPrice: priceQuote, chainCurrency: selectedChain!.chainCurrency, from: coinPair.token0);
      
      } catch (e) {
        logger(e.toString(), "SwapTokenView");
        hideOverlay(context);
        showMySnackBar(context: context, message: "Unable to estimate this swap transaction, Ensure you have enough gas fee for this transaction and try again", type: SnackBarType.error);
        return;
      }
     if (!GasFeeCheck.gasFeeCheck(bCtr: balanceController, chainCurrency: selectedChain.chainCurrency, feeInCrypto: swapFee.feeInCrypto)) {
        showMySnackBar(context: context, message: "Insufficient gas fee", type: SnackBarType.error);
        hideOverlay(context);
        return;
      }
      hideOverlay(context);
      bool? result = await SwapHelper.showTransactionFeeBottomSheet(context: context, title: "Swap ${coinPair.token0.symbol}", networkFee: swapFee, networkSymbol: selectedChain!.chainSymbol, actionButtonText: "Swap", coinPair: coinPair, chainSymbol: selectedChain!.chainSymbol);
      if (result == null || result == false) {
        hideOverlay(context);
        return;
      }
      showOverlay(context);
      String swapTxId = await SwapService.getInstance().tokenToNativeSwap(poolFee: poolFee, pair: coinPair, amountIn: amountIn, wethAmountMin: wethAmountInMin, fee: swapFee);
      TransactionStatus swapTransactionStatus = await TransactionService().waitForTransactionConfirmation(txHash: swapTxId, rpcUrl: rpcUrl, pollInterval: 4);
      if (swapTransactionStatus.isSuccess) {
        showMySnackBar(context: context, message: "Transaction successful", type: SnackBarType.success);
        onDone();
      } else {
        showMySnackBar(context: context, message: "Transaction failed", type: SnackBarType.error);
      }
      hideOverlay(context);
    } else if (coinPair.token0.coinType == CoinType.NATIVE_TOKEN && coinPair.token1.coinType == CoinType.TOKEN) {
      logger("Native to Token Swap", "SwapTokenView");
      showOverlay(context);
      BigInt wethAmountInMin = BigInt.from((double.parse(inputAmount) * coinPair.token0Price) * math.pow(10, coinPair.weth!.decimal!)) * BigInt.from((1 - slippage));

      String uniswapUniversalRouterAddress = SwapService.getInstance().getUniversalRouterAddress(chainId: selectedChain.chainId);
      // String tokenAddress = coinPair.weth?.contractAddress ?? "";
      // BigInt permitUnlimited = SwapService.permitUnlimited;
      String wethAddress = coinPair.weth?.contractAddress ?? "";
      BigInt swapGas = BigInt.zero;
      NetworkFee? swapFee = null;
      try {
        swapGas = await SwapService.getInstance().estimateNativeToTokenSwapTx(pair: coinPair, wethAddress: wethAddress, amountIn: amountIn, amountOutMin: amountOutMin, wethAmountMin: wethAmountInMin, poolFee: poolFee, isIntermediary: false);
        swapFee = await TransactionService().calcNetworkFee(gas: swapGas, gasPrice: gasFee, currentPrice: priceQuote, chainCurrency: selectedChain!.chainCurrency, from: coinPair.token0);
     
      } catch (e) {
        logger(e.toString(), "SwapTokenView");
        hideOverlay(context);
        showMySnackBar(context: context, message: "Unable to estimate this swap transaction, Ensure you have enough gas fee for this transaction and try again", type: SnackBarType.error);
        return;
      }
     if (!GasFeeCheck.gasFeeCheck(bCtr: balanceController, chainCurrency: selectedChain!.chainCurrency, feeInCrypto: swapFee.feeInCrypto)) {
        showMySnackBar(context: context, message: "Insufficient gas fee", type: SnackBarType.error);
        hideOverlay(context);
        return;
      }
      hideOverlay(context);
      bool? result = await SwapHelper.showTransactionFeeBottomSheet(context: context, title: "Swap ${coinPair.token0.symbol}", networkFee: swapFee, networkSymbol: selectedChain.chainSymbol, actionButtonText: "Swap", coinPair: coinPair, chainSymbol: selectedChain.chainSymbol);
      if (result == null) {
        hideOverlay(context);
        return;
      }
      showOverlay(context);
      String swapTxId = "";
      try {
        swapTxId = await SwapService.getInstance().nativeToTokenSwap(poolFee: poolFee, pair: coinPair, wethAddress: wethAddress, amountIn: amountIn, amountOutMin: amountOutMin, wethAmountMin: wethAmountInMin, fee: swapFee, isIntermediary: false);
      } catch (e) {
        logger(e.toString(), "SwapTokenView");
        hideOverlay(context);
        showMySnackBar(context: context, message: "An error occurred while swapping", type: SnackBarType.error);
        return;
      }
      TransactionStatus swapTransactionStatus = await TransactionService().waitForTransactionConfirmation(txHash: swapTxId, rpcUrl: rpcUrl, pollInterval: 4);
      if (swapTransactionStatus.isSuccess) {
        showMySnackBar(context: context, message: "Transaction successful", type: SnackBarType.success);
        onDone();
      } else {
        showMySnackBar(context: context, message: "Transaction failed", type: SnackBarType.error);
      }
      hideOverlay(context);
    }
    hideOverlay(context);
  }
}
