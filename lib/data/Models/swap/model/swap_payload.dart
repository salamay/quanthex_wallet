

import 'package:quanthex/data/Models/network/network_model.dart';

import 'coin_pair.dart';

class SwapPayload{
  CoinPair pair;
  double? userAmount;
  //this value is used in the case of swapping a token to a native token, the amount of wrapped native token to be withdraw
  double? amountIn;
  double? amountOut;
  double? amountOutMin;
  NetworkFee? networkFee;
  BigInt? poolFee;
  String? walletAddress;
  String? privateKey;

  SwapPayload({ this.walletAddress, this.privateKey, required this.pair, this.userAmount, this.amountIn,this.amountOut,this.amountOutMin, this.networkFee,this.poolFee});
  SwapPayload copyWith({
    String? walletAddress,
    String? privateKey,
    CoinPair? pair,
    double? userAmount,
    double? amountIn,
    double? amountOut,
    double? amountOutMin,
    NetworkFee? networkFee,
    BigInt? poolFee,
  }){
    return SwapPayload(
      walletAddress: walletAddress??this.walletAddress,
      privateKey: privateKey??this.privateKey,
      pair: pair??this.pair,
      userAmount: userAmount??this.userAmount,
      amountIn: amountIn??this.amountIn,
      amountOut: amountOut??this.amountOut,
      amountOutMin: amountOutMin??this.amountOutMin,
      networkFee: networkFee??this.networkFee,
      poolFee: poolFee??this.poolFee,
    );
  }

}