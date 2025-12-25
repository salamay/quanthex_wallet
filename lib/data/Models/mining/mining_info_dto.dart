class MiningInfoDto {
  String? minId;
  String? uid;
  String? email;
  String? minCreatedAt;
  String? minUpdatedAt;
  String? minSubscriptionId;
  String? hashRate;

  MiningInfoDto({
    this.minId,
    this.uid,
    this.email,
    this.minCreatedAt,
    this.minUpdatedAt,
    this.minSubscriptionId,
    this.hashRate,
  });

  factory MiningInfoDto.fromJson(Map<String, dynamic> json) {
    return MiningInfoDto(
      minId: json['min_id'],
      uid: json['uid'],
      email: json['email'],
      minCreatedAt: json['min_created_at'],
      minUpdatedAt: json['min_updated_at'],
      minSubscriptionId: json['min_subscription_id'],
      hashRate: json['hash_rate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min_id': minId,
      'uid': uid,
      'email': email,
      'min_created_at': minCreatedAt,
      'min_updated_at': minUpdatedAt,
      'min_subscription_id': minSubscriptionId,
      'hash_rate': hashRate,
    };
  }

  MiningInfoDto copyWith({
    String? minId,
    String? uid,
    String? email,
    String? minCreatedAt,
    String? minUpdatedAt,
    String? minSubscriptionId,
    String? hashRate,
  }) {
    return MiningInfoDto(
      minId: minId ?? this.minId,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      minCreatedAt: minCreatedAt ?? this.minCreatedAt,
      minUpdatedAt: minUpdatedAt ?? this.minUpdatedAt,
      minSubscriptionId:
      minSubscriptionId ?? this.minSubscriptionId,
      hashRate: hashRate ?? this.hashRate,
    );
  }
}