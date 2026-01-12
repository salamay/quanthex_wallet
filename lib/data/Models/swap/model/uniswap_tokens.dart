// To parse this JSON data, do
//
//     final uniswapToken = uniswapTokenFromJson(jsonString);

import 'dart:convert';

UniswapToken uniswapTokenFromJson(String str) => UniswapToken.fromJson(json.decode(str));

String uniswapTokenToJson(UniswapToken data) => json.encode(data.toJson());

class UniswapToken {
  List<Token>? tokens;

  UniswapToken({
    this.tokens,
  });

  factory UniswapToken.fromJson(Map<String, dynamic> json) => UniswapToken(
    tokens: json["tokens"] == null ? [] : List<Token>.from(json["tokens"]!.map((x) => Token.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "tokens": tokens == null ? [] : List<dynamic>.from(tokens!.map((x) => x.toJson())),
  };
}

class Token {
  String? decimals;
  String? id;
  String? name;
  String? symbol;
  String? volumeUsd;

  Token({
    this.decimals,
    this.id,
    this.name,
    this.symbol,
    this.volumeUsd,
  });

  factory Token.fromJson(Map<String, dynamic> json) => Token(
    decimals: json["decimals"],
    id: json["id"],
    name: json["name"],
    symbol: json["symbol"],
    volumeUsd: json["volumeUSD"],
  );

  Map<String, dynamic> toJson() => {
    "decimals": decimals,
    "id": id,
    "name": name,
    "symbol": symbol,
    "volumeUSD": volumeUsd,
  };
}
