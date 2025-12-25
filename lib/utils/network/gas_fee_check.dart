import 'dart:developer';
import '../../data/Models/assets/network_model.dart';
import '../../data/Models/network/network_model.dart';
import '../../data/controllers/balance/balance_controller.dart';

class GasFeeCheck{

  static bool gasFeeCheck({required BalanceController bCtr, required String chainCurrency,required NetworkFee fee}){
    double balance=bCtr.balances[chainCurrency]!.balanceInCrypto;
    if(balance>=fee.feeInCrypto){
      return true;
    }else{
     return false;
    }
  }

}