import 'package:quanthex/data/Models/assets/supported_assets.dart';
import 'package:uniswap_flutter_v3/uniswap/domain/entities/pool.dart';

class CoinPair{
  SupportedCoin token0;
  SupportedCoin token1;
  Pool pool;

  CoinPair({
    required this.token0,
    required this.token1,
    required this.pool,
  });
}