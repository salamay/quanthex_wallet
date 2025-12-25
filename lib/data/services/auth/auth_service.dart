import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quanthex/utils/logger.dart';

import '../../../core/network/Api_url.dart';
import '../../../core/network/my_api.dart';

class AuthService{
  AuthService._internal();
  final my_api = MyApi();
  String authToken="";
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;



  static AuthService? _instance;

  static AuthService getInstance() {
    if(_instance==null){
      logger("Creating new instance of AuthService","AuthService");
    }
    _instance ??= AuthService._internal();
    return _instance!;
  }

  Future<String>registerUser({required String email, required String password,required String deviceId,required String deviceName,required String referralCode,required String regVia}) async{
    Response? response;
    // String? token = await FirebaseMessaging.instance.getToken();
    String token="";
    if(token!=null){
      var body={
        "email":email,
        "password":password,
        "device_token":token,
        "device_id":deviceId,
        "device_type":deviceName,
        "reg_via":regVia,
        "referral_code":referralCode,
      };
      try{
        response = await my_api.post(jsonEncode(body),ApiUrls.register, {"Content-Type": "application/json"});
      }catch(e){
        logger(e.toString(),runtimeType.toString());
        throw Exception("Unable to establish connection");
      }
      if(response!=null){
        logger("Register User: Response code ${response.statusCode}",runtimeType.toString());
        if(response.statusCode!>=200 && response.statusCode!<300){
          final  tokenData=response.data["data"];
          authToken= tokenData??"";

          return tokenData;
        }else{
          var data=response.data;
          throw Exception(data["message"]);
        }
      }else{
        throw Exception("Unable to establish connection");
      }
    }else{
      throw Exception("An error occurred: FCM");
    }
  }

  Future<String>signIn({required String email, required String password,required String deviceId,required String deviceName}) async{
    Response? response;
    // String? token = await FirebaseMessaging.instance.getToken();
    String token="";
    if(token!=null){
      var body={
        "email":email,
        "password":password,
        "device_token":token,
        "device_id":deviceId,
        "device_type":deviceName,
      };
      try{
        response = await my_api.post(jsonEncode(body),ApiUrls.login, {"Content-Type": "application/json"});
      }catch(e){
        logger(e.toString(),runtimeType.toString());
        throw Exception("Unable to establish connection");
      }
      if(response!=null){
        logger("Signing in user: Response code ${response.statusCode}",runtimeType.toString());
        if(response.statusCode!>=200 && response.statusCode!<300){
          final  tokenData=response.data["data"];
          authToken= tokenData??"";

          return tokenData;
        }else{
          var data=response.data;
          throw Exception(data["message"]);
        }
      }else{
        throw Exception("Unable to establish connection");
      }
    }else{
      throw Exception("An error occurred: FCM");
    }
  }

  Future<void> authWithGoogle()async{

  }
}