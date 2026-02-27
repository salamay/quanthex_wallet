class StakingReferralDto {
  String? stakingReferralId;
  String? stakingReferralUid;
  String? stakingReferreeUid;
  String? stakingReferralStakingId;
  String? stakingReferreeStakingId;
  String? stakingReferralCreatedAt;
  String? stakingReferralUpdatedAt;

  StakingReferralDto({
    this.stakingReferralId,
    this.stakingReferralUid,
    this.stakingReferreeUid,
    this.stakingReferralStakingId,
    this.stakingReferreeStakingId,
    this.stakingReferralCreatedAt,
    this.stakingReferralUpdatedAt,
  });

  factory StakingReferralDto.fromJson(Map<String, dynamic> json) {
    return StakingReferralDto(
      stakingReferralId: json['staking_referral_id'],
      stakingReferralUid: json['staking_referral_uid'],
      stakingReferreeUid: json['staking_referree_uid'],
      stakingReferralStakingId: json['staking_referral_staking_id'],
      stakingReferreeStakingId: json['staking_referree_staking_id'],
      stakingReferralCreatedAt: json['staking_referral_created_at'],
      stakingReferralUpdatedAt: json['staking_referral_updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'staking_referral_id': stakingReferralId,
      'staking_referral_uid': stakingReferralUid,
      'staking_referree_uid': stakingReferreeUid,
      'staking_referral_staking_id': stakingReferralStakingId,
      'staking_referree_staking_id': stakingReferreeStakingId,
      'staking_referral_created_at': stakingReferralCreatedAt,
      'staking_referral_updated_at': stakingReferralUpdatedAt,
    };
  }

  StakingReferralDto copyWith({
    String? stakingReferralId,
    String? stakingReferralUid,
    String? stakingReferreeUid,
    String? stakingReferralStakingId,
    String? stakingReferreeStakingId,
    String? stakingReferralCreatedAt,
    String? stakingReferralUpdatedAt,
  }) {
    return StakingReferralDto(
      stakingReferralId: stakingReferralId ?? this.stakingReferralId,
      stakingReferralUid: stakingReferralUid ?? this.stakingReferralUid,
      stakingReferreeUid: stakingReferreeUid ?? this.stakingReferreeUid,
      stakingReferralStakingId: stakingReferralStakingId ?? this.stakingReferralStakingId,
      stakingReferreeStakingId: stakingReferreeStakingId ?? this.stakingReferreeStakingId,
      stakingReferralCreatedAt: stakingReferralCreatedAt ?? this.stakingReferralCreatedAt,
      stakingReferralUpdatedAt: stakingReferralUpdatedAt ?? this.stakingReferralUpdatedAt,
    );
  }
}
