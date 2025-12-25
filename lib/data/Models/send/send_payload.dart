

import '../assets/supported_assets.dart';
import '../network/network_model.dart';


class SendPayload{
  SupportedCoin? asset;
  double? amount;
  double? amountInFiat;
  String? recipient_address;
  NetworkFee? fee;
  String? txId;



  SendPayload({this.asset, this.amount, this.recipient_address, this.fee,this.amountInFiat,this.txId});

  SendPayload copyWith({
    SupportedCoin? asset,
    double? amount,
    double? amountInFiat,
    String? recipient_address,
    NetworkFee? fee,
    String? txId,
    double? percentage,
    String? adminAddress
  }){
    return SendPayload(
        asset: asset??this.asset,
        amount: amount??this.amount,
        amountInFiat: amountInFiat??this.amountInFiat,
        recipient_address: recipient_address??this.recipient_address,
        fee: fee??this.fee,
        txId: txId??this.txId
    );
  }

}