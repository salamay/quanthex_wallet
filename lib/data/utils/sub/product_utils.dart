import 'package:quanthex/core/constants/sub_constants.dart';

class ProductUtils {
  // Hashrate values for different levels
  static const double LEVEL_ZERO_HASHRATE = 93949.4935;
  static const double LEVEL_ONE_HASHRATE = 187898.987;
  static const double LEVEL_TWO_HASHRATE = 375797.974;
  static const double LEVEL_THREE_HASHRATE = 563696.961;
  static const double LEVEL_FOUR_HASHRATE = 751595.948;

  static const int LEVEL_ONE_REFERRALS = 6;
  static const int LEVEL_TWO_REFERRALS = 36;
  static const int LEVEL_THREE_REFERRALS = 216;


  static const starterFactor = 0.2;
    static const growthFactor = 0.3;
    static const advanceFactor = 0.4;
    static const proFactor = 0.5;
    static const megaFactor = 0.6;

  /// Calculate hashrate based on number of referrals
  ///
  /// [noOfReferrals] - The number of referrals
  /// Returns the calculated hashrate
  static double getHashRate({required int noOfReferrals,required String packageName}){
    double factor = 1.2;
    if (packageName == starter) {
      factor = starterFactor;
    } else if (packageName == growth) {
      factor = growthFactor;
    } else if (packageName == advance) {
      factor = advanceFactor;
    } else if (packageName == pro) {
      factor = proFactor;
    } else if (packageName == mega) {
      factor = megaFactor;
    }
        if(noOfReferrals==0){
          //Only apply factor if no referrals is zero because we want the hash rate to increase lil bit for zero referrals
            return LEVEL_ZERO_HASHRATE*factor;
        }else if(noOfReferrals>0 && noOfReferrals<=6){
            return LEVEL_ONE_HASHRATE ;
        }else if(noOfReferrals>6 && noOfReferrals<=36){
            return LEVEL_TWO_HASHRATE ;
        } else if(noOfReferrals>36 && noOfReferrals<=216){
            return LEVEL_THREE_HASHRATE ;
        }
        else if(noOfReferrals>216 && noOfReferrals<=324){
            return LEVEL_FOUR_HASHRATE ;
        }else{
            return LEVEL_ZERO_HASHRATE;
        }

    }
}
