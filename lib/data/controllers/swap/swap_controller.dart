import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:quanthex/core/constants/crypto_constants.dart' show bsc, bsc_doge_contract, eth, pol, polygon_doge_contract, polygon_orio_contract, bsc_ada_contract;
import 'package:quanthex/core/constants/network_constants.dart';
import 'package:quanthex/core/network/Api_url.dart';
import 'package:quanthex/core/network/my_api.dart';
import 'package:quanthex/data/Models/assets/network_model.dart';
import 'package:quanthex/data/Models/assets/supported_assets.dart';
import 'package:quanthex/data/services/assets/asset_service.dart';
import 'package:quanthex/data/utils/logger.dart';

class SwapController extends ChangeNotifier {
  final _api = MyApi();

  /// CoinGecko category slugs per chain for filtering top tokens
  static const Map<String, String> _chainToCategory = {
    'ETH': 'ethereum-ecosystem',
    'BSC': 'binance-smart-chain',
    'POL': 'polygon-ecosystem',
  };

  /// CoinGecko platform IDs per chain (used to extract contract addresses)
  static const Map<String, String> _chainToPlatform = {
    'ETH': 'ethereum',
    'BSC': 'binance-smart-chain',
    'POL': 'polygon-pos',
    'ARB': 'arbitrum-one',
    'AVAX': 'avalanche',
  };

  Map<String, String> tokenImages = {};
  bool isPoolError = false;

  /// Fetches the top tokens by trading volume for [network] using CoinGecko Pro API,
  /// resolves their on-chain contract addresses, then enriches them via Moralis metadata.
  Future<List<SupportedCoin>> getTokens({
    required NetworkModel network,
    required String address,
    required String privateKey,
  }) async {
    try {
      isPoolError = false;
      String chainSymbol = network.chainSymbol.toUpperCase();
      logger("Swap: Getting tokens for $chainSymbol via CoinGecko API", runtimeType.toString());

      String category = _chainToCategory[chainSymbol] ?? 'ethereum-ecosystem';
      String platform = _chainToPlatform[chainSymbol] ?? 'ethereum';

      // ── Step 1: Fetch top coins by volume for this chain's category ──
      String marketsUrl = '${ApiUrls.coinGeckoMarkets}?vs_currency=usd&order=volume_desc&per_page=50&page=1&category=$category';

      Response? marketsResponse = await _api.get(marketsUrl, {
        'Content-Type': 'application/json',
        'x-cg-pro-api-key': MyApi.coinGecko,
      });

      if (marketsResponse == null || marketsResponse.statusCode != 200) {
        throw Exception('Failed to fetch top tokens from CoinGecko (status: ${marketsResponse?.statusCode})');
      }

      List<dynamic> coinList = marketsResponse.data;
      List<String> coinIds = coinList.map((c) => c['id'].toString()).toList();
      logger("Swap: Fetched ${coinIds.length} coins from CoinGecko markets", runtimeType.toString());

      // ── Step 2: Resolve contract addresses on the target chain ──
      // Fetch coin details in parallel; each call returns the contract address or null.
      List<Future<String?>> addressFutures = coinIds.take(50).map((coinId) async {
        try {
          String coinUrl =
              '${ApiUrls.coinGeckoCoinDetail}/$coinId'
              '?localization=false&tickers=false&market_data=false'
              '&community_data=false&developer_data=false';

          Response? coinResponse = await _api.get(coinUrl, {
            'Content-Type': 'application/json',
            'x-cg-pro-api-key': MyApi.coinGecko,
          });

          if (coinResponse != null && coinResponse.statusCode == 200) {
            Map<String, dynamic>? platforms = coinResponse.data['platforms'] != null
                ? Map<String, dynamic>.from(coinResponse.data['platforms'])
                : null;

            if (platforms != null && platforms.containsKey(platform)) {
              String contractAddr = platforms[platform].toString().trim();
              if (contractAddr.isNotEmpty) {
                return contractAddr;
              }
            }
          }
        } catch (e) {
          logger("Error fetching coin detail for $coinId: $e", runtimeType.toString());
        }
        return null;
      }).toList();

      List<String?> results = await Future.wait(addressFutures);

      // Filter out nulls/empties and preserve volume ordering
      List<String> addresses = results
          .where((a) => a != null && a.isNotEmpty)
          .cast<String>()
          .take(40)
          .toList();

      logger("Swap: Resolved ${addresses.length} contract addresses on $platform", runtimeType.toString());

      // ── Step 3: Append chain-specific tokens that should always appear ──
      if (chainSymbol == bsc) {
        if (!addresses.any((a) => a.toLowerCase() == bsc_doge_contract.toLowerCase())) {
          addresses.add(bsc_doge_contract);
        }
        if (!addresses.any((a) => a.toLowerCase() == bsc_ada_contract.toLowerCase())) {
          addresses.add(bsc_ada_contract);
        }
      } else if (chainSymbol == pol) {
        if (!addresses.any((a) => a.toLowerCase() == polygon_orio_contract.toLowerCase())) {
          addresses.add(polygon_orio_contract);
        }
        if (!addresses.any((a) => a.toLowerCase() == polygon_doge_contract.toLowerCase())) {
          addresses.add(polygon_doge_contract);
        }
      }

      logger("Swap: Final address list (${addresses.length}): $addresses", runtimeType.toString());

      // ── Step 4: Enrich with Moralis metadata (existing flow) ──
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
