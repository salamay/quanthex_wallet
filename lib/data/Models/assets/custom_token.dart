// To parse this JSON data, do
//
//     final customToken = customTokenFromJson(jsonString);

import 'dart:convert';

List<CustomToken> customTokenFromJson(String str) => List<CustomToken>.from(json.decode(str).map((x) => CustomToken.fromJson(x)));

String customTokenToJson(List<CustomToken> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomToken {
  String? symbol;
  String? name;
  String? image;
  int? decimal;
  String? contractAddress;
  String? chainSymbol;
  String? chainName;

  CustomToken({
    this.symbol,
    this.name,
    this.image,
    this.decimal,
    this.contractAddress,
    this.chainSymbol,
    this.chainName,
  });

  factory CustomToken.fromJson(Map<String, dynamic> json) => CustomToken(
    symbol: json["symbol"],
    name: json["name"],
    image: json["image"],
    decimal: json["decimal"],
    contractAddress: json["contract_address"],
    chainSymbol: json["chain_symbol"],
    chainName: json["chain_name"],
  );

  Map<String, dynamic> toJson() => {
    "symbol": symbol,
    "name": name,
    "image": image,
    "decimal": decimal,
    "contract_address": contractAddress,
    "chain_symbol": chainSymbol,
    "chain_name": chainName,
  };
}
