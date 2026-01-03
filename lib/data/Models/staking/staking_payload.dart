class StakingPayload {
  String? stakedAssetSymbol;
  String? stakedAssetContract;
  int? stackedAssetDecimals;
  String? stakedAssetName;
  String? stakedAssetImage;
  String? stakedAmountFiat;
  String? stakedAmountCrypto;
  String? stakingRewardContract;
  int? stakingRewardChainId;
  String? stakingRewardChainName;
  String? stakingRewardAssetName;
  String? stakingRewardAssetSymbol;
  int? stakingRewardAssetDecimals;
  String? stakingRewardAssetImage;
  String? signedTx;
  String? rpc;

  StakingPayload({
    this.stakedAssetSymbol,
    this.stakedAssetContract,
    this.stackedAssetDecimals,
    this.stakedAssetName,
    this.stakedAssetImage,
    this.stakedAmountFiat,
    this.stakedAmountCrypto,
    this.stakingRewardContract,
    this.stakingRewardChainId,
    this.stakingRewardChainName,
    this.stakingRewardAssetName,
    this.stakingRewardAssetSymbol,
    this.stakingRewardAssetDecimals,
    this.stakingRewardAssetImage,
    this.signedTx,
    this.rpc
  });

  factory StakingPayload.fromJson(Map<String, dynamic> json) {
    return StakingPayload(
      stakedAssetSymbol: json['staked_asset_symbol'],
      stakedAssetContract: json['staked_asset_contract'],
      stackedAssetDecimals: json['stacked_asset_decimals'],
      stakedAssetName: json['staked_asset_name'],
      stakedAssetImage: json['staked_asset_image'],
      stakedAmountFiat: json['staked_amount_fiat'],
      stakedAmountCrypto: json['staked_amount_crypto'],
      stakingRewardContract: json['staking_reward_contract'],
      stakingRewardChainId: json['staking_reward_chain_id'],
      stakingRewardChainName: json['staking_reward_chain_name'],
      stakingRewardAssetName:
      json['staking_reward_asset_name'],
      stakingRewardAssetSymbol:
      json['staking_reward_asset_symbol'],
      stakingRewardAssetDecimals:
      json['staking_reward_asset_decimals'],
      stakingRewardAssetImage:
      json['staking_reward_asset_image'],
      signedTx: json ['signed_tx'],
      rpc: json['rpc'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'staked_asset_symbol': stakedAssetSymbol,
      'staked_asset_contract': stakedAssetContract,
      'stacked_asset_decimals': stackedAssetDecimals,
      'staked_asset_name': stakedAssetName,
      'staked_asset_image': stakedAssetImage,
      'staked_amount_fiat': stakedAmountFiat,
      'staked_amount_crypto': stakedAmountCrypto,
      'staking_reward_contract': stakingRewardContract,
      'staking_reward_chain_id': stakingRewardChainId,
      'staking_reward_chain_name': stakingRewardChainName,
      'staking_reward_asset_name':
      stakingRewardAssetName,
      'staking_reward_asset_symbol':
      stakingRewardAssetSymbol,
      'staking_reward_asset_decimals':
      stakingRewardAssetDecimals,
      'staking_reward_asset_image':
      stakingRewardAssetImage,
      'signed_tx': signedTx,
      'rpc': rpc,
    };
  }

  StakingPayload copyWith({
    String? stakedAssetSymbol,
    String? stakedAssetContract,
    int? stackedAssetDecimals,
    String? stakedAssetName,
    String? stakedAssetImage,
    String? stakedAmountFiat,
    String? stakedAmountCrypto,
    String? stakingRewardContract,
    int? stakingRewardChainId,
    String? stakingRewardChainName,
    String? stakingRewardAssetName,
    String? stakingRewardAssetSymbol,
    int? stakingRewardAssetDecimals,
    String? stakingRewardAssetImage,
    String? signedTx,
    String? rpc,
  }) {
    return StakingPayload(
      stakedAssetSymbol:
      stakedAssetSymbol ?? this.stakedAssetSymbol,
      stakedAssetContract:
      stakedAssetContract ?? this.stakedAssetContract,
      stackedAssetDecimals:
      stackedAssetDecimals ?? this.stackedAssetDecimals,
      stakedAssetName:
      stakedAssetName ?? this.stakedAssetName,
      stakedAssetImage:
      stakedAssetImage ?? this.stakedAssetImage,
      stakedAmountFiat:
      stakedAmountFiat ?? this.stakedAmountFiat,
      stakedAmountCrypto:
      stakedAmountCrypto ?? this.stakedAmountCrypto,
      stakingRewardContract:
      stakingRewardContract ??
          this.stakingRewardContract,
      stakingRewardChainId:
      stakingRewardChainId ??
          this.stakingRewardChainId,
      stakingRewardChainName:
      stakingRewardChainName ??
          this.stakingRewardChainName,
      stakingRewardAssetName:
      stakingRewardAssetName ??
          this.stakingRewardAssetName,
      stakingRewardAssetSymbol:
      stakingRewardAssetSymbol ??
          this.stakingRewardAssetSymbol,
      stakingRewardAssetDecimals:
      stakingRewardAssetDecimals ??
          this.stakingRewardAssetDecimals,
      stakingRewardAssetImage:
      stakingRewardAssetImage ??
          this.stakingRewardAssetImage,
      signedTx: signedTx ?? this.signedTx,
      rpc: rpc ?? this.rpc,
    );
  }
}
