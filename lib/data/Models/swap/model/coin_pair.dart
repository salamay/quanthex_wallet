import 'package:quanthex/data/Models/assets/supported_assets.dart';

class CoinPair{
  SupportedCoin token0;
  SupportedCoin token1;
  SupportedCoin? weth;
  double fee;
  String poolAddress;
  double token0Price;
  double token1Price;
  double volumeToken0;
  double volumeToken1;
  double volumeUSD;
  BigInt liquidity;
  bool isIntermediary;
  String intermediaryContract;
  BigInt intermediaryPoolFee;

  CoinPair({
    required this.token0,
    required this.token1,
    this.weth,
    required this.fee,
    required this.poolAddress,
    required this.token0Price,
    required this.token1Price,
    required this.volumeToken0,
    required this.volumeToken1,
    required this.volumeUSD,
    required this.liquidity,
    required this.isIntermediary,
    required this.intermediaryContract,
    required this.intermediaryPoolFee,
  });
}