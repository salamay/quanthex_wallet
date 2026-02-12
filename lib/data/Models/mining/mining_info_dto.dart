class MiningInfoDto {
  String? minId;
  String? uid;
  String? email;
  String? minCreatedAt;
  String? minUpdatedAt;
  String? minSubscriptionId;
  String? miningTag;
  String? hashRate;
  String? miningWalletHash;
  String? miningWalletAddress;

  MiningInfoDto({
    this.minId,
    this.uid,
    this.email,
    this.minCreatedAt,
    this.minUpdatedAt,
    this.minSubscriptionId,
    this.miningTag,
    this.hashRate,
    this.miningWalletHash,
    this.miningWalletAddress,
  });

  factory MiningInfoDto.fromJson(Map<String, dynamic> json) {
    return MiningInfoDto(
      minId: json['min_id'],
      uid: json['uid'],
      email: json['email'],
      minCreatedAt: json['min_created_at'],
      minUpdatedAt: json['min_updated_at'],
      minSubscriptionId: json['min_subscription_id'],
      miningTag: json['mining_tag'],
      hashRate: json['hash_rate'],
      miningWalletHash: json['mining_wallet_hash'],
      miningWalletAddress: json['mining_wallet_address'],
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
      'mining_tag': miningTag,
      'mining_wallet_hash': miningWalletHash,
      'mining_wallet_address': miningWalletAddress,
    };
  }

  MiningInfoDto copyWith({
    String? minId,
    String? uid,
    String? email,
    String? minCreatedAt,
    String? minUpdatedAt,
    String? minSubscriptionId,
    String? miningTag,
    String? hashRate,
    String? miningWalletHash,
    String? miningWalletAddress,
  }) {
    return MiningInfoDto(
      minId: minId ?? this.minId,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      minCreatedAt: minCreatedAt ?? this.minCreatedAt,
      minUpdatedAt: minUpdatedAt ?? this.minUpdatedAt,
      minSubscriptionId:
      minSubscriptionId ?? this.minSubscriptionId,
      miningTag: miningTag ?? this.miningTag,
      hashRate: hashRate ?? this.hashRate,
      miningWalletHash: miningWalletHash ?? this.miningWalletHash,
      miningWalletAddress: miningWalletAddress ?? this.miningWalletAddress,
    );
  }
}