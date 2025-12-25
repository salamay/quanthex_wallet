import 'dart:convert';


class WalletModel{
  String? mnemonic;
  String? walletAddress;
  String? chainId;
  String? privateKey;
  WalletModel({ this.mnemonic,required this.chainId,required this.walletAddress, this.privateKey});

  factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
    mnemonic: json['mnemonic'],
    walletAddress: json["wallet_address"],
    chainId: json["chain_id"],
    privateKey: json["private_key"]
  );

  Map<String, dynamic> toJson() => {
    "mnemonic": mnemonic,
    "wallet_address": walletAddress,
    "chain_id": chainId,
    "private_key": privateKey
  };
}