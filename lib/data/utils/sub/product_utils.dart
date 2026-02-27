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


  static const starterFactor = 1.00;
    static const growthFactor = 2.00;
    static const advanceFactor = 3.00;
    static const proFactor = 4.00;
    static const megaFactor = 5.00;

  /// Calculate hashrate based on number of referrals
  ///
  /// [noOfReferrals] - The number of referrals
  /// Returns the calculated hashrate
  static double getHashRate({required int noOfReferrals,required String packageName}){
    double factor = 1.0;
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
            return LEVEL_ZERO_HASHRATE*factor;
        }else if(noOfReferrals>0 && noOfReferrals<=6){
            return LEVEL_ONE_HASHRATE * factor;
        }else if(noOfReferrals>6 && noOfReferrals<=36){
            return LEVEL_TWO_HASHRATE * factor;
        } else if(noOfReferrals>36 && noOfReferrals<=216){
            return LEVEL_THREE_HASHRATE * factor;
        }
        else if(noOfReferrals>216 && noOfReferrals<=324){
            return LEVEL_FOUR_HASHRATE * factor;
        }else{
            return LEVEL_ZERO_HASHRATE;
        }
    }
}
