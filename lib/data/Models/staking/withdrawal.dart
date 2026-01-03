class WithdrawalDto {
  String? withdrawalId;
  String? uid;
  String? email;
  String? stakingId;
  String? withdrawalCreatedAt;
  String? withdrawalUpdatedAt;

  String? withdrawalAssetSymbol;
  String? withdrawalAssetContract;
  int? withdrawalAssetDecimals;
  String? withdrawalAssetName;
  String? withdrawalAssetImage;

  String? withdrawalAmountCrypto;
  String? withdrawalAmountFiat;
  String? withdrawalStatus;

  int? withdrawalChainId;
  String? withdrawalChainName;

  WithdrawalDto({
    this.withdrawalId,
    this.uid,
    this.email,
    this.stakingId,
    this.withdrawalCreatedAt,
    this.withdrawalUpdatedAt,
    this.withdrawalAssetSymbol,
    this.withdrawalAssetContract,
    this.withdrawalAssetDecimals,
    this.withdrawalAssetName,
    this.withdrawalAssetImage,
    this.withdrawalAmountCrypto,
    this.withdrawalAmountFiat,
    this.withdrawalStatus,
    this.withdrawalChainId,
    this.withdrawalChainName,
  });

  factory WithdrawalDto.fromJson(Map<String, dynamic> json) {
    return WithdrawalDto(
      withdrawalId: json['withdrawal_id']?.toString(),
      uid: json['uid']?.toString(),
      email: json['email']?.toString(),
      stakingId: json['staking_id']?.toString(),
      withdrawalCreatedAt: json['withdrawal_created_at']?.toString(),
      withdrawalUpdatedAt: json['withdrawal_updated_at']?.toString(),
      withdrawalAssetSymbol: json['withdrawal_asset_symbol']?.toString(),
      withdrawalAssetContract: json['withdrawal_asset_contract']?.toString(),
      withdrawalAssetDecimals: json['withdrawal_asset_decimals'],
      withdrawalAssetName: json['withdrawal_asset_name']?.toString(),
      withdrawalAssetImage: json['withdrawal_asset_image']?.toString(),
      withdrawalAmountCrypto: json['withdrawal_amount_crypto']?.toString(),
      withdrawalAmountFiat: json['withdrawal_amount_fiat']?.toString(),
      withdrawalStatus: json['withdrawal_status']?.toString(),
      withdrawalChainId: json['withdrawal_chain_id'],
      withdrawalChainName: json['withdrawal_chain_name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'withdrawal_id': withdrawalId,
      'uid': uid,
      'email': email,
      'staking_id': stakingId,
      'withdrawal_created_at': withdrawalCreatedAt,
      'withdrawal_updated_at': withdrawalUpdatedAt,
      'withdrawal_asset_symbol': withdrawalAssetSymbol,
      'withdrawal_asset_contract': withdrawalAssetContract,
      'withdrawal_asset_decimals': withdrawalAssetDecimals,
      'withdrawal_asset_name': withdrawalAssetName,
      'withdrawal_asset_image': withdrawalAssetImage,
      'withdrawal_amount_crypto': withdrawalAmountCrypto,
      'withdrawal_amount_fiat': withdrawalAmountFiat,
      'withdrawal_status': withdrawalStatus,
      'withdrawal_chain_id': withdrawalChainId,
      'withdrawal_chain_name': withdrawalChainName,
    };
  }

  WithdrawalDto copyWith({
    String? withdrawalId,
    String? uid,
    String? email,
    String? stakingId,
    String? withdrawalCreatedAt,
    String? withdrawalUpdatedAt,
    String? withdrawalAssetSymbol,
    String? withdrawalAssetContract,
    int? withdrawalAssetDecimals,
    String? withdrawalAssetName,
    String? withdrawalAssetImage,
    String? withdrawalAmountCrypto,
    String? withdrawalAmountFiat,
    String? withdrawalStatus,
    int? withdrawalChainId,
    String? withdrawalChainName,
  }) {
    return WithdrawalDto(
      withdrawalId: withdrawalId ?? this.withdrawalId,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      stakingId: stakingId ?? this.stakingId,
      withdrawalCreatedAt: withdrawalCreatedAt ?? this.withdrawalCreatedAt,
      withdrawalUpdatedAt: withdrawalUpdatedAt ?? this.withdrawalUpdatedAt,
      withdrawalAssetSymbol:
          withdrawalAssetSymbol ?? this.withdrawalAssetSymbol,
      withdrawalAssetContract:
          withdrawalAssetContract ?? this.withdrawalAssetContract,
      withdrawalAssetDecimals:
          withdrawalAssetDecimals ?? this.withdrawalAssetDecimals,
      withdrawalAssetName: withdrawalAssetName ?? this.withdrawalAssetName,
      withdrawalAssetImage: withdrawalAssetImage ?? this.withdrawalAssetImage,
      withdrawalAmountCrypto:
          withdrawalAmountCrypto ?? this.withdrawalAmountCrypto,
      withdrawalAmountFiat: withdrawalAmountFiat ?? this.withdrawalAmountFiat,
      withdrawalStatus: withdrawalStatus ?? this.withdrawalStatus,
      withdrawalChainId: withdrawalChainId ?? this.withdrawalChainId,
      withdrawalChainName: withdrawalChainName ?? this.withdrawalChainName,
    );
  }
}
