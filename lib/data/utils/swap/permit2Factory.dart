import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:quanthex/core/network/my_api.dart';
import 'package:quanthex/data/Models/network/network_model.dart';
import 'package:quanthex/data/services/swap/swap_service.dart';
import 'package:quanthex/data/utils/assets/client_resolver.dart';
import 'package:quanthex/data/utils/assets/token_factory.dart';
import 'package:web3dart/web3dart.dart';
import 'package:wallet/wallet.dart';



class Permit2Factory{

  static TokenFactory tokenFactory=TokenFactory();
  static final my_api = MyApi();
  static String permit2ContractAddress="0x000000000022D473030F116dDEE9F6B43aC78BA3";


  static Future<String> callPermit({required String privateKey, required String tokenAddress,required String spenderAddress,required String rpcUrl,required int chainId,required NetworkFee fee})async{
    try{
      Web3Client web3client=await ClientResolver.resolveClient(rpcUrl: rpcUrl);
      final String permit2Abi = await rootBundle.loadString("assets/abi/permit/permit2.json");
      final contract = await tokenFactory.intContract(permit2Abi, permit2ContractAddress, "Permit2");
      final permitFunction = contract.findFunctionsByName('approve').last;
      final credentials = await tokenFactory.getCredentials(privateKey);
      BigInt amountIn=SwapService.permitUnlimited;
      final gasPrice=EtherAmount.inWei(fee.gasPrice);
      final maxGas=fee.maxGas;
      BigInt deadline=BigInt.from(DateTime.now().add(const Duration(minutes: 60)).millisecondsSinceEpoch);
      List<dynamic> param=[
        EthereumAddress.fromHex(tokenAddress),
        EthereumAddress.fromHex(spenderAddress),
        amountIn,
        deadline
      ];
      Transaction tx=await SwapService.getInstance().constructTx(contract: contract, function: permitFunction, credentials: credentials, params: param, gasPrice: gasPrice, maxGas: maxGas);
      Uint8List signedTransaction = await web3client.signTransaction(credentials, tx, chainId: chainId, fetchChainIdFromNetworkId: false);
      String txId=await web3client.sendRawTransaction(signedTransaction);
      log("Permit2 txId: $txId");
      return txId;
    }catch(e){
      log(e.toString());
      throw Exception(e);
    }
  }

  static Future<bool> checkPermitAllowance({required String privateKey, required String ownerAddress,required String tokenAddress,required String spenderAddress,required String rpcUrl})async{
    try{
      log("Checking allowance for $spenderAddress on $tokenAddress");
      Web3Client web3client=await ClientResolver.resolveClient(rpcUrl: rpcUrl);
      final String permit2Abi = await rootBundle.loadString("assets/abi/permit/permit2.json");
      final contract = await tokenFactory.intContract(permit2Abi, permit2ContractAddress, "Permit2");
      final permitFunction = contract.function('allowance');
      BigInt deadline=BigInt.from(DateTime.now().add(const Duration(minutes: 30)).millisecondsSinceEpoch);
      List<dynamic> param=[
        EthereumAddress.fromHex(ownerAddress),
        EthereumAddress.fromHex(tokenAddress),
        EthereumAddress.fromHex(spenderAddress)
      ];
      final result=await web3client.call(
          contract: contract,
          function: permitFunction,
          params: param
      );
      BigInt amount=result[0];
      BigInt expiration=result[1];
      BigInt nonce=result[2];
      log("Allowance: $amount, expiration: $expiration, nonce: $nonce");
      return checkValidity(amount: amount, expiration: expiration, nonce: nonce);
    }catch(e){
      log(e.toString());
      throw Exception("Unable to check allowance");
    }
  }

  static Future<bool> checkPermitAllowanceOnToken({required BigInt amountIn,required String ownerAddress,required String tokenAddress,required String spenderAddress,required String rpcUrl})async{
    try{
      log("Checking permit allowance in token: $tokenAddress ");
      Web3Client web3client=await ClientResolver.resolveClient(rpcUrl: rpcUrl);
      final String tokenAbi = await rootBundle.loadString("assets/token_contract.json");
      final contract = await tokenFactory.intContract(tokenAbi, tokenAddress, "TokenAbi");
      final allowanceFunction = contract.function('allowance');
      List<dynamic> param=[
        EthereumAddress.fromHex(ownerAddress),
        EthereumAddress.fromHex(spenderAddress)
      ];
      final result=await web3client.call(
          contract: contract,
          function: allowanceFunction,
          params: param
      );
      BigInt amount=result[0];
      log("Allowance: $amount");
      if(amount>amountIn){
        log("Allowance is greater than amount to be spent");
        return true;
      }else{
        return false;
      }
    }catch(e){
      log(e.toString());
      throw Exception("Unable to check allowance");
    }
  }

  // static Future<String> callRpc({required String method, required dynamic param,required NetworkModel network})async{
  //   try{
  //     log("Calling $method");
  //     String rpc=await ClientResolver.resolveUrl(networkModel: network);
  //     RpcModel rpcModel=RpcModel(
  //         id: 0x1,
  //         jsonrpc: "2.0",
  //         method: method,
  //         params: []
  //     );
  //     var response = await my_api.post(rpcModelToJson(rpcModel),rpc, {"Content-Type": "application/json"});
  //     if(response!=null){
  //       log("$method: Response code ${response.statusCode}");
  //       log("$method: Response code ${response.body}");
  //       if (response.statusCode == 200) {
  //         dynamic body=jsonDecode(response.body);
  //         String result=body['result'];
  //         return result;
  //       } else {
  //         String message = jsonDecode(response.body)['status']["error_message"];
  //         log(message);
  //         throw Exception("eth_estimateGas: ${response.statusCode}");
  //       }
  //     }else{
  //       throw Exception("Unable to estimate transaction fee, could not get response");
  //     }
  //   }catch(e){
  //     throw Exception(e);
  //   }
  // }

  static String encodeDomain(Map<String, dynamic> domain) {
    return jsonEncode(domain);
  }

  static String encodeData(Map<String, dynamic> data) {
    return jsonEncode(data);
  }

  static Uint8List hashStruct(String encodedData) {
    return keccakUtf8(encodedData);
  }
  //This function checks if the allowance of the spender in the permit contract is less than the amount to be spent and has a record on the permit contract, thou we grant them unlimited
  static bool checkValidity({required BigInt amount,required BigInt expiration,required BigInt nonce}){
    DateTime dateTime=DateTime.fromMillisecondsSinceEpoch(expiration.toInt());
    DateTime now=DateTime.now();
    if(now.isBefore(dateTime)){
      log("Address has a valid permit");
      return true;
    }else{
      log("Address does not has a valid permit");
      return false;
    }
  }
}