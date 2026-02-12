class StakingDto {
  String? stakingId;
  String? uid;
  String? email;
  String? stakeCreatedAt;
  String? stakeUpdatedAt;
  String? stakedAssetSymbol;
  String? stakedAssetContract;
  int? stackedAssetDecimals;
  String? stakedAssetName;
  String? stakedAssetImage;
  String? stakedAmountFiat;
  String? stakedAmountCrypto;
  String? stakingStatus;
  String? stakingRewardContract;
  int? stakingRewardChainId;
  String? stakingRewardChainName;
  String? stakingRewardAssetName;
  String? stakingRewardAssetSymbol;
  int? stakingRewardAssetDecimals;
  String? stakingRewardAssetImage;
  String? stakingWalletHash;
  String? stakingWalletAddress;

  StakingDto({
    this.stakingId,
    this.uid,
    this.email,
    this.stakeCreatedAt,
    this.stakeUpdatedAt,
    this.stakedAssetSymbol,
    this.stakedAssetContract,
    this.stackedAssetDecimals,
    this.stakedAssetName,
    this.stakedAssetImage,
    this.stakedAmountFiat,
    this.stakedAmountCrypto,
    this.stakingStatus,
    this.stakingRewardContract,
    this.stakingRewardChainId,
    this.stakingRewardChainName,
    this.stakingRewardAssetName,
    this.stakingRewardAssetSymbol,
    this.stakingRewardAssetDecimals,
    this.stakingRewardAssetImage,
    this.stakingWalletHash,
    this.stakingWalletAddress,
  });

  factory StakingDto.fromJson(Map<String, dynamic> json) {
    return StakingDto(
      stakingId: json['staking_id'],
      uid: json['uid'],
      email: json['email'],
      stakeCreatedAt: json['stake_created_at'],
      stakeUpdatedAt: json['stake_updated_at'],
      stakedAssetSymbol: json['staked_asset_symbol'],
      stakedAssetContract: json['staked_asset_contract'],
      stackedAssetDecimals: json['stacked_asset_decimals'],
      stakedAssetName: json['staked_asset_name'],
      stakedAssetImage: json['staked_asset_image'],
      stakedAmountFiat: json['staked_amount_fiat'],
      stakedAmountCrypto: json['staked_amount_crypto'],
      stakingStatus: json['staking_status'],
      stakingRewardContract: json['staking_reward_contract'],
      stakingRewardChainId: json['staking_reward_chain_id'],
      stakingRewardChainName: json['staking_reward_chain_name'],
      stakingRewardAssetName: json['staking_reward_asset_name'],
      stakingRewardAssetSymbol: json['staking_reward_asset_symbol'],
      stakingRewardAssetDecimals: json['staking_reward_asset_decimals'],
      stakingRewardAssetImage:json['staking_reward_asset_image'],
      stakingWalletHash: json['staking_wallet_hash'],
      stakingWalletAddress: json['staking_wallet_address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'staking_id': stakingId,
      'uid': uid,
      'email': email,
      'stake_created_at': stakeCreatedAt,
      'stake_updated_at': stakeUpdatedAt,
      'staked_asset_symbol': stakedAssetSymbol,
      'staked_asset_contract': stakedAssetContract,
      'stacked_asset_decimals': stackedAssetDecimals,
      'staked_asset_name': stakedAssetName,
      'staked_asset_image': stakedAssetImage,
      'staked_amount_fiat': stakedAmountFiat,
      'staked_amount_crypto': stakedAmountCrypto,
      'staking_status': stakingStatus,
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
      'staking_wallet_hash': stakingWalletHash,
      'staking_wallet_address': stakingWalletAddress,
    };
  }

  StakingDto copyWith({
    String? stakingId,
    String? uid,
    String? email,
    String? stakeCreatedAt,
    String? stakeUpdatedAt,
    String? stakedAssetSymbol,
    String? stakedAssetContract,
    int? stackedAssetDecimals,
    String? stakedAssetName,
    String? stakedAssetImage,
    String? stakedAmountFiat,
    String? stakedAmountCrypto,
    String? stakingStatus,
    String? stakingRewardContract,
    int? stakingRewardChainId,
    String? stakingRewardChainName,
    String? stakingRewardAssetName,
    String? stakingRewardAssetSymbol,
    int? stakingRewardAssetDecimals,
    String? stakingRewardAssetImage,
    String? stakingWalletHash,
    String? stakingWalletAddress,
  }) {
    return StakingDto(
      stakingId: stakingId ?? this.stakingId,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      stakeCreatedAt:
      stakeCreatedAt ?? this.stakeCreatedAt,
      stakeUpdatedAt:
      stakeUpdatedAt ?? this.stakeUpdatedAt,
      stakedAssetSymbol:
      stakedAssetSymbol ?? this.stakedAssetSymbol,
      stakedAssetContract:
      stakedAssetContract ??
          this.stakedAssetContract,
      stackedAssetDecimals:
      stackedAssetDecimals ??
          this.stackedAssetDecimals,
      stakedAssetName:
      stakedAssetName ?? this.stakedAssetName,
      stakedAssetImage:
      stakedAssetImage ?? this.stakedAssetImage,
      stakedAmountFiat:
      stakedAmountFiat ?? this.stakedAmountFiat,
      stakedAmountCrypto:
      stakedAmountCrypto ??
          this.stakedAmountCrypto,
      stakingStatus:
      stakingStatus ?? this.stakingStatus,
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
      stakingWalletHash: stakingWalletHash ?? this.stakingWalletHash,
      stakingWalletAddress: stakingWalletAddress ?? this.stakingWalletAddress,
    );
  }
}
