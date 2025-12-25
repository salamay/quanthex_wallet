class ReferralInfoDto {
  String? referralId;
  String? referralUid;
  String? referreeUid;
  String? referralCreatedAt;
  String? referralUpdatedAt;

  ReferralInfoDto({
    this.referralId,
    this.referralUid,
    this.referreeUid,
    this.referralCreatedAt,
    this.referralUpdatedAt,
  });

  factory ReferralInfoDto.fromJson(Map<String, dynamic> json) {
    return ReferralInfoDto(
      referralId: json['referral_id'],
      referralUid: json['referral_uid'],
      referreeUid: json['referree_uid'],
      referralCreatedAt: json['referral_created_at'],
      referralUpdatedAt: json['referral_updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'referral_id': referralId,
      'referral_uid': referralUid,
      'referree_uid': referreeUid,
      'referral_created_at': referralCreatedAt,
      'referral_updated_at': referralUpdatedAt,
    };
  }

  ReferralInfoDto copyWith({
    String? referralId,
    String? referralUid,
    String? referreeUid,
    String? referralCreatedAt,
    String? referralUpdatedAt,
  }) {
    return ReferralInfoDto(
      referralId: referralId ?? this.referralId,
      referralUid: referralUid ?? this.referralUid,
      referreeUid: referreeUid ?? this.referreeUid,
      referralCreatedAt:
      referralCreatedAt ?? this.referralCreatedAt,
      referralUpdatedAt:
      referralUpdatedAt ?? this.referralUpdatedAt,
    );
  }
}
