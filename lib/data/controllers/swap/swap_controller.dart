import 'package:flutter/cupertino.dart';
import 'package:quanthex/core/constants/crypto_constants.dart';
import 'package:quanthex/core/constants/network_constants.dart';
import 'package:quanthex/data/Models/assets/network_model.dart';
import 'package:quanthex/data/Models/assets/supported_assets.dart';
import 'package:quanthex/data/services/assets/asset_service.dart';
import 'package:quanthex/data/utils/logger.dart';

class SwapController extends ChangeNotifier {
  Map<String, String> tokenImages = {};
  bool isPoolError = false;

  /// Maps chain IDs to their hardcoded top-30 token address lists.
  static const Map<int, List<String>> _chainTokens = {
    chain_id_eth: ethTokenAddresses,
    chain_id_bsc: bscTokenAddresses,
    chain_id_pol: polygonTokenAddresses,
  };

  /// Returns popular tokens for [network] by looking up the hardcoded
  /// top-30 address list and enriching them via Moralis metadata.
  Future<List<SupportedCoin>> getTokens({
    required NetworkModel network,
    required String address,
    required String privateKey,
  }) async {
    try {
      isPoolError = false;
      String chainSymbol = network.chainSymbol.toUpperCase();
      int chainId = network.chainId;
      logger("Swap: Getting tokens for $chainSymbol (chainId $chainId)", runtimeType.toString());

      List<String>? addresses = _chainTokens[chainId];
      if (addresses == null || addresses.isEmpty) {
        throw Exception('No default token list for chain $chainSymbol (chainId $chainId)');
      }

      logger("Swap: Using ${addresses.length} hardcoded addresses for $chainSymbol", runtimeType.toString());

      // ── Enrich with Moralis metadata (existing flow) ──
      List<SupportedCoin> assets = await AssetService.getInstance().scanTokens(
        network: network,
        addresses: addresses,
        chainSymbol: chainSymbol,
        walletAddress: address,
        privateKey: privateKey,
      );
      return assets;
    } catch (e) {
      logger("${network.chainSymbol}: $e", runtimeType.toString());
      isPoolError = true;
      notifyListeners();
      throw Exception(e);
    }
  }
}
