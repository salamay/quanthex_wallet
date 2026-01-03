import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:quanthex/core/network/Api_url.dart';
import 'package:quanthex/data/Models/assets/supported_assets.dart';
import 'package:quanthex/data/Models/mining/subscription_payload.dart';
import 'package:quanthex/data/Models/staking/staking_payload.dart';
import 'package:quanthex/data/Models/subscription/subscription_dto.dart';
import 'package:quanthex/data/services/auth/auth_service.dart';

import '../../../core/network/my_api.dart';
import '../../utils/logger.dart';
import '../../Models/staking/staking_dto.dart';
import '../../Models/staking/withdrawal.dart';

class PackageService {
  PackageService._internal();
  static PackageService? _instance;
  final my_api = MyApi();

  static PackageService getInstance() {
    if (_instance == null) {
      logger("Creating new instance of SubService", "SubService");
    }
    _instance ??= PackageService._internal();
    return _instance!;
  }

  Future<SubscriptionDto> makeSubscription({
    required SubscriptionPayload sub,
    required SupportedCoin paymentToken,
    required SupportedCoin rewardToken,
    required String signedTx,
    required String rpc,
  }) async {
    logger(
      "Making subscription for ${sub.subPackageName} using ${paymentToken.symbol} to receive rewards in ${rewardToken.symbol}",
      "SubService",
    );
    sub.subChainId = paymentToken.networkModel!.chainId;
    sub.subAssetContract = paymentToken.contractAddress;
    sub.subAssetSymbol = paymentToken.symbol;
    sub.subAssetName = paymentToken.name;
    sub.subAssetDecimals = paymentToken.decimal;
    sub.subAssetImage = paymentToken.image;
    sub.subRewardContract = paymentToken.contractAddress;
    sub.subRewardChainId = rewardToken.networkModel!.chainId;
    sub.subRewardAssetName = rewardToken.name;
    sub.subRewardAssetSymbol = rewardToken.symbol;
    sub.subRewardAssetImage = rewardToken.image;
    sub.subRewardAssetDecimals = rewardToken.decimal;
    sub.subDuration = DateTime.now()
        .add(Duration(days: 365))
        .millisecondsSinceEpoch
        .toString();
    sub.subSignedTx = signedTx;
    sub.subRpc = rpc;
    Response? response;
    try {
      String accessToken = AuthService.getInstance().authToken;
      var body = sub.toJson();
      response = await my_api.post(jsonEncode(body), ApiUrls.subscribe, {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      });
    } catch (e) {
      logger(e.toString(), runtimeType.toString());
      throw Exception("Unable to establish connection");
    }
    if (response != null) {
      logger(
        "Making subscription: Response code ${response.statusCode}",
        runtimeType.toString(),
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final data = response.data["data"];
        return SubscriptionDto.fromJson(data);
      } else {
        var data = response.data;
        throw Exception(data["message"]);
      }
    } else {
      throw Exception("Unable to establish connection");
    }
  }

  Future<StakingDto> stake({required StakingPayload stake}) async {
    logger("Making staking", runtimeType.toString());
    Response? response;
    try {
      String accessToken = AuthService.getInstance().authToken;
      var body = stake.toJson();
      response = await my_api.post(jsonEncode(body), ApiUrls.stake, {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      });
    } catch (e) {
      logger(e.toString(), runtimeType.toString());
      throw Exception("Unable to establish connection");
    }
    if (response != null) {
      logger(
        "Making staking: Response code ${response.statusCode}",
        runtimeType.toString(),
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final data = response.data["data"];
        return StakingDto.fromJson(data);
      } else {
        var data = response.data;
        throw Exception(data["message"]);
      }
    } else {
      throw Exception("Unable to establish connection");
    }
  }

  Future<WithdrawalDto> withdraw({required String stakeId}) async {
    logger("Making withdrawal for stake id: $stakeId", runtimeType.toString());
    Response? response;
    try {
      String accessToken = AuthService.getInstance().authToken;
      var body = {"staking_id": stakeId};
      response = await my_api.post(jsonEncode(body), ApiUrls.withdraw, {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      });
    } catch (e) {
      logger(e.toString(), runtimeType.toString());
      throw Exception("Unable to establish connection");
    }
    if (response != null) {
      logger(
        "Making withdrawal: Response code ${response.statusCode}",
        runtimeType.toString(),
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final data = response.data["data"];
        return WithdrawalDto.fromJson(data);
      } else {
        var data = response.data;
        throw Exception(data["message"]);
      }
    } else {
      throw Exception("Unable to establish connection");
    }
  }

  Future<List<WithdrawalDto>> getWithdrawals() async {
    logger("Getting withdrawals", runtimeType.toString());
    Response? response;
    try {
      String accessToken = AuthService.getInstance().authToken;
      response = await my_api.get(ApiUrls.withdrawals, {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      });
    } catch (e) {
      logger(e.toString(), runtimeType.toString());
      throw Exception("Unable to establish connection");
    }
    if (response != null) {
      logger(
        "Getting withdrawals: Response code ${response.statusCode}",
        runtimeType.toString(),
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final data = response.data["data"];
        return List.from(data).map((e) => WithdrawalDto.fromJson(e)).toList();
      } else {
        var data = response.data;
        throw Exception(data["message"]);
      }
    } else {
      throw Exception("Unable to establish connection");
    }
  }
}
