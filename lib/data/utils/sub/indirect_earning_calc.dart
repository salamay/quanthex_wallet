import 'package:quanthex/core/constants/sub_constants.dart';
import 'package:quanthex/data/utils/logger.dart';

class IndirectEarningCalc {

    static double calcAmountEarned({required String packageName, required int noOfPath}) {
    if (noOfPath == 0) {
      return 0;
    }
    return _pathAmount(packageName, noOfPath);
    
  }

  static double _pathAmount(String packageName, int noOfPath) {
    double levelAmount = 0;
    if (packageName == starter) {
      //this is Level 2 since level 1 is direct referrals
      if (noOfPath >=2&&noOfPath<3) {
        levelAmount = 5;
      } else if (noOfPath >=3&&noOfPath<4) {
        levelAmount = 1;
      } else if (noOfPath >=4) {
        levelAmount =  1;
      }
      return levelAmount;
    } else if (packageName == growth) {
      if (noOfPath >=2&&noOfPath<3) {
        levelAmount = 18;
      } else if (noOfPath >=3&&noOfPath<4) {
        levelAmount = 4;
      } else if (noOfPath >=4) {
        levelAmount =  4;
      }
      return levelAmount;
    } else if (packageName == advance) {
      logger("Calculating level 2 amount for package: $packageName with no of path: $noOfPath", "IndirectEarningCalc");
      if (noOfPath >= 2 && noOfPath < 3) {
        levelAmount = 40;
      } else if (noOfPath >= 3 && noOfPath < 4) {
        levelAmount = 10;
      } else if (noOfPath >= 4) {
        levelAmount = 10;
      } 
      return levelAmount;
    } else if (packageName == pro) {
      if (noOfPath >= 2 && noOfPath < 3) {
        levelAmount = 90;
      } else if (noOfPath >= 3 && noOfPath < 4) {
        levelAmount = 25;
      } else if (noOfPath >= 4) {
        levelAmount = 25;
      } 
      return levelAmount;
    } else if (packageName == mega) {
      if (noOfPath >= 2 && noOfPath < 3) {
        levelAmount = 150;
      } else if (noOfPath >= 3 && noOfPath < 4) {
        levelAmount = 55;
      } else if (noOfPath >= 4) {
        levelAmount = 55;
      } 
      return levelAmount;
    } else {
      return 0.0;
    }
  }
}
