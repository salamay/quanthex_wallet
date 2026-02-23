import 'package:quanthex/core/constants/sub_constants.dart';

class SubUtils{



  static double STARTER_AMOUNT_MAX=498.0;
  static double GROWTH_AMOUNT_MAX=1914.0;
  static double ADVANCE_AMOUNT_MAX=4602.0;
  static double PRO_AMOUNT_MAX=10644.0;
  static double MEGA_AMOUNT_MAX = 21300.0;



  static double calculateRewardPotential(String packageName){
    if(packageName==starter){
      return STARTER_AMOUNT_MAX;
    }else if(packageName==growth){
      return GROWTH_AMOUNT_MAX;
    }else if(packageName==advance){
      return ADVANCE_AMOUNT_MAX;
    }else if(packageName==pro){
      return PRO_AMOUNT_MAX;
    }else{
      return 0.0;
    }
  }

  static double calcAmountEarned({required String packageName, required int noOfReferrals}){
    if(noOfReferrals==0){
      double baseDefault = 0.1;
      if (packageName == starter) {
        return baseDefault * 2;
      } else if (packageName == growth) {
        return baseDefault * 4;
      } else if (packageName == advance) {
        return baseDefault * 6;
      } else if (packageName == pro) {
        return baseDefault * 8;
      } else {
        return 0.0;
      }
    }
    if(packageName==starter){
      double totalReward= STARTER_AMOUNT_MAX;
      return calPrice(noOfReferrals: noOfReferrals, totalReward: totalReward, packageName: packageName);
    }else if(packageName==growth){
      double totalReward= GROWTH_AMOUNT_MAX;
      return calPrice(noOfReferrals: noOfReferrals, totalReward: totalReward, packageName: packageName);
    }else if(packageName==advance){
      double totalReward= ADVANCE_AMOUNT_MAX;
      return calPrice(noOfReferrals: noOfReferrals, totalReward: totalReward, packageName: packageName);
    }else if(packageName==pro){
      double totalReward= ADVANCE_AMOUNT_MAX;
      return calPrice(noOfReferrals: noOfReferrals, totalReward: totalReward, packageName: packageName);
    }else{
      return 0.0;
    }
  }

  static double calPrice({required int noOfReferrals, required double totalReward,required String packageName}){
    int denom=6;
    double rewardPotential=_levelAmount(packageName,noOfReferrals);
    if(noOfReferrals<=6){
      denom=6;
    }else if(noOfReferrals>6&&noOfReferrals<=36){
      denom=36;
    }else if(noOfReferrals>36&&noOfReferrals<=216){
      denom=216;
    }else if(noOfReferrals>216&&noOfReferrals<=1296){
      denom=1296;
    }else{
      return 0;
    }
    return (noOfReferrals/denom)*rewardPotential;
  }

  static double _levelAmount(String packageName, int noOfReferrals){
    double levelAmount=100;
    if(packageName==starter){
      if(noOfReferrals<=6){
        levelAmount=102;
      }else if(noOfReferrals>6&&noOfReferrals<=36){
        levelAmount=180;
      }else if(noOfReferrals>36&&noOfReferrals<=216){
        levelAmount=216;
      }else if(noOfReferrals>=216&&noOfReferrals<1296){
        levelAmount=498;
      }else{
        return 0;
      }
      return levelAmount;
    }else if(packageName==growth){
      if(noOfReferrals<=6){
        levelAmount=402;
      }else if(noOfReferrals>6&&noOfReferrals<=36){
        levelAmount=648;
      }else if(noOfReferrals>36&&noOfReferrals<=216){
        levelAmount=864;
      }else if(noOfReferrals>=216&&noOfReferrals<1296){
        levelAmount=1914;
      }else{
        return 0;
      }
      return levelAmount;
    }else if(packageName==advance){
      if(noOfReferrals<=6){
        levelAmount=1002;
      }else if(noOfReferrals>6&&noOfReferrals<=36){
        levelAmount=1440;
      }else if(noOfReferrals>36&&noOfReferrals<=216){
        levelAmount=2160;
      }else if(noOfReferrals>=216&&noOfReferrals<1296){
        levelAmount=4602;
      }else{
        return 0;
      }
      return levelAmount;
    }else if(packageName==pro){
      if(noOfReferrals<=6){
        levelAmount=2004;
      }else if(noOfReferrals>6&&noOfReferrals<=36){
        levelAmount=3240;
      }else if(noOfReferrals>36&&noOfReferrals<=216){
        levelAmount=5400;
      }else if(noOfReferrals>=216&&noOfReferrals<1296){
        levelAmount=10644;
      }else{
        return 0;
      }
      return levelAmount;
    } else if (packageName == mega) {
      if (noOfReferrals <= 6) {
        levelAmount = 4020;
      } else if (noOfReferrals > 6 && noOfReferrals <= 36) {
        levelAmount = 5400;
      } else if (noOfReferrals > 36 && noOfReferrals <= 216) {
        levelAmount = 11880;
      } else if (noOfReferrals >= 216 && noOfReferrals < 1296) {
        levelAmount = 21300;
      } else {
        return 0;
      }
      return levelAmount;
    }else{
      return 0.0;
    }
  }
}