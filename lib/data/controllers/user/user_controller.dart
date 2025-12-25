import 'package:flutter/cupertino.dart';
import 'package:quanthex/data/Models/users/profile_dto.dart';
import 'package:quanthex/data/Models/users/referral_dto.dart';
import 'package:quanthex/data/services/user/user_service.dart';

import '../../../utils/logger.dart';

class UserController extends ChangeNotifier{

  ProfileDto? profile;
  List<ReferralDto> referrals=[];
  UserService userService=UserService.getInstance();


  Future<void> getReferrals()async{
    logger("Getting referrals", runtimeType.toString());
    List<ReferralDto> results=await userService.getReferrals();
    referrals=results;
    notifyListeners();
  }

  Future<void> getProfile()async{
    logger("Getting profile", runtimeType.toString());
    ProfileDto result=await userService.getProfile();
    profile=result;
    notifyListeners();
  }
}