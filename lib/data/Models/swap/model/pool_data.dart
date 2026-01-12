// To parse this JSON data, do
//
//     final poolData = poolDataFromJson(jsonString);

import 'dart:convert';

PoolData poolDataFromJson(String str) => PoolData.fromJson(json.decode(str));

String poolDataToJson(PoolData data) => json.encode(data.toJson());

class PoolData {
  List<Pool>? pools;

  PoolData({
    this.pools,
  });

  factory PoolData.fromJson(Map<String, dynamic> json) => PoolData(
    pools: json["pools"] == null ? [] : List<Pool>.from(json["pools"]!.map((x) => Pool.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pools": pools == null ? [] : List<dynamic>.from(pools!.map((x) => x.toJson())),
  };
}

class Pool {
  String? feeTier;
  String? id;
  String? liquidity;
  Token? token0;
  String? token0Price;
  Token? token1;
  String? token1Price;
  String? volumeToken0;
  String? volumeToken1;
  String? volumeUsd;

  Pool({
    this.feeTier,
    this.id,
    this.liquidity,
    this.token0,
    this.token0Price,
    this.token1,
    this.token1Price,
    this.volumeToken0,
    this.volumeToken1,
    this.volumeUsd,
  });

  factory Pool.fromJson(Map<String, dynamic> json) => Pool(
    feeTier: json["feeTier"],
    id: json["id"],
    liquidity: json["liquidity"],
    token0: json["token0"] == null ? null : Token.fromJson(json["token0"]),
    token0Price: json["token0Price"],
    token1: json["token1"] == null ? null : Token.fromJson(json["token1"]),
    token1Price: json["token1Price"],
    volumeToken0: json["volumeToken0"],
    volumeToken1: json["volumeToken1"],
    volumeUsd: json["volumeUSD"],
  );

  Map<String, dynamic> toJson() => {
    "feeTier": feeTier,
    "id": id,
    "liquidity": liquidity,
    "token0": token0?.toJson(),
    "token0Price": token0Price,
    "token1": token1?.toJson(),
    "token1Price": token1Price,
    "volumeToken0": volumeToken0,
    "volumeToken1": volumeToken1,
    "volumeUSD": volumeUsd,
  };
}

class Token {
  String? decimals;
  String? derivedEth;
  String? name;
  String? symbol;

  Token({
    this.decimals,
    this.derivedEth,
    this.name,
    this.symbol,
  });

  factory Token.fromJson(Map<String, dynamic> json) => Token(
    decimals: json["decimals"],
    derivedEth: json["derivedETH"],
    name: json["name"],
    symbol: json["symbol"],
  );

  Map<String, dynamic> toJson() => {
    "decimals": decimals,
    "derivedETH": derivedEth,
    "name": name,
    "symbol": symbol,
  };
}
