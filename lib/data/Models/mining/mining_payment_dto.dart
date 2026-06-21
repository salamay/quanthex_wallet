class MiningPaymentDto {
  final String mpId;
  final String mpMinId;
  final String mpUid;
  final String mpSubscriptionId;
  final String? mpTxHash;
  final String? mpTxData;
  final double mpAmount;
  final int mpChainId;
  final String? mpRewardSymbol;
  final int mpPaymentTier;
  final int mpReferralCountAtPayment;
  final int mpIsManual;
  final String mpStatus;
  final String mpCreatedAt;
  final String mpUpdatedAt;

  // Joined fields from subscriptions
  final String? subPackageName;
  final String? subRewardAssetSymbol;
  final String? subRewardAssetName;
  final int? subRewardChainId;
  final String? subRewardContract;
  final String? subAssetSymbol;
  final double? subPrice;

  MiningPaymentDto({
    required this.mpId,
    required this.mpMinId,
    required this.mpUid,
    required this.mpSubscriptionId,
    this.mpTxHash,
    this.mpTxData,
    required this.mpAmount,
    required this.mpChainId,
    this.mpRewardSymbol,
    required this.mpPaymentTier,
    required this.mpReferralCountAtPayment,
    required this.mpIsManual,
    required this.mpStatus,
    required this.mpCreatedAt,
    required this.mpUpdatedAt,
    this.subPackageName,
    this.subRewardAssetSymbol,
    this.subRewardAssetName,
    this.subRewardChainId,
    this.subRewardContract,
    this.subAssetSymbol,
    this.subPrice,
  });

  bool get isPending => mpStatus.toLowerCase() == 'pending';
  bool get isConfirmed => mpStatus.toLowerCase() == 'confirmed';
  bool get isFailed => mpStatus.toLowerCase() == 'failed';
  bool get isManual => mpIsManual == 1;

  String get tierLabel => isManual ? 'Accepted' : 'Payment #$mpPaymentTier';

  factory MiningPaymentDto.fromJson(Map<String, dynamic> json) {
    return MiningPaymentDto(
      mpId: json['mp_id'] ?? '',
      mpMinId: json['mp_min_id'] ?? '',
      mpUid: json['mp_uid'] ?? '',
      mpSubscriptionId: json['mp_subscription_id'] ?? '',
      mpTxHash: json['mp_tx_hash'],
      mpTxData: json['mp_tx_data'],
      mpAmount: (json['mp_amount'] is num)
          ? (json['mp_amount'] as num).toDouble()
          : double.tryParse(json['mp_amount']?.toString() ?? '0') ?? 0,
      mpChainId: json['mp_chain_id'] ?? 0,
      mpRewardSymbol: json['mp_reward_symbol'],
      mpPaymentTier: json['mp_payment_tier'] ?? 0,
      mpReferralCountAtPayment: json['mp_referral_count_at_payment'] ?? 0,
      mpIsManual: json['mp_is_manual'] ?? 0,
      mpStatus: json['mp_status'] ?? 'pending',
      mpCreatedAt: json['mp_created_at']?.toString() ?? '',
      mpUpdatedAt: json['mp_updated_at']?.toString() ?? '',
      subPackageName: json['sub_package_name'],
      subRewardAssetSymbol: json['sub_reward_asset_symbol'],
      subRewardAssetName: json['sub_reward_asset_name'],
      subRewardChainId: json['sub_reward_chain_id'] != null
          ? int.tryParse(json['sub_reward_chain_id'].toString())
          : null,
      subRewardContract: json['sub_reward_contract'],
      subAssetSymbol: json['sub_asset_symbol'],
      subPrice: json['sub_price'] != null
          ? double.tryParse(json['sub_price'].toString()) ?? 0
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mp_id': mpId,
      'mp_min_id': mpMinId,
      'mp_uid': mpUid,
      'mp_subscription_id': mpSubscriptionId,
      'mp_tx_hash': mpTxHash,
      'mp_tx_data': mpTxData,
      'mp_amount': mpAmount,
      'mp_chain_id': mpChainId,
      'mp_reward_symbol': mpRewardSymbol,
      'mp_payment_tier': mpPaymentTier,
      'mp_referral_count_at_payment': mpReferralCountAtPayment,
      'mp_is_manual': mpIsManual,
      'mp_status': mpStatus,
      'mp_created_at': mpCreatedAt,
      'mp_updated_at': mpUpdatedAt,
      'sub_package_name': subPackageName,
      'sub_reward_asset_symbol': subRewardAssetSymbol,
      'sub_reward_asset_name': subRewardAssetName,
      'sub_reward_chain_id': subRewardChainId,
      'sub_reward_contract': subRewardContract,
      'sub_asset_symbol': subAssetSymbol,
      'sub_price': subPrice,
    };
  }
}
