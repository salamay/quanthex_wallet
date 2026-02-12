class SubscriptionDto {
  String? subId;
  String? email;
  String? subType;
  num? subPrice;
  int? subChainId;
  String? subAssetContract;
  String? subAssetSymbol;
  String? subAssetName;
  int? subAssetDecimals;
  String? subAssetImage;
  String? subRewardContract;
  int? subRewardChainId;
  String? subRewardAssetName;
  String? subRewardAssetSymbol;
  String? subRewardAssetImage;
  int? subRewardAssetDecimals;
  String? subPackageName;
  String? subDuration;
  String? subSignedTx;
  String? subRpc;
  String? subMiningTag;
  String? subWalletHash;
  String? subWalletAddress;
  

  SubscriptionDto({
    this.subId,
    this.email,
    this.subType,
    this.subPrice,
    this.subChainId,
    this.subAssetContract,
    this.subAssetSymbol,
    this.subAssetName,
    this.subAssetDecimals,
    this.subAssetImage,
    this.subRewardContract,
    this.subRewardChainId,
    this.subRewardAssetName,
    this.subRewardAssetSymbol,
    this.subRewardAssetImage,
    this.subRewardAssetDecimals,
    this.subPackageName,
    this.subDuration,
    this.subSignedTx,
    this.subRpc,
    this.subMiningTag,
    this.subWalletHash,
    this.subWalletAddress,
  });

  factory SubscriptionDto.fromJson(Map<String, dynamic> json) {
    return SubscriptionDto(
      subId: json['sub_id'],
      email: json['email'],
      subType: json['sub_type'],
      subPrice: json['sub_price'],
      subChainId: json['sub_chain_id'],
      subAssetContract: json['sub_asset_contract'],
      subAssetSymbol: json['sub_asset_symbol'],
      subAssetName: json['sub_asset_name'],
      subAssetDecimals: json['sub_asset_decimals'],
      subAssetImage: json['sub_asset_image'],
      subRewardContract: json['sub_reward_contract'],
      subRewardChainId: json['sub_reward_chain_id'],
      subRewardAssetName: json['sub_reward_asset_name'],
      subRewardAssetSymbol: json['sub_reward_asset_symbol'],
      subRewardAssetImage: json['sub_reward_asset_image'],
      subRewardAssetDecimals: json['sub_reward_asset_decimals'],
      subPackageName: json['sub_package_name'],
      subDuration: json['sub_duration'],
      subSignedTx: json['sub_signed_tx'],
      subRpc: json['sub_rpc'],
      subMiningTag: json['sub_mining_tag'],
      subWalletHash: json['sub_wallet_hash'],
      subWalletAddress: json['sub_wallet_address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sub_id': subId,
      'email': email,
      'sub_type': subType,
      'sub_price': subPrice,
      'sub_chain_id': subChainId,
      'sub_asset_contract': subAssetContract,
      'sub_asset_symbol': subAssetSymbol,
      'sub_asset_name': subAssetName,
      'sub_asset_decimals': subAssetDecimals,
      'sub_asset_image': subAssetImage,
      'sub_reward_contract': subRewardContract,
      'sub_reward_chain_id': subRewardChainId,
      'sub_reward_asset_name': subRewardAssetName,
      'sub_reward_asset_symbol': subRewardAssetSymbol,
      'sub_reward_asset_image': subRewardAssetImage,
      'sub_reward_asset_decimals': subRewardAssetDecimals,
      'sub_package_name': subPackageName,
      'sub_duration': subDuration,
      'sub_signed_tx': subSignedTx,
      'sub_rpc': subRpc,
      'sub_mining_tag': subMiningTag,
      'sub_wallet_hash': subWalletHash,
      'sub_wallet_address': subWalletAddress,
    };
  }

  SubscriptionDto copyWith({
    String? subId,
    String? email,
    String? subType,
    double? subPrice,
    int? subChainId,
    String? subAssetContract,
    String? subAssetSymbol,
    String? subAssetName,
    int? subAssetDecimals,
    String? subAssetImage,
    String? subRewardContract,
    int? subRewardChainId,
    String? subRewardAssetName,
    String? subRewardAssetSymbol,
    String? subRewardAssetImage,
    int? subRewardAssetDecimals,
    String? subPackageName,
    String? subDuration,
    String? subSignedTx,
    String? subRpc,
    String? subMiningTag,
    String? subWalletHash,
    String? subWalletAddress,
  }) {
    return SubscriptionDto(
      subId: subId ?? this.subId,
      email: email ?? this.email,
      subType: subType ?? this.subType,
      subPrice: subPrice ?? this.subPrice,
      subChainId: subChainId ?? this.subChainId,
      subAssetContract: subAssetContract ?? this.subAssetContract,
      subAssetSymbol: subAssetSymbol ?? this.subAssetSymbol,
      subAssetName: subAssetName ?? this.subAssetName,
      subAssetDecimals: subAssetDecimals ?? this.subAssetDecimals,
      subAssetImage: subAssetImage ?? this.subAssetImage,
      subRewardContract: subRewardContract ?? this.subRewardContract,
      subRewardChainId: subRewardChainId ?? this.subRewardChainId,
      subRewardAssetName:
      subRewardAssetName ?? this.subRewardAssetName,
      subRewardAssetSymbol:
      subRewardAssetSymbol ?? this.subRewardAssetSymbol,
      subRewardAssetImage:
      subRewardAssetImage ?? this.subRewardAssetImage,
      subRewardAssetDecimals:
      subRewardAssetDecimals ?? this.subRewardAssetDecimals,
      subPackageName: subPackageName ?? this.subPackageName,
      subDuration: subDuration ?? this.subDuration,
      subSignedTx: subSignedTx ?? this.subSignedTx,
      subRpc: subRpc ?? this.subRpc,
      subMiningTag: subMiningTag ?? this.subMiningTag,
      subWalletHash: subWalletHash ?? this.subWalletHash,
      subWalletAddress: subWalletAddress ?? this.subWalletAddress,
    );
  }
}