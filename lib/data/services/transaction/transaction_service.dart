import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet/wallet.dart';
import 'package:web3dart/web3dart.dart';

import '../../../core/constants/network_constants.dart';
import '../../utils/assets/client_resolver.dart';
import '../../utils/assets/token_factory.dart';
import '../../utils/logger.dart';
import '../../utils/network/gas_fee_check.dart';
import '../../../widgets/snackbar/my_snackbar.dart';
import '../../Models/assets/network_model.dart';
import '../../Models/assets/supported_assets.dart';
import '../../Models/network/network_model.dart';
import '../../Models/send/send_payload.dart';
import 'dart:math' as math;

class TransactionService {
  // Add your transaction service methods here

  Future<BigInt> getChainTxFee({required String sender,required String to,required Uint8List? data,required String rpcUrl})async{
    try{
      Web3Client webClient=await ClientResolver.resolveClient(rpcUrl: rpcUrl);
      BigInt gas=await webClient.estimateGas(sender: EthereumAddress.fromHex(sender), to: EthereumAddress.fromHex(to), data: data);
      logger("Gas : ${gas.toString()}",runtimeType.toString());
      return gas;
    }catch(e){
      logger(e.toString(),runtimeType.toString());
      throw Exception("Unable to get transaction fee");
    }
  }

  Future<BigInt> getChainNetworkFee({required String rpcUrl,required int chainId})async{
    try{
      logger("Getting chain $chainId network fee",runtimeType.toString());
      Web3Client webClient=await ClientResolver.resolveClient(rpcUrl: rpcUrl);
      EtherAmount gasPrice=await webClient.getGasPrice();
      logger("Gas price in wei: ${gasPrice.getInWei.toString()}",runtimeType.toString());
      logger("Gas price in gwei: ${gasPrice.getValueInUnit(EtherUnit.gwei).toString()}",runtimeType.toString());
      if(chainId==1){
        return gasPrice.getInWei*BigInt.from(3);
      }else{
        return gasPrice.getInWei*BigInt.from(2);

      }
    }catch(e){
      logger(e.toString(),runtimeType.toString());
      throw Exception("Unable to get network fee");
    }
  }

  Future<NetworkFee?> getTxInfo({required double priceQuote, required SupportedCoin asset,required SendPayload sendPayload}) async {
    try{
      TokenFactory _tokenFactory=TokenFactory();
      if(asset.coinType==CoinType.TOKEN||asset.coinType==CoinType.WRAPPED_TOKEN){
        final String abi = await rootBundle.loadString("abi/token/token_contract.json");
        String contractAddress = sendPayload.asset!.contractAddress!;
        String symbol = sendPayload.asset!.symbol;
        String toAddress = sendPayload.recipient_address!;
        String assetName = sendPayload.asset!.name;
        String privateKey = sendPayload.asset!.privateKey!;
        NetworkModel network=sendPayload.asset!.networkModel!;
        final credentials = await _tokenFactory.getCredentials(privateKey);
        final contract = await _tokenFactory.intContract(abi, contractAddress, assetName);
        final sendFunction = contract.function('transfer');
        int decimal = sendPayload.asset!.decimal!;
        double estAmount = math.pow(10, decimal).toDouble();
        Transaction transaction = Transaction.callContract(
            contract: contract,
            function: sendFunction,
            from: credentials.address,
            parameters: [
              EthereumAddress.fromHex(toAddress),
              BigInt.from(estAmount)
            ]
        );
        BigInt gas = await getChainTxFee(sender: credentials.address.with0x, to: toAddress, rpcUrl: network.rpcUrl, data: transaction.data!);
        BigInt gasPrice = await getChainNetworkFee(rpcUrl: network.rpcUrl,chainId: network.chainId);
        int maxGas = (gas.toInt() * 4).toInt();
        BigInt totalGas = gasPrice * gas;
        logger("Total gas in wei: $totalGas",runtimeType.toString());
        double amount = EtherAmount.fromBase10String(EtherUnit.wei, totalGas.toString()).getValueInUnit(EtherUnit.ether).toDouble();
        logger("Total gas in ether: $amount",runtimeType.toString());
        double currentPrice = priceQuote;
        logger("Current price: $currentPrice",runtimeType.toString());
        double feeInFiat= amount.toDouble()*currentPrice;
        logger("Fee in Fiat: $feeInFiat",runtimeType.toString());
        double feeInCrypto = amount.toDouble();
        logger("Fee in crypto: $feeInCrypto",runtimeType.toString());
        return NetworkFee(feeInCrypto: feeInCrypto, feeInFiat: feeInFiat, gasPrice: gasPrice, symbol: asset.networkModel!.chainSymbol, maxGas: maxGas);
      }else{
        NetworkModel network=sendPayload.asset!.networkModel!;
        String toAddress = sendPayload.recipient_address!;
        String privateKey = sendPayload.asset!.privateKey!;
        double amountToSend= sendPayload.amount!;
        BigInt amountInWei=BigInt.from(amountToSend*math.pow(10, 18));
        final credentials = await _tokenFactory.getCredentials(privateKey);
        Transaction tx=Transaction(
          to: EthereumAddress.fromHex(toAddress),
          value: EtherAmount.fromBigInt(EtherUnit.wei, amountInWei),
          from: credentials.address,
        );

        BigInt gas = await getChainTxFee(sender: credentials.address.with0x, to: toAddress, rpcUrl: network.rpcUrl, data: tx.data);
        BigInt gasPrice = await getChainNetworkFee(rpcUrl: network.rpcUrl,chainId: network.chainId);
        int maxGas = (gas.toInt() * 4).toInt();
        BigInt totalGas = gasPrice * gas;
        logger("Total gas in wei: $totalGas",runtimeType.toString());
        double amount = EtherAmount.fromBase10String(EtherUnit.wei, totalGas.toString()).getValueInUnit(EtherUnit.ether).toDouble();
        logger("Total gas in ether: $amount",runtimeType.toString());
        logger("Max gas in ether: $totalGas",runtimeType.toString());
        double currentPrice=priceQuote;
        double feeInFiat = amount.toDouble() * currentPrice;
        double feeInCrypto = amount.toDouble();
        logger("Current price: $currentPrice",runtimeType.toString());
        logger("Fee in crypto: $feeInCrypto",runtimeType.toString());
        logger("Fee in Fiat: $feeInFiat",runtimeType.toString());
        return NetworkFee(feeInCrypto: feeInCrypto, feeInFiat: feeInFiat, gasPrice: gasPrice, symbol: asset.networkModel!.chainSymbol, maxGas: maxGas);
      }
    }catch(e){
      logger(e.toString(),runtimeType.toString());
      throw Exception(e);
    }
  }

  Future<Transaction> getTransferTx(BuildContext context,SendPayload sendPayload) async {
    try{
      // Implement the logic to send the transaction
      TokenFactory _tokenFactory=TokenFactory();
      SupportedCoin asset = sendPayload.asset!;
      NetworkFee fee = sendPayload.fee!;
      int decimal = sendPayload.asset!.decimal!;
      // double percentage1=payload.percentage/100;
      double recipientAmount = sendPayload.amount??0.0;
      double totalAmount = ((recipientAmount) * math.pow(10, decimal));
      logger("Total amount: $totalAmount",runtimeType.toString());
      if(asset.coinType==CoinType.TOKEN||asset.coinType==CoinType.WRAPPED_TOKEN){
        final String abi = await rootBundle.loadString("abi/token/token_contract.json");
        String contractAddress = sendPayload.asset!.contractAddress!;
        String assetName = sendPayload.asset!.name;
        String privateKey = sendPayload.asset!.privateKey!;
        final credentials = await _tokenFactory.getCredentials(privateKey);
        final contract = await _tokenFactory.intContract(abi, contractAddress, assetName);
        final sendFunction = contract.function('transfer');
        //Recipient receive 80%  of the transaction while admin receives 20 %
        Transaction transaction0 = Transaction.callContract(
            contract: contract,
            function: sendFunction,
            from: credentials.address,
            gasPrice: EtherAmount.inWei(fee.gasPrice),
            maxGas: fee.maxGas,
            parameters: [
              EthereumAddress.fromHex(sendPayload.recipient_address!),
              BigInt.from(totalAmount)
            ]
        );
        return transaction0;
      }else{
        String toAddress = sendPayload.recipient_address!;
        String privateKey = sendPayload.asset!.privateKey!;
        final credentials = await _tokenFactory.getCredentials(privateKey);
        Transaction tx=Transaction(
          to: EthereumAddress.fromHex(toAddress),
          value: EtherAmount.fromBigInt(EtherUnit.wei, BigInt.from(totalAmount)),
          from: credentials.address,
          gasPrice: EtherAmount.inWei(fee.gasPrice),
          maxGas: fee.maxGas,
        );
        return tx;
      }
    }catch(e){
      logger(e.toString(), runtimeType.toString());
      throw Exception( "An error occurred while creating transaction");
    }
  }

  Future<String> sendTx({required Transaction transaction,required Credentials credentials,required SupportedCoin asset})async{
    try{
      logger("Sending transaction",runtimeType.toString());
      int chainId=asset.networkModel!.chainId;
      Web3Client webClient=await ClientResolver.resolveClient(rpcUrl: asset.networkModel!.rpcUrl);
      Uint8List signedTransaction = await webClient.signTransaction(credentials, transaction, chainId: chainId, fetchChainIdFromNetworkId: false);
      String txId=await webClient.sendRawTransaction(signedTransaction);
      logger("TxId: $txId",runtimeType.toString());
      return txId;
    }catch(e){
      logger(e.toString(),runtimeType.toString());
      throw Exception("An error occurred while sending transaction");
    }
  }


  Future<String> sendNativeCoinTx({required Transaction tx,required String to, required Credentials credentials,required SupportedCoin asset,required int chainId}) async {
    try {
      logger("Sending Eth",runtimeType.toString());
      /// [...], you need to specify the url and your client, see example above
      Web3Client webClient=await ClientResolver.resolveClient(rpcUrl: asset.networkModel!.rpcUrl);
      return await webClient.sendTransaction(
          credentials,
          tx,
          chainId: chainId
      );
    } catch (e) {
      logger(e.toString(),runtimeType.toString());
      throw Exception("An error occurred while sending transaction");
    }
  }
}