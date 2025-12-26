import 'package:shared_preferences/shared_preferences.dart';

class MyLocalStorage{

  Future<void> setIsDark(bool status)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("theme", status);
  }

  Future<void> setOtpTimeLeft(String key,int timeLeft)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key.toString(), timeLeft);
  }

  Future<int> getOtpTimeLeft(String key)async{
    final prefs = await SharedPreferences.getInstance();
    int value= prefs.getInt(key.toString())??0;
    return value;
  }

}