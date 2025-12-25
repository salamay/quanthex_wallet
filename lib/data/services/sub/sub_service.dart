import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:quanthex/core/network/Api_url.dart';
import 'package:quanthex/data/Models/assets/supported_assets.dart';
import 'package:quanthex/data/Models/mining/subscription_payload.dart';
import 'package:quanthex/data/Models/subscription/subscription_dto.dart';
import 'package:quanthex/data/services/auth/auth_service.dart';

import '../../../core/network/my_api.dart';
import '../../../utils/logger.dart';

class SubService {

  SubService._internal();
  static SubService? _instance;
  final my_api = MyApi();




  static SubService getInstance() {
    if (_instance == null) {
      logger("Creating new instance of SubService", "SubService");
    }
    _instance ??= SubService._internal();
    return _instance!;
  }

  Future<SubscriptionDto> makeSubscription({required SubscriptionPayload sub, required SupportedCoin paymentToken, required SupportedCoin rewardToken, required String signedTx,required String rpc}) async {
    logger("Making subscription for ${sub.subPackageName} using ${paymentToken.symbol} to receive rewards in ${rewardToken.symbol}", "SubService");
    sub.subChainId = paymentToken.networkModel!.chainId;
    sub.subAssetContract = paymentToken.contractAddress;
    sub.subAssetSymbol = paymentToken.symbol;
    sub.subAssetName = paymentToken.name;
    sub.subAssetDecimals = paymentToken.decimal;
    sub.subAssetImage = paymentToken.image;
    sub.subRewardContract = paymentToken.contractAddress;
    sub.subRewardChainId = rewardToken.networkModel!.chainId;
    sub.subRewardAssetName = rewardToken.name;
    sub.subRewardAssetSymbol = rewardToken.symbol;
    sub.subRewardAssetImage = rewardToken.image;
    sub.subRewardAssetDecimals = rewardToken.decimal;
    sub.subDuration = DateTime.now().add(Duration(days: 365)).millisecondsSinceEpoch.toString();
    sub.subSignedTx = signedTx;
    sub.subRpc = rpc;
    Response? response;
    try{
      String accessToken=AuthService.getInstance().authToken;
      var body = sub.toJson();
      response = await my_api.post(jsonEncode(body),ApiUrls.subscribe, {"Content-Type": "application/json", "Authorization": "Bearer $accessToken"});
    }catch(e){
      logger(e.toString(),runtimeType.toString());
      throw Exception("Unable to establish connection");
    }
    if(response!=null){
      logger("Making subscription: Response code ${response.statusCode}",runtimeType.toString());
      if(response.statusCode!>=200 && response.statusCode!<300){
        final  data=response.data["data"];
        return SubscriptionDto.fromJson(data);
      }else{
        var data=response.data;
        throw Exception(data["message"]);
      }
    }else{
      throw Exception("Unable to establish connection");
    }
  }
    // Simulate network call
}