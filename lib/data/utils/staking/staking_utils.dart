class StakingUtils {
  
  String mapMonthsToPlanName(double amount) {
    return "Plan $amount";
  }

  double calculateDoublReward({required int noOfReferrals, required int noOfTimePayed, required double stakedAmount}) {
    if (noOfReferrals % 6 == 0) {
      print('$noOfReferrals is a multiple of 6');
      int div = (noOfReferrals / 6).toInt();
      if (noOfTimePayed < div) {
        return stakedAmount * 2;
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  }
}
