import 'package:dio/dio.dart';
import 'package:quanthex/data/Models/users/profile_dto.dart';
import 'package:quanthex/data/Models/users/referral_dto.dart';

import '../../../core/network/Api_url.dart';
import '../../../core/network/my_api.dart';
import '../../../utils/logger.dart';
import '../../Models/mining/mining_dto.dart';
import '../auth/auth_service.dart';

class UserService {

  UserService._internal();
  static UserService? _instance;
  final my_api = MyApi();


  static UserService getInstance() {
    if (_instance == null) {
      logger("Creating new instance of UserService", "UserService");
    }
    _instance ??= UserService._internal();
    return _instance!;
  }

  Future<List<ReferralDto>> getReferrals()async{
    logger("Getting referrals", runtimeType.toString());
    Response? response;
    try{
      String accessToken=AuthService.getInstance().authToken;
      response = await my_api.get(ApiUrls.referrals, {"Content-Type": "application/json", "Authorization": "Bearer $accessToken"});
    }catch(e){
      logger(e.toString(),runtimeType.toString());
      throw Exception("Unable to establish connection");
    }
    if(response!=null){
      logger("Getting referrals: Response code ${response.statusCode}",runtimeType.toString());
      if(response.statusCode!>=200 && response.statusCode!<300){
        final  data=response.data["data"];
        return List.from(data).map((e) => ReferralDto.fromJson(e)).toList();
      }else{
        var data=response.data;
        throw Exception(data["message"]);
      }
    }else{
      throw Exception("Unable to establish connection");
    }
  }

  Future<ProfileDto> getProfile() async {
    logger("Getting profile", runtimeType.toString());
    Response? response;
    try{
      String accessToken=AuthService.getInstance().authToken;
      response = await my_api.get(ApiUrls.profile, {"Content-Type": "application/json", "Authorization": "Bearer $accessToken"});
    }catch(e){
      logger(e.toString(),runtimeType.toString());
      throw Exception("Unable to establish connection");
    }
    if(response!=null){
      logger("Getting profile: Response code ${response.statusCode}",runtimeType.toString());
      if(response.statusCode!>=200 && response.statusCode!<300){
        final  data=response.data["data"];
        return ProfileDto.fromJson(data);
      }else{
        var data=response.data;
        throw Exception(data["message"]);
      }
    }else{
      throw Exception("Unable to establish connection");
    }
  }


}