import 'package:flutter/cupertino.dart';
import 'package:quanthex/data/Models/mining/mining_dto.dart';
import 'package:quanthex/data/Models/mining/mining_payment_dto.dart';
import 'package:quanthex/data/Models/staking/staking_dto.dart';
import 'package:quanthex/data/Models/staking/staking_referral_dto.dart';
import 'package:quanthex/data/Models/staking/withdrawal.dart';
import 'package:quanthex/data/Models/users/referral_dto.dart';
import 'package:quanthex/data/services/mining/mining_service.dart';
import 'package:quanthex/data/services/package_service/package_service.dart';
import 'package:quanthex/data/utils/logger.dart';

class MiningController extends ChangeNotifier {
  MiningService miningService = MiningService.getInstance();
  PackageService packageService = PackageService.getInstance();
  bool fetchingMinings = false;
  bool fetchingMiningError = false;
  bool fetchingStakings = false;
  bool fetchingStakingsError = false;
  Map<String, List<ReferralDto>> miningDirectReferrals = {};
  Map<String, List<ReferralDto>> miningIndirectReferrals = {};
  Map<String, List<MiningDto>> minings = {};
  Map<String, List<StakingDto>> stakings = {};
  List<WithdrawalDto> withdrawals = [];
  Map<String, List<StakingReferralDto>> stakingReferrals = {};

  // Mining payments state
  Map<String, List<MiningPaymentDto>> miningPayments = {};
  Map<String, int> miningPaymentsTotals = {};
  Map<String, double> miningTotalAmountPaid = {};
  Map<String, int> miningPaymentsPages = {};
  Map<String, int> miningPaymentsTotalPages = {};
  bool fetchingMiningPayments = false;
  bool fetchingMiningPaymentsError = false;
  bool loadingMoreMiningPayments = false;

  Future<void> fetchMiningPayments(String minId, {bool refresh = false}) async {
    try {
      if (refresh) {
        miningPayments[minId] = [];
        miningPaymentsPages[minId] = 1;
      }
      fetchingMiningPayments = true;
      fetchingMiningPaymentsError = false;
      notifyListeners();

      int page = refresh ? 1 : (miningPaymentsPages[minId] ?? 1);
      Map<String, dynamic> result = await miningService.getMiningPayments(minId: minId, page: page);
      List<MiningPaymentDto> payments = result['payments'];

      if (refresh) {
        miningPayments[minId] = payments;
      } else {
        miningPayments[minId] = [...(miningPayments[minId] ?? []), ...payments];
      }
      miningPaymentsTotals[minId] = result['total'];
      miningTotalAmountPaid[minId] = result['totalAmountPaid'] ?? 0.0;
      miningPaymentsPages[minId] = result['page'];
      miningPaymentsTotalPages[minId] = result['totalPages'];

      fetchingMiningPayments = false;
      fetchingMiningPaymentsError = false;
      notifyListeners();
    } catch (e) {
      logger("Error fetching mining payments: $e", runtimeType.toString());
      fetchingMiningPayments = false;
      fetchingMiningPaymentsError = true;
      notifyListeners();
    }
  }

  Future<void> loadMoreMiningPayments(String minId) async {
    int currentPage = miningPaymentsPages[minId] ?? 1;
    int totalPages = miningPaymentsTotalPages[minId] ?? 1;
    if (loadingMoreMiningPayments || currentPage >= totalPages) return;

    try {
      loadingMoreMiningPayments = true;
      notifyListeners();

      int nextPage = currentPage + 1;
      Map<String, dynamic> result = await miningService.getMiningPayments(minId: minId, page: nextPage);
      List<MiningPaymentDto> payments = result['payments'];

      miningPayments[minId] = [...(miningPayments[minId] ?? []), ...payments];
      miningPaymentsPages[minId] = result['page'];
      miningPaymentsTotalPages[minId] = result['totalPages'];
      miningPaymentsTotals[minId] = result['total'];

      loadingMoreMiningPayments = false;
      notifyListeners();
    } catch (e) {
      logger("Error loading more mining payments: $e", runtimeType.toString());
      loadingMoreMiningPayments = false;
      notifyListeners();
    }
  }

  Future<void> fetchMinings(String walletAddress) async {
    try {
     fetchingMinings = true;
     fetchingMiningError = false;
      notifyListeners();
      logger("Getting minings", runtimeType.toString());
      List<MiningDto> results = await miningService.getMinings(walletAddress);
      minings[walletAddress] = results;
      fetchingMinings = false;
      fetchingMiningError = false;
      notifyListeners();
    } catch (e) {
      logger("Error fetching minings: $e", runtimeType.toString());
      fetchingMinings = false;
      fetchingMiningError = true;
      notifyListeners();
      throw Exception(e);
    }
  }

  Future<void> getSubscriptionReferrals(String miningSubscriptionId) async {
    logger("Getting referrals", runtimeType.toString());
    List<ReferralDto> results = await miningService.getSubscriptionDirectReferrals(miningSubscriptionId);
    miningDirectReferrals[miningSubscriptionId] = results;
    List<ReferralDto> indirectResults = await miningService.getSubscriptionIndirectReferrals(miningSubscriptionId);
    miningIndirectReferrals[miningSubscriptionId] = indirectResults;
    notifyListeners();
  }

  Future<void> fetchStakings(String walletAddress, String stakingStatus) async {
   try {
    fetchingStakings = true;
    fetchingStakingsError = false;
      notifyListeners();
      logger("Getting stakings", runtimeType.toString());
      List<StakingDto> results = await miningService.getStakings(walletAddress, stakingStatus);
      stakings[walletAddress] = results;
      fetchingStakings = false;
      fetchingStakingsError = false;
      notifyListeners();
   } catch (e) {
    logger("Error fetching stakings: $e", runtimeType.toString());
    fetchingStakings = false;
    fetchingStakingsError = true;
    notifyListeners();
    throw Exception(e);
   }
  }

  Future<void> fetchWithdrawals(String stakingId) async {
    logger("Getting withdrawals", runtimeType.toString());
    List<WithdrawalDto> results = await packageService.getWithdrawals(stakingId);
    withdrawals = results;
    notifyListeners();
  }
  Future<void> fetchReferrals(String stakingId) async {
    logger("Getting referrals", runtimeType.toString());
    List<StakingReferralDto> results = await miningService.getStakingReferrals(stakingId: stakingId);
    stakingReferrals[stakingId] = results;
    notifyListeners();
  }

  void setMinings(String walletAddress, List<MiningDto> newMinings) {
    minings[walletAddress] = newMinings;
    notifyListeners();
  }

  void setStakings(String walletAddress, List<StakingDto> newStakings) {
    stakings[walletAddress] = newStakings;
    notifyListeners();
  }

  Future<WithdrawalDto> withdraw({required String stakeId, required String walletAddress}) async {
    logger("Making withdrawal for stake id: $stakeId", runtimeType.toString());
    try {
      WithdrawalDto withdrawal = await packageService.withdraw(
        stakeId: stakeId,
      );
      withdrawals.add(withdrawal);
      // Remove the staking after successful withdrawal
      stakings[walletAddress]?.removeWhere((staking) => staking.stakingId == stakeId);
      notifyListeners();
      return withdrawal;
    } catch (e) {
      logger("Error making withdrawal: $e", runtimeType.toString());
      rethrow;
    }
  }

  void addWithdrawal(WithdrawalDto withdrawal) {
    withdrawals.add(withdrawal);
    notifyListeners();
  }

  void removeWithdrawal(String withdrawalId) {
    withdrawals.removeWhere(
      (withdrawal) => withdrawal.withdrawalId == withdrawalId,
    );
    notifyListeners();
  }
  void clear(){
    minings={};
    stakings={};
    withdrawals=[];
  }
  void refresh() {
    notifyListeners();
  }
}
