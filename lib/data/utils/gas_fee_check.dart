import 'dart:developer';

import 'package:quanthex/data/Models/assets/network_model.dart';
import 'package:quanthex/data/Models/network/network_model.dart';
import 'package:quanthex/data/controllers/balance/balance_controller.dart';

class GasFeeCheck {
  static bool gasFeeCheck({required BalanceController bCtr, required String chainCurrency, required double feeInCrypto}) {
    double balance = bCtr.balances[chainCurrency]!.balanceInCrypto;
    if (balance >= feeInCrypto) {
      return true;
    }
    return false;
  }
}
