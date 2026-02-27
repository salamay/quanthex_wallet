import 'package:dio/dio.dart';
import 'package:quanthex/core/network/Api_url.dart';
import 'package:quanthex/data/Models/mining/mining_dto.dart';
import 'package:quanthex/data/Models/staking/staking_dto.dart';
import 'package:quanthex/data/Models/staking/staking_referral_dto.dart';
import 'package:quanthex/data/Models/users/referral_dto.dart';

import '../../../core/network/my_api.dart';
import '../../utils/logger.dart';
import '../auth/auth_service.dart';

class MiningService{


  MiningService._internal();
  static MiningService? _instance;
  final my_api = MyApi();


  static MiningService getInstance() {
    if (_instance == null) {
      logger("Creating new instance of MiningService", "MiningService");
    }
    _instance ??= MiningService._internal();
    return _instance!;
  }


  Future<List<MiningDto>> getMinings(String walletAddress)async{
    logger("Getting minings", runtimeType.toString());
    Response? response;
    try{
      String accessToken=AuthService.getInstance().authToken;
      response = await my_api.get("${ApiUrls.minings}?walletAddress=$walletAddress", {"Content-Type": "application/json", "Authorization": "Bearer $accessToken"});
    }catch(e){
      logger(e.toString(),runtimeType.toString());
      throw Exception("Unable to establish connection");
    }
    if(response!=null){
      logger("Getting minings: Response code ${response.statusCode}",runtimeType.toString());
      if(response.statusCode!>=200 && response.statusCode!<300){
        final  data=response.data["data"];
        return List.from(data).map((e) => MiningDto.fromJson(e)).toList();
      }else{
        var data=response.data;
        throw Exception(data["message"]);
      }
    }else{
      throw Exception("Unable to establish connection");
    }
  }

  Future<List<StakingDto>> getStakings(String walletAddress, String stakingStatus)async{
    logger("Getting stakings", runtimeType.toString());
    Response? response;
    try{
      String accessToken=AuthService.getInstance().authToken;
      response = await my_api.get("${ApiUrls.stakings}?walletAddress=$walletAddress&stakingStatus=$stakingStatus", {"Content-Type": "application/json", "Authorization": "Bearer $accessToken"});
    }catch(e){
      logger(e.toString(),runtimeType.toString());
      throw Exception("Unable to establish connection");
    }
    if(response!=null){
      logger("Getting stakings: Response code ${response.statusCode}",runtimeType.toString());
      
      if(response.statusCode!>=200 && response.statusCode!<300){
        final  data=response.data["data"];
        return List.from(data).map((e) => StakingDto.fromJson(e)).toList();
      }else{
        var data=response.data;
        throw Exception(data["message"]);
      }
    }else{
      throw Exception("Unable to establish connection");
    }
  }

  Future<List<ReferralDto>> getSubscriptionDirectReferrals(String miningSubscriptionId) async {
    logger("Getting mining direct referrals", runtimeType.toString());
    Response? response;
    try {
      String accessToken = AuthService.getInstance().authToken;
      response = await my_api.get("${ApiUrls.subscriptionDirectReferrals}?subscriptionId=$miningSubscriptionId", {"Content-Type": "application/json", "Authorization": "Bearer $accessToken"});
    } catch (e) {
      logger(e.toString(), runtimeType.toString());
      throw Exception("Unable to establish connection");
    }
    if (response != null) {
      logger("Getting mining direct referrals response code: ${response.statusCode}", runtimeType.toString());
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final data = response.data["data"];
        return List.from(data).map((e) => ReferralDto.fromJson(e)).toList();
      } else {
        var data = response.data;
        throw Exception(data["message"]);
      }
    } else {
      throw Exception("Unable to establish connection");
    }
  }
  Future<List<ReferralDto>> getSubscriptionIndirectReferrals(String miningSubscriptionId) async {
    logger("Getting mining indirect referrals", runtimeType.toString());
    Response? response;
    try {
      String accessToken = AuthService.getInstance().authToken;
      response = await my_api.get("${ApiUrls.subscriptionIndirectReferrals}?subscriptionId=$miningSubscriptionId", {"Content-Type": "application/json", "Authorization": "Bearer $accessToken"});
    } catch (e) {
      logger(e.toString(), runtimeType.toString());
      throw Exception("Unable to establish connection");
    }
    if (response != null) {
      logger("Getting mining indirect referrals: Response code ${response.statusCode}", runtimeType.toString());
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final data = response.data["data"];
        return List.from(data).map((e) => ReferralDto.fromJson(e)).toList();
      } else {
        var data = response.data;
        throw Exception(data["message"]);
      }
    } else {
      throw Exception("Unable to establish connection");
    }
  }
  Future<List<StakingReferralDto>> getStakingReferrals({required String stakingId}) async {
    logger("Getting staking referrals", runtimeType.toString());
    Response? response;
    try {
      String accessToken = AuthService.getInstance().authToken;
      response = await my_api.get("${ApiUrls.stakingReferrals}?stakingId=$stakingId", {"Content-Type": "application/json", "Authorization": "Bearer $accessToken"});
    } catch (e) {
      logger(e.toString(), runtimeType.toString());
      throw Exception("Unable to establish connection");
    }
    if (response != null) {
      logger("Getting staking referrals: Response code ${response.statusCode}", runtimeType.toString());
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final data = response.data["data"];
        return List.from(data).map((e) => StakingReferralDto.fromJson(e)).toList();
      } else {
        var data = response.data;
        throw Exception(data["message"]);
      }
    } else {
      throw Exception("Unable to establish connection");
    }
  }
}