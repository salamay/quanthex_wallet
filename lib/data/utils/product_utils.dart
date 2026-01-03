class ProductUtils {
  // Hashrate values for different levels
  static const double LEVEL_ONE_HASHRATE = 187898.987;
  static const double LEVEL_TWO_HASHRATE = 375797.974;
  static const double LEVEL_THREE_HASHRATE = 563696.961;
  static const double LEVEL_FOUR_HASHRATE = 751595.948;
  static const double LEVEL_FIVE_HASHRATE = 939494.935;
  static const double LEVEL_SIX_HASHRATE = 1127393.923;

  /// Calculate hashrate based on number of referrals
  ///
  /// [noOfReferrals] - The number of referrals
  /// Returns the calculated hashrate
  static double getHashRate(int noOfReferrals) {
    return noOfReferrals * LEVEL_ONE_HASHRATE;
  }
}
