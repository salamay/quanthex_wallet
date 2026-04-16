class ReferralInfoDto {
  String? referralId;
  String? referralUid;
  String? referreeUid;
  String? referralSubscriptionId;
  String? referralCreatedAt;
  String? referralUpdatedAt;
  dynamic referralPath;

  ReferralInfoDto({
    this.referralId,
    this.referralUid,
    this.referreeUid,
    this.referralSubscriptionId,
    this.referralCreatedAt,
    this.referralUpdatedAt,
    this.referralPath,
  });

  factory ReferralInfoDto.fromJson(Map<String, dynamic> json) {
    return ReferralInfoDto(
      referralId: json['referral_id'],
      referralUid: json['referral_uid'],
      referreeUid: json['referree_uid'],
      referralSubscriptionId: json['referral_subscription_id'],
      referralCreatedAt: json['referral_created_at'],
      referralUpdatedAt: json['referral_updated_at'],
      referralPath: json['referral_path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'referral_id': referralId,
      'referral_uid': referralUid,
      'referree_uid': referreeUid,
      'referral_subscription_id': referralSubscriptionId,
      'referral_created_at': referralCreatedAt,
      'referral_updated_at': referralUpdatedAt,
      'referral_path': referralPath,
    };
  }

  ReferralInfoDto copyWith({
    String? referralId,
    String? referralUid,
    String? referreeUid,
    String? referralSubscriptionId,
    String? referralCreatedAt,
    String? referralUpdatedAt,
    dynamic referralPath,
  }) {
    return ReferralInfoDto(
      referralId: referralId ?? this.referralId,
      referralUid: referralUid ?? this.referralUid,
      referreeUid: referreeUid ?? this.referreeUid,
      referralSubscriptionId: referralSubscriptionId ?? this.referralSubscriptionId,
      referralCreatedAt:
      referralCreatedAt ?? this.referralCreatedAt,
      referralUpdatedAt:
      referralUpdatedAt ?? this.referralUpdatedAt,
      referralPath: referralPath ?? this.referralPath,
    );
  }
}
