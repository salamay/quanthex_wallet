import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:quanthex/core/constants/crypto_constants.dart' show bsc, bsc_doge_contract, eth, pol, polygon_doge_contract, polygon_orio_contract, bsc_ada_contract;
import 'package:quanthex/core/constants/network_constants.dart';
import 'package:quanthex/data/Models/assets/network_model.dart';
import 'package:quanthex/data/Models/assets/scan_token.dart';
import 'package:quanthex/data/Models/assets/supported_assets.dart';
import 'package:quanthex/data/Models/swap/model/coin_pair.dart';
import 'package:quanthex/data/Models/swap/model/pool_data.dart';
import 'package:quanthex/data/Models/swap/model/uniswap_tokens.dart';
import 'package:quanthex/data/services/assets/asset_service.dart';
import 'package:quanthex/data/utils/logger.dart';

class SwapController extends ChangeNotifier {
  Map<String, String> chainLink = {
    eth: "https://gateway.thegraph.com/api/7e8b89f52322d9cdf2d03b3c2d135400/subgraphs/id/5zvR82QoaXYFyDEKLZ9t6v9adgnptxYpKpSbxtgVENFV",
    bsc: "https://gateway.thegraph.com/api/7e8b89f52322d9cdf2d03b3c2d135400/subgraphs/id/F85MNzUGYqgSHSHRGgeVMNsdnW1KtZSVgFULumXRZTw2",
    pol: "https://gateway.thegraph.com/api/7e8b89f52322d9cdf2d03b3c2d135400/subgraphs/id/3hCPRGf4z88VC5rsBKU5AA9FBBq5nF3jbKJG7VZCbhjm",
  };
  List<SupportedCoin> tokens = [];
  Map<String, String> tokenImages = {};
  bool isPoolError = false;

  Future<List<SupportedCoin>> getTokens({required NetworkModel network, required String address, required String privateKey}) async {
    try {
      int limit = 20;
      //I did this because the bsc subgraph is doesnt get data below 100
      if (network.chainSymbol == bsc) {
        limit = 100;
      }
      if (network.chainSymbol == pol) {
        limit = 100;
      }
      isPoolError = false;
      String chainSymbol = network.chainSymbol;
      String link = chainLink[chainSymbol]!;
      logger(link, runtimeType.toString());
      logger("Swap: Getting tokens for $chainSymbol", runtimeType.toString());
      //set timeout to 10 seconds
      final HttpLink httpLink = HttpLink(link);
      final client = GraphQLClient(
        link: httpLink,
        // The default store is the InMemoryStore, which does NOT persist to disk
        cache: GraphQLCache(store: HiveStore()),
        queryRequestTimeout: const Duration(seconds: 20),

        defaultPolicies: DefaultPolicies(query: Policies(fetch: FetchPolicy.networkOnly)),
      );

      String readPools =
          """{
  tokens(first: $limit, orderBy: volumeUSD, orderDirection: desc) {
    id
    symbol
    name
    decimals
    volumeUSD
  }
}

""";
      final tokensResult = await client.query(QueryOptions(document: gql(readPools)));
      if (tokensResult.hasException) {
        throw Exception(tokensResult.exception.toString());
      }
      logger("Swap: token result: ${tokensResult.data}", runtimeType.toString());
      UniswapToken uniswapTokens = UniswapToken.fromJson(tokensResult.data!);
      List<String> addresses = uniswapTokens.tokens!.map((e) => e.id!).toList();
      if (addresses.isNotEmpty) {
        if (network.chainSymbol == bsc) {
          addresses = addresses.take(20).toList();
          addresses.add(bsc_doge_contract);
          addresses.add(bsc_ada_contract);
        } else if (network.chainSymbol == pol) {
          addresses.add(polygon_orio_contract);
          addresses.add(polygon_doge_contract);
        } else if (network.chainSymbol == eth) {}
      }
      logger(addresses.toString(), runtimeType.toString());
      List<SupportedCoin> assets = await AssetService.getInstance().scanTokens(network: network, addresses: addresses, chainSymbol: chainSymbol, walletAddress: address, privateKey: privateKey);
      tokens = assets;
      notifyListeners();
      return assets;
    } catch (e) {
      logger(network.chainSymbol.toString()+": "+e.toString(), runtimeType.toString());
      isPoolError = true;
      notifyListeners();
      throw Exception(e);
    }
  }

}
