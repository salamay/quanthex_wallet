import 'package:flutter/material.dart';
import 'package:quanthex/core/constants/network_constants.dart';
import 'package:uniswap_flutter_v3/uniswap/uniswap_v3.dart';

import '../../../core/network/Api_url.dart';
class ChainParse  {


  static String getMoralisChainName(String chainSymbol) {
    switch (chainSymbol) {
      case 'BSC':
        return 'bsc';
      case 'ETH':
        return 'eth';
      case 'POL':
        return 'polygon';
    // Add more cases for other chains as needed
      case 'ARB':
        return 'arbitrum';
      case 'AVAX':
        return 'avalanche';
      default:
        throw Exception('Unsupported chain: $chainSymbol');
    }
  }

  static UniswapV3 getChainId(int chainId) {
    switch (chainId) {
      case chain_id_bsc:
        return UniswapV3(
          rpcUrl: ApiUrls.BSCRpc,
          chainId: chain_id_bsc,
        );
      case chain_id_pol:
        return UniswapV3(
          rpcUrl: ApiUrls.polygonRpc,
          chainId: chain_id_pol,
        );
      case chain_id_eth:
        return UniswapV3(
          rpcUrl: ApiUrls.ETHRpc,
          chainId: chain_id_eth,
        );
      default:
        throw Exception('Unsupported chain: $chainId');
    }
  }
}
