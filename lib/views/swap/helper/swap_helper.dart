import 'package:flutter/material.dart';
import 'package:quanthex/core/constants/network_constants.dart';
import 'package:quanthex/data/Models/assets/network_model.dart';
import 'package:quanthex/data/Models/network/network_model.dart';
import 'package:quanthex/data/Models/swap/model/coin_pair.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/data/utils/network/chain_parse.dart';
import 'package:quanthex/data/utils/overlay_utils.dart';
import 'package:quanthex/views/swap/token_approval_bottom_sheet.dart';
import 'package:quanthex/views/swap/transaction_fee_bottom_sheet.dart';
import 'package:quanthex/data/services/swap/swap_service.dart';
import 'package:quanthex/data/services/transaction/transaction_service.dart';
import 'package:quanthex/data/utils/logger.dart';
import 'package:quanthex/data/utils/network/gas_fee_check.dart';
import 'package:quanthex/widgets/snackbar/my_snackbar.dart';
import 'package:uniswap_flutter_v3/uniswap/domain/entities/token.dart';
import 'package:uniswap_flutter_v3/uniswap/utils/constants/constants.dart';
import 'package:uniswap_flutter_v3/uniswap_flutter_v3.dart' as flv3;
import 'dart:math' as math;

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
  Future<BigInt> estimateTokenApproval({required int chainId, required Token tokenIn, required String privateKey, required String inputAmount})async{
      flv3.UniswapV3 uniswapV3= ChainParse.getChainId(chainId);
      try {
        BigInt approveGas = await uniswapV3.estimateApproval(token: tokenIn, amount: double.parse(inputAmount), privateKey: privateKey);
        return approveGas;
      } catch (e) {
        logger(e.toString(), "SwapTokenView");
        throw Exception("Unable to estimate approval transaction, Ensure you have enough gas fee for this transaction and try again");
      }
  }

  Future<void> waitForTx(String txHash,int chainId)async{
    flv3.UniswapV3 uniswapV3= ChainParse.getChainId(chainId);
    try {
      await uniswapV3.waitForTransaction(txHash, 60);
    } catch (e) {
      logger(e.toString(), "SwapTokenView");
      throw Exception("Unable to confirm transaction, Ensure you have enough gas fee for this transaction and try again");
    }
  }

  Future<flv3.Pool?> getPool({required int chainId, required Token tokenIn, required Token tokenOut}) async {
    flv3.UniswapV3 uniswapV3= ChainParse.getChainId(chainId);
    try {
      return await uniswapV3.getPool(tokenA: tokenIn, tokenB: tokenOut);
    } catch (e) {
      logger(e.toString(), "SwapTokenView");
      rethrow;
    }
}

  Future<BigInt> estimateApprove2Tx({required int chainId, required Token tokenIn, required String privateKey, required String inputAmount})async{
      flv3.UniswapV3 uniswapV3= ChainParse.getChainId(chainId);
      try {
        BigInt approveGas = await uniswapV3.estimatePermit2Approval(token: tokenIn, amount: double.parse(inputAmount), privateKey: privateKey);
        return approveGas;
      } catch (e) {
        logger(e.toString(), "SwapTokenView");
        throw Exception("Unable to estimate approval transaction, Ensure you have enough gas fee for this transaction and try again");
      }
  }
  Future<BigInt> estimateTokenToTokenSwap({required int chainId,required flv3.Pool pool, required String inputAmount, required String privateKey})async{
    try{
      flv3.UniswapV3 uniswapV3= ChainParse.getChainId(chainId);
      BigInt tokenToTokenSwapGas = await  uniswapV3.estimateTokenToTokenSwap(pool: pool, amountIn: double.parse(inputAmount), privateKey: privateKey);
      return tokenToTokenSwapGas;
    }catch(e){
      logger(e.toString(), "SwapTokenView");
      throw Exception("Unable to estimate this swap transaction, Ensure you have enough gas fee for this transaction and try again");
    }
  }
  Future<BigInt> estimateTokenToNativeSwapTx({required int chainId,required flv3.Pool pool, required String inputAmount, required String privateKey})async{
    try{
      flv3.UniswapV3 uniswapV3= ChainParse.getChainId(chainId);
      print(pool.feeTier);
      print(pool.token0.contractAddress);
      print(pool.token1.contractAddress);
      print(pool.poolAddress);
      BigInt tokenToTokenSwapGas = await  uniswapV3.estimateTokenToNativeSwap(pool: pool, amountIn: double.parse(inputAmount), privateKey: privateKey);
      return tokenToTokenSwapGas;
    }catch(e){
      logger(e.toString(), "SwapTokenView");
      throw Exception("Unable to estimate this swap transaction, Ensure you have enough gas fee for this transaction and try again");
    }
  }

  Future<BigInt> estimateNativeToTokenSwapTx({required int chainId,required flv3.Pool pool, required String inputAmount, required String privateKey})async{
    try{
      flv3.UniswapV3 uniswapV3= ChainParse.getChainId(chainId);
      BigInt tokenToTokenSwapGas = await  uniswapV3.estimateNativeToTokenSwap(pool: pool, amountIn: double.parse(inputAmount), privateKey: privateKey);
      return tokenToTokenSwapGas;
    }catch(e){
      logger(e.toString(), "SwapTokenView");
      throw Exception("Unable to estimate this swap transaction, Ensure you have enough gas fee for this transaction and try again");
    }
  }


  Future<String?> tokenToTokenFlow({required BuildContext context, required NetworkModel selectedChain, required CoinPair coinPair, required walletAddress, required String privateKey, required String inputAmount,})async{
    try{
      logger("Token to Token Swap", "SwapTokenView");
      showOverlay(context);
      BalanceController balanceController = Provider.of<BalanceController>(context, listen: false);
      String rpcUrl = selectedChain.rpcUrl ?? "";
      int chainId=selectedChain.chainId;
      logger("Amount in: $inputAmount", "SwapTokenView");
      flv3.UniswapV3 uniswapV3= ChainParse.getChainId(selectedChain.chainId);
      String spender = SwapService.getInstance().getUniswapSwapRouterAddress(chainId: selectedChain!.chainId);
      double? priceQuote = balanceController.priceQuotes[coinPair.token0.symbol] ?? 0;
      BigInt gasFee = await uniswapV3.getChainNetworkFee(rpcUrl: rpcUrl, chainId: chainId);;
      Token tokenIn = Token(contractAddress: coinPair.token0.contractAddress ?? "", decimals: coinPair.token0.decimal ?? 18, symbol: coinPair.token0.symbol, name: coinPair.token0.name);
      Token tokenOut = Token(contractAddress: coinPair.token1.contractAddress ?? "", decimals: coinPair.token1.decimal ?? 18, symbol: coinPair.token1.symbol, name: coinPair.token1.name);
      flv3.Pool? pool=await uniswapV3.getPool(tokenA: tokenIn, tokenB: tokenOut);
      if(pool==null){
        hideOverlay(context);
        return null;
      }
      // double amountInFiat = double.parse(inputAmount) * priceQuote;
      BigInt approveGas = await uniswapV3.estimateApproval(token: tokenIn, amount: double.parse(inputAmount), privateKey: privateKey);
      NetworkFee?  approveFee = await TransactionService().calcNetworkFee(gas: approveGas, gasPrice: gasFee, currentPrice: priceQuote, chainCurrency: selectedChain!.chainCurrency);
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
        BigInt tokenToTokenSwapGas = await estimateTokenToTokenSwap(chainId: chainId,pool: pool,inputAmount: inputAmount,privateKey: privateKey);
        NetworkFee? swapFee = await TransactionService().calcNetworkFee(gas: tokenToTokenSwapGas, gasPrice: gasFee, currentPrice: priceQuote, chainCurrency: selectedChain!.chainCurrency);
        if (!GasFeeCheck.gasFeeCheck(bCtr: balanceController, chainCurrency: selectedChain!.chainCurrency, feeInCrypto: swapFee.feeInCrypto)) {
          showMySnackBar(context: context, message: "Insufficient gas fee", type: SnackBarType.error);
          hideOverlay(context);
          return null;
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
          return null;
        }
        if (result == true) {
          showOverlay(context);
          String swapTxId =  await  uniswapV3.swapTokenToToken(privateKey: privateKey, pool: pool, amountIn: double.parse(inputAmount), maxGas: swapFee.maxGas);
          return swapTxId;
        }else{
          hideOverlay(context);
          return null;
        }
        hideOverlay(context);
      } else {
        return null;
      }
    }catch(e){
      hideOverlay(context);
      rethrow;
    }
  }

  Future<String?> tokenToNativeFlow({required BuildContext context, required NetworkModel selectedChain, required CoinPair coinPair, required walletAddress, required String privateKey, required String inputAmount})async{
    try{
      logger("Token to Native Swap", "SwapTokenView");
      showOverlay(context);
      BalanceController balanceController = Provider.of<BalanceController>(context, listen: false);
      String rpcUrl = selectedChain.rpcUrl ?? "";
      int chainId=selectedChain.chainId;
      logger("Amount in: $inputAmount", "SwapTokenView");
      double? priceQuote = balanceController.priceQuotes[coinPair.token0.symbol] ?? 0;
      flv3.UniswapV3 uniswapV3= ChainParse.getChainId(selectedChain.chainId);
      String permit2Address = SwapService.permit2ContractAddress;
      BigInt gasFee = await uniswapV3.getChainNetworkFee(rpcUrl: rpcUrl, chainId: chainId);;
      Token tokenIn = Token(contractAddress: coinPair.token0.contractAddress ?? "", decimals: coinPair.token0.decimal ?? 18, symbol: coinPair.token0.symbol, name: coinPair.token0.name);
      //The tokenOut should be wrapped
      String wethContractAddress = SwapService.getInstance().getWETHContractAddress(chainId: selectedChain!.chainId);
      String wethSymbol = SwapService.getInstance().getWETHName(chainId: selectedChain!.chainId);
      logger("Weth contract address: $wethContractAddress", "SwapTokenView");
      flv3.Token tokenOut = flv3.Token(contractAddress: wethContractAddress, decimals: 18, symbol: wethSymbol, name: wethSymbol);
      print(coinPair.token1.name);
      flv3.Pool? pool=await uniswapV3.getPool(tokenA: tokenIn, tokenB: tokenOut);
      if(pool==null){
        hideOverlay(context);
        showMySnackBar(context: context, message: "Unable to get pool due to rate limit, try again", type: SnackBarType.error);
        return null;
      }
      //Check allowance
      flv3.Allowance allowance=await uniswapV3.getPermitAllowance(token: tokenIn, ownerAddress: walletAddress);
      print('Allowance: $allowance');
      if(allowance.amount<=BigInt.from(flv3.UniswapV3.fromWei(BigInt.from(double.parse(inputAmount)), tokenIn.decimals))||!SwapService.checkValidity(expiration: allowance.expiration)){
        BigInt approveGas = await estimateApprove2Tx(chainId: chainId, tokenIn: tokenIn, privateKey: privateKey, inputAmount: inputAmount);
        NetworkFee? approveFee=await TransactionService().calcNetworkFee(gas: approveGas, gasPrice: gasFee, currentPrice: priceQuote, chainCurrency: selectedChain!.chainCurrency);
        hideOverlay(context);
        String? approvalTxId = await SwapHelper.showTokenApprovalBottomSheet(
          context: context,
          title: "Permit",
          coinPair: coinPair,
          spenderAddress: permit2Address,
          spenderName: "Permit2",
          actionButtonText: "Approve",
          showCloseButton: true,
          //0 since we mark unlimited
          approvalAmount: 0,
          isUnlimited: true,
          networkFee: approveFee,
          inputAmount: inputAmount,
        );
        if (approvalTxId == null) {
          showMySnackBar(context: context, message: "Cancelled", type: SnackBarType.error);
          return null;
        }
        showOverlay(context);
        BigInt permitCallGas=await uniswapV3.estimatePermit2Call(
          token: tokenIn,
          privateKey: privateKey,
        );
        NetworkFee? signFee = await TransactionService().calcNetworkFee(gas: permitCallGas, gasPrice: gasFee, currentPrice: priceQuote, chainCurrency: selectedChain!.chainCurrency);
        if (!GasFeeCheck.gasFeeCheck(bCtr: balanceController, chainCurrency: selectedChain.chainCurrency, feeInCrypto: signFee.feeInCrypto)) {
          showMySnackBar(context: context, message: "Insufficient gas fee", type: SnackBarType.error);
          return null;
        }
        hideOverlay(context);
        bool? result = await SwapHelper.showTransactionFeeBottomSheet(context: context, title: "Sign ${coinPair.token0.symbol}", networkFee: signFee, networkSymbol: selectedChain.chainSymbol, actionButtonText: "Sign", coinPair: coinPair, chainSymbol: selectedChain.chainSymbol);
        if (result == null || result == false) {
          hideOverlay(context);
          showMySnackBar(context: context, message: "Cancelled", type: SnackBarType.error);
          return null;
        }
        showOverlay(context);
        String rpcUrl=selectedChain.rpcUrl!;
        BigInt gasPrice = await uniswapV3.getChainNetworkFee(rpcUrl: rpcUrl, chainId: chainId);;
        // Approve pe
        String callPermitHash=await uniswapV3.callPermit2(
            token: tokenIn,
            privateKey: privateKey,
            maxGas: permitCallGas.toInt(),
            gasPrice: gasPrice
        );
        print('Call permit hash: $callPermitHash');
        TransactionStatus status2=await TransactionService().waitForTransactionConfirmation( txHash: callPermitHash, rpcUrl: rpcUrl);
        print('Call permit status: $status2');
        if(!status2.isSuccess){
          showMySnackBar(context: context, message: "Approval failed", type: SnackBarType.error);
          return null;
        }
      }
      BigInt swapGas = await estimateTokenToNativeSwapTx(chainId: chainId, pool: pool, inputAmount: inputAmount, privateKey: privateKey);
      NetworkFee? swapFee = await TransactionService().calcNetworkFee(gas: swapGas, gasPrice: gasFee, currentPrice: priceQuote, chainCurrency: selectedChain!.chainCurrency);
      if (!GasFeeCheck.gasFeeCheck(bCtr: balanceController, chainCurrency: selectedChain.chainCurrency, feeInCrypto: swapFee.feeInCrypto)) {
        showMySnackBar(context: context, message: "Insufficient gas fee", type: SnackBarType.error);
        return null;
      }
      hideOverlay(context);
      bool? result = await SwapHelper.showTransactionFeeBottomSheet(context: context, title: "Swap ${coinPair.token0.symbol}", networkFee: swapFee, networkSymbol: selectedChain!.chainSymbol, actionButtonText: "Swap", coinPair: coinPair, chainSymbol: selectedChain!.chainSymbol);
      if (result == null || result == false) {
        return null;
      }
      showOverlay(context);
      String swapTxId = await uniswapV3.swapTokenToNative(privateKey: privateKey, pool: pool, amountIn: double.parse(inputAmount), maxGas:swapGas.toInt());
      hideOverlay(context);
      return swapTxId;
    }catch(e){
      hideOverlay(context);
      logger(e.toString(), runtimeType.toString());
      throw Exception(e.toString());
    }
  }

  Future<String?> nativeToTokenFlow({required BuildContext context, required NetworkModel selectedChain, required CoinPair coinPair, required walletAddress, required String privateKey, required String inputAmount})async{
    try{
      logger("Native to Token Swap", "SwapTokenView");
      showOverlay(context);
      BalanceController balanceController = Provider.of<BalanceController>(context, listen: false);
      String rpcUrl = selectedChain.rpcUrl ?? "";
      int chainId=selectedChain.chainId;
      logger("Amount in: $inputAmount", "SwapTokenView");
      double? priceQuote = balanceController.priceQuotes[coinPair.token0.symbol] ?? 0;
      flv3.UniswapV3 uniswapV3= ChainParse.getChainId(selectedChain.chainId);
      String permit2Address = SwapService.permit2ContractAddress;
      BigInt gasFee = await uniswapV3.getChainNetworkFee(rpcUrl: rpcUrl, chainId: chainId);;
      //The tokenIn should be wrapped
      String wethContractAddress = SwapService.getInstance().getWETHContractAddress(chainId: selectedChain!.chainId);
      String wethSymbol = SwapService.getInstance().getWETHName(chainId: selectedChain!.chainId);
      logger("Weth contract address: $wethContractAddress", "SwapTokenView");
      flv3.Token tokenIn = flv3.Token(contractAddress: wethContractAddress, decimals: 18, symbol: wethSymbol, name: wethSymbol);
      Token tokenOut = Token(contractAddress: coinPair.token1.contractAddress ?? "", decimals: coinPair.token1.decimal ?? 18, symbol: coinPair.token1.symbol, name: coinPair.token1.name);
      flv3.Pool? pool=await uniswapV3.getPool(tokenA: tokenIn, tokenB: tokenOut);
      if(pool==null){
        hideOverlay(context);
        return null;
      }
      BigInt swapGas = await estimateNativeToTokenSwapTx(chainId: chainId, pool: pool, inputAmount: inputAmount, privateKey: privateKey);
      NetworkFee? swapFee = await TransactionService().calcNetworkFee(gas: swapGas, gasPrice: gasFee, currentPrice: priceQuote, chainCurrency: selectedChain.chainCurrency);
      if (!GasFeeCheck.gasFeeCheck(bCtr: balanceController, chainCurrency: selectedChain.chainCurrency, feeInCrypto: swapFee.feeInCrypto)) {
        showMySnackBar(context: context, message: "Insufficient gas fee", type: SnackBarType.error);
        hideOverlay(context);
        return null;
      }
      hideOverlay(context);
      bool? result = await SwapHelper.showTransactionFeeBottomSheet(context: context, title: "Swap ${coinPair.token0.symbol}", networkFee: swapFee, networkSymbol: selectedChain.chainSymbol, actionButtonText: "Swap", coinPair: coinPair, chainSymbol: selectedChain.chainSymbol);
      if (result == null || result == false) {
        hideOverlay(context);
        return null;
      }
      showOverlay(context);
      String swapTxId = await uniswapV3.swapNativeToToken(privateKey: privateKey, pool: pool, amountIn: double.parse(inputAmount), maxGas: swapFee.maxGas);
      return swapTxId;
    }catch(e){
      hideOverlay(context);
      throw Exception(e.toString());
    }
  }
   Future<String?> startSwap({required BuildContext context, required CoinPair coinPair, required walletAddress, required String privateKey, required String inputAmount, required String outputAmount, required NetworkModel selectedChain}) async {
    if (coinPair.token0.coinType == CoinType.TOKEN && coinPair.token1.coinType == CoinType.TOKEN) {
      return await tokenToTokenFlow(context: context, selectedChain: selectedChain, coinPair: coinPair, walletAddress: walletAddress, privateKey: privateKey, inputAmount: inputAmount);
    } else if (coinPair.token0.coinType == CoinType.TOKEN && coinPair.token1.coinType == CoinType.NATIVE_TOKEN) {
     return await tokenToNativeFlow(context: context, selectedChain: selectedChain, coinPair: coinPair, walletAddress: walletAddress, privateKey: privateKey, inputAmount: inputAmount);
    } else if (coinPair.token0.coinType == CoinType.NATIVE_TOKEN && coinPair.token1.coinType == CoinType.TOKEN) {
      return await nativeToTokenFlow(context: context, selectedChain: selectedChain, coinPair: coinPair, walletAddress: walletAddress, privateKey: privateKey, inputAmount: inputAmount);
    }else{
      return null;
    }
  }
}
