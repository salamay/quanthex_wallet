class WalletModel {
  String? mnemonic;
  String? walletAddress;
  String? chainId;
  String? privateKey;
  String? name;
  WalletModel({
    this.mnemonic,
    required this.chainId,
    required this.walletAddress,
    this.privateKey,
    this.name,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
    mnemonic: json['mnemonic'],
    walletAddress: json["wallet_address"],
    chainId: json["chain_id"],
    privateKey: json["private_key"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "mnemonic": mnemonic,
    "wallet_address": walletAddress,
    "chain_id": chainId,
    "private_key": privateKey,
    "name": name,
  };
}
