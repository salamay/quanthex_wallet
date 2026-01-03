import 'package:flutter/cupertino.dart';
import 'package:quanthex/data/Models/mining/mining_dto.dart';
import 'package:quanthex/data/Models/staking/staking_dto.dart';
import 'package:quanthex/data/Models/staking/withdrawal.dart';
import 'package:quanthex/data/services/mining/mining_service.dart';
import 'package:quanthex/data/services/package_service/package_service.dart';
import 'package:quanthex/data/utils/logger.dart';

class MiningController extends ChangeNotifier {
  MiningService miningService = MiningService.getInstance();
  PackageService packageService = PackageService.getInstance();

  List<MiningDto> minings = [];
  List<StakingDto> stakings = [];
  List<WithdrawalDto> withdrawals = [];

  Future<void> fetchMinings() async {
    logger("Getting minings", runtimeType.toString());
    List<MiningDto> results = await miningService.getMinings();
    minings = results;
    notifyListeners();
  }

  Future<void> fetchStakings() async {
    logger("Getting stakings", runtimeType.toString());
    List<StakingDto> results = await miningService.getStakings();

    stakings = results;
    notifyListeners();
  }

  Future<void> fetchWithdrawals() async {
    logger("Getting withdrawals", runtimeType.toString());
    List<WithdrawalDto> results = await packageService.getWithdrawals();
    withdrawals = results;
    notifyListeners();
  }

  void setMinings(List<MiningDto> newMinings) {
    minings = newMinings;
    notifyListeners();
  }

  void setStakings(List<StakingDto> newStakings) {
    stakings = newStakings;
    notifyListeners();
  }

  Future<WithdrawalDto> withdraw({required String stakeId}) async {
    logger("Making withdrawal for stake id: $stakeId", runtimeType.toString());
    try {
      WithdrawalDto withdrawal = await packageService.withdraw(
        stakeId: stakeId,
      );
      withdrawals.add(withdrawal);
      // Remove the staking after successful withdrawal
      stakings.removeWhere((staking) => staking.stakingId == stakeId);
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
}
