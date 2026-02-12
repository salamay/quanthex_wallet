import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quanthex/data/utils/logger.dart';

import '../../../core/network/Api_url.dart';
import '../../../core/network/my_api.dart';

class AuthService {
  AuthService._internal();
  final my_api = MyApi();
  String authToken = "";
  static String googleClientId = "881698135276-43cbce66k855m58v5ddmkkr9ehssetm7.apps.googleusercontent.com";
  final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  bool isGoogleSignInInitialized = false;

  static AuthService? _instance;

  static AuthService getInstance() {
    if (_instance == null) {
      logger("Creating new instance of AuthService", "AuthService");
    }
    _instance ??= AuthService._internal();
    return _instance!;
  }

  Future<void> initializeGoogleSignIn() async {
    try {
      await googleSignIn.initialize(clientId: googleClientId,serverClientId: googleClientId);
      isGoogleSignInInitialized = true;
    } catch (e) {
      logger(e.toString(), runtimeType.toString());
      isGoogleSignInInitialized = false;
    }
  }

  Future<void> getSignInOtp({required String email, required String password}) async {
    logger("Getting signIn otp", runtimeType.toString());
    Response? response;
    // String? token = await FirebaseMessaging.instance.getToken();
    var body = {"email": email, "password": password};
    try {
      response = await my_api.post(jsonEncode(body), ApiUrls.loginOtp, {"Content-Type": "application/json"});
    } catch (e) {
      logger(e.toString(), runtimeType.toString());
      throw Exception("Unable to establish connection");
    }
    if (response != null) {
      logger("Getting signIn otp: Response code ${response.statusCode}", runtimeType.toString());
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
      } else {
        var data = response.data;
        throw Exception(data["message"]);
      }
    } else {
      throw Exception("Unable to establish connection");
    }
  }

  Future<void> getRegOtp({required String email}) async {
    logger("Getting reg otp", runtimeType.toString());
    Response? response;
    // String? token = await FirebaseMessaging.instance.getToken();
    var body = {};
    try {
      response = await my_api.post(jsonEncode(body), "${ApiUrls.registerOtp}?email=$email", {"Content-Type": "application/json"});
    } catch (e) {
      logger(e.toString(), runtimeType.toString());
      throw Exception("Unable to establish connection");
    }
    if (response != null) {
      logger("Getting reg otp: Response code ${response.statusCode}", runtimeType.toString());
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
      } else {
        var data = response.data;
        throw Exception(data["message"]);
      }
    } else {
      throw Exception("Unable to establish connection");
    }
  }

  Future<String> registerUser({required String email, required String password, required String deviceId, required String deviceName, required String regVia, required String otp}) async {
    Response? response;
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      var body = {"email": email, "password": password, "device_token": token, "device_id": deviceId, "device_type": deviceName, "reg_via": regVia};
      try {
        response = await my_api.post(jsonEncode(body), "${ApiUrls.register}?otp=$otp", {"Content-Type": "application/json"});
      } catch (e) {
        logger(e.toString(), runtimeType.toString());
        throw Exception("Unable to establish connection");
      }
      if (response != null) {
        logger("Register User: Response code ${response.statusCode}", runtimeType.toString());
        if (response.statusCode! >= 200 && response.statusCode! < 300) {
          final tokenData = response.data["data"];
          authToken = tokenData ?? "";

          return tokenData;
        } else {
          var data = response.data;
          throw Exception(data["message"]);
        }
      } else {
        throw Exception("Unable to establish connection");
      }
    } else {
      throw Exception("An error occurred: FCM");
    }
  }

  Future<String> signIn({required String email, required String password, required String deviceId, required String deviceName, required String otp}) async {
    Response? response;
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      var body = {"email": email, "password": password, "device_token": token, "device_id": deviceId, "device_type": deviceName};
      try {
        response = await my_api.post(jsonEncode(body), "${ApiUrls.login}?otp=$otp", {"Content-Type": "application/json"});
      } catch (e) {
        logger(e.toString(), runtimeType.toString());
        throw Exception("Unable to establish connection");
      }
      if (response != null) {
        logger("Signing in user: Response code ${response.statusCode}", runtimeType.toString());
        if (response.statusCode! >= 200 && response.statusCode! < 300) {
          final tokenData = response.data["data"];
          authToken = tokenData ?? "";

          return tokenData;
        } else {
          var data = response.data;
          throw Exception(data["message"]);
        }
      } else {
        throw Exception("Unable to establish connection");
      }
    } else {
      throw Exception("An error occurred: FCM");
    }
  }

  Future<void> signInWithGoogle({required String idToken, required String email, required String deviceId, required String deviceName}) async {
    Response? response;
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      try {
        var body = {"id_token": idToken, "email": email, "device_token": token, "device_id": deviceId, "device_type": deviceName};
        response = await my_api.post(jsonEncode(body), ApiUrls.googleLogin, {"Content-Type": "application/json"});
      } catch (e) {
        logger(e.toString(), runtimeType.toString());
        throw Exception("Unable to establish connection");
      }
      if (response != null) {
        logger("Signing in with Google: Response code ${response.statusCode}", runtimeType.toString());
        if (response.statusCode! >= 200 && response.statusCode! < 300) {
          final tokenData = response.data["data"];
          authToken = tokenData ?? "";

          return tokenData;
        } else {
          var data = response.data;
          throw Exception(data["message"]);
        }
      } else {
        throw Exception("Unable to establish connection");
      }
    } else {
      throw Exception("An error occurred: FCM");
    }
   
  }
}
