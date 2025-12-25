import 'package:quanthex/data/Models/users/profile_dto.dart';
import 'package:quanthex/data/Models/users/referral_info_dto.dart';

class ReferralDto {
  ReferralInfoDto? info;
  ProfileDto? profile;

  ReferralDto({
    this.info,
    this.profile,
  });

  factory ReferralDto.fromJson(Map<String, dynamic> json) {
    return ReferralDto(
      info: json['info'] != null
          ? ReferralInfoDto.fromJson(json['info'])
          : null,
      profile: json['profile'] != null
          ? ProfileDto.fromJson(json['profile'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'info': info?.toJson(),
      'profile': profile?.toJson(),
    };
  }

  ReferralDto copyWith({
    ReferralInfoDto? info,
    ProfileDto? profile,
  }) {
    return ReferralDto(
      info: info ?? this.info,
      profile: profile ?? this.profile,
    );
  }
}
