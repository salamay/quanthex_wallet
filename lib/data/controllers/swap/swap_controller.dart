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
    pol: "https://gateway.thegraph.com/api/7e8b89f52322d9cdf2d03b3c2d135400/subgraphs/id/HMcqgvDY6f4MpnRSJqUUsBPHePj8Hq3AxiDBfDUrWs15",
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
      logger(e.toString(), runtimeType.toString());
      isPoolError = true;
      notifyListeners();
      throw Exception(e);
    }
  }

  Future<CoinPair?> getPool({required String chainSymbol, required SupportedCoin token0, required SupportedCoin token1}) async {
    logger("Getting pool for ${token0.contractAddress} and ${token1.contractAddress}", runtimeType.toString());
    String link = chainLink[chainSymbol]!;
    logger("Swap: Getting pool for $chainSymbol", runtimeType.toString());
    final HttpLink httpLink = HttpLink(link);
    final client = GraphQLClient(
      link: httpLink,
      // The default store is the InMemoryStore, which does NOT persist to disk
      cache: GraphQLCache(store: HiveStore()),
      defaultPolicies: DefaultPolicies(query: Policies(fetch: FetchPolicy.networkOnly)),
    );
    String token0Address = token0.contractAddress!.toLowerCase();
    String token1Address = token1.contractAddress!.toLowerCase();
    String readPools =
        """{
  pools(where: {
    or: [
      { token0: "$token0Address", token1: "$token1Address" },
      { token0: "$token1Address", token1: "$token0Address" },
    ]
  },orderBy:liquidity orderDirection: desc) {
    id
    feeTier
    token0Price
    token1Price,
    volumeToken0
    volumeToken1
    volumeUSD
    liquidity
    token0 {
    name
    symbol
    decimals
    derivedETH
    }
    token1 {
    name
    symbol
    decimals
    derivedETH
    }
  }
}""";
    final tokensResult = await client.query(QueryOptions(document: gql(readPools)));
    if (tokensResult.hasException) {
      throw Exception(tokensResult.exception.toString());
    }
    logger("Swap route: Pools result: ${tokensResult.data}", runtimeType.toString());
    PoolData poolData = PoolData.fromJson(tokensResult.data!);
    if (poolData.pools!.isEmpty) {
      return null;
    }
    Pool pool = poolData.pools!.first;
    if (token0.symbol == pool.token0?.symbol?.toUpperCase() && token1.symbol == pool.token1?.symbol?.toUpperCase()) {
      logger("Normal pool", runtimeType.toString());
      return CoinPair(
        token0: token0,
        token1: token1,
        fee: double.parse(pool.feeTier!),
        poolAddress: pool.id!,
        //token0Price is the price of token0 in token1 because thats what the pool returned
        token0Price: double.parse(pool.token1Price!),
        token1Price: double.parse(pool.token0Price!),
        volumeToken0: double.parse(pool.volumeToken1!),
        volumeToken1: double.parse(pool.volumeToken0!),
        volumeUSD: double.parse(pool.volumeUsd!),
        liquidity: BigInt.parse(pool.liquidity!),
        isIntermediary: false,
        intermediaryContract: "",
        intermediaryPoolFee: BigInt.zero,
      );
    } else {
      logger("Inverse pool", runtimeType.toString());
      return CoinPair(
        token0: token1,
        token1: token0,
        fee: double.parse(pool.feeTier!),
        poolAddress: pool.id!,
        token0Price: double.parse(pool.token0Price!),
        token1Price: double.parse(pool.token1Price!),
        volumeToken0: double.parse(pool.volumeToken1!),
        volumeToken1: double.parse(pool.volumeToken0!),
        volumeUSD: double.parse(pool.volumeUsd!),
        liquidity: BigInt.parse(pool.liquidity!),
        isIntermediary: false,
        intermediaryContract: "",
        intermediaryPoolFee: BigInt.zero,
      );
    }
  }
}
