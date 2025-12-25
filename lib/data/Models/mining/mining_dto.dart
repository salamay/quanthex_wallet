import 'package:quanthex/data/Models/subscription/subscription_dto.dart';

import 'mining_info_dto.dart';

class MiningDto {
  SubscriptionDto? subscription;
  MiningInfoDto? mining;

  MiningDto({
    this.subscription,
    this.mining,
  });

  factory MiningDto.fromJson(Map<String, dynamic> json) {
    return MiningDto(
      subscription: json['subscription'] != null
          ? SubscriptionDto.fromJson(json['subscription'])
          : null,
      mining: json['mining'] != null
          ? MiningInfoDto.fromJson(json['mining'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subscription': subscription?.toJson(),
      'mining': mining?.toJson(),
    };
  }

  MiningDto copyWith({
    SubscriptionDto? subscription,
    MiningInfoDto? mining,
  }) {
    return MiningDto(
      subscription: subscription ?? this.subscription,
      mining: mining ?? this.mining,
    );
  }
}