import 'package:quanthex/core/constants/sub_constants.dart';

class SubUtils{

  static int maxOfReferrals=1296;


  static double STARTER_AMOUNT_MAX=700.0;
  static double GROWTH_AMOUNT_MAX=4000.0;
  static double ADVANCE_AMOUNT_MAX=7000.0;
  static double PRO_AMOUNT_MAX=15000.0;


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
        levelAmount=100;
      }else if(noOfReferrals>6&&noOfReferrals<=36){
        levelAmount=150;
      }else if(noOfReferrals>36&&noOfReferrals<=216){
        levelAmount=200;
      }else if(noOfReferrals>216&&noOfReferrals<1296){
        levelAmount=250;
      }else if(noOfReferrals>1296){
        levelAmount=700;
      }else{
        return 0;
      }
      return levelAmount;
    }else if(packageName==growth){
      if(noOfReferrals<=6){
        levelAmount=400;
      }else if(noOfReferrals>6&&noOfReferrals<=36){
        levelAmount=600;
      }else if(noOfReferrals>36&&noOfReferrals<=216){
        levelAmount=1000;
      }else if(noOfReferrals>216&&noOfReferrals<1296){
        levelAmount=2000;
      }else if(noOfReferrals>1296){
        levelAmount=4000;
      }else{
        return 0;
      }
      return levelAmount;
    }else if(packageName==advance){
      if(noOfReferrals<=6){
        levelAmount=1000;
      }else if(noOfReferrals>6&&noOfReferrals<=36){
        levelAmount=1500;
      }else if(noOfReferrals>36&&noOfReferrals<=216){
        levelAmount=2000;
      }else if(noOfReferrals>216&&noOfReferrals<1296){
        levelAmount=2500;
      }else if(noOfReferrals>1296){
        levelAmount=7000;
      }else{
        return 0;
      }
      return levelAmount;
    }else if(packageName==pro){
      if(noOfReferrals<=6){
        levelAmount=2000;
      }else if(noOfReferrals>6&&noOfReferrals<=36){
        levelAmount=3000;
      }else if(noOfReferrals>36&&noOfReferrals<=216){
        levelAmount=4000;
      }else if(noOfReferrals>216&&noOfReferrals<1296){
        levelAmount=6000;
      }else if(noOfReferrals>1296){
        levelAmount=15000;
      }else{
        return 0;
      }
      return levelAmount;
    }else{
      return 0.0;
    }
  }
}