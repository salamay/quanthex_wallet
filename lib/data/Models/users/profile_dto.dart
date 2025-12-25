class ProfileDto {
  String? uid;
  String? email;
  String? accountStatus;
  String? profileCreatedAt;
  String? profileUpdatedAt;
  String? pin;
  String? referralCode;
  dynamic roles;

  ProfileDto({
    this.uid,
    this.email,
    this.accountStatus,
    this.profileCreatedAt,
    this.profileUpdatedAt,
    this.pin,
    this.referralCode,
    this.roles,
  });

  factory ProfileDto.fromJson(Map<String, dynamic> json) {
    return ProfileDto(
      uid: json['uid'],
      email: json['email'],
      accountStatus: json['account_status'],
      profileCreatedAt: json['profile_created_at'],
      profileUpdatedAt: json['profile_updated_at'],
      pin: json['pin'],
      referralCode: json['referral_code'],
      roles: json['roles'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'account_status': accountStatus,
      'profile_created_at': profileCreatedAt,
      'profile_updated_at': profileUpdatedAt,
      'pin': pin,
      'referral_code': referralCode,
      'roles': roles,
    };
  }

  ProfileDto copyWith({
    String? uid,
    String? email,
    String? accountStatus,
    String? profileCreatedAt,
    String? profileUpdatedAt,
    String? pin,
    String? referralCode,
    dynamic roles,
  }) {
    return ProfileDto(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      accountStatus: accountStatus ?? this.accountStatus,
      profileCreatedAt:
      profileCreatedAt ?? this.profileCreatedAt,
      profileUpdatedAt:
      profileUpdatedAt ?? this.profileUpdatedAt,
      pin: pin ?? this.pin,
      referralCode: referralCode ?? this.referralCode,
      roles: roles ?? this.roles,
    );
  }
}
