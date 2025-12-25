import 'package:dio/dio.dart';
import 'package:quanthex/core/network/Api_url.dart';
import 'package:quanthex/data/Models/mining/mining_dto.dart';

import '../../../core/network/my_api.dart';
import '../../../utils/logger.dart';
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


  Future<List<MiningDto>> getMinings()async{
    logger("Getting minings", runtimeType.toString());
    Response? response;
    try{
      String accessToken=AuthService.getInstance().authToken;
      response = await my_api.get(ApiUrls.minings, {"Content-Type": "application/json", "Authorization": "Bearer $accessToken"});
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


}