class NotificationDto {
  String? notiId;
  String? notiUser;
  String? notiTitle;
  String? notiDescription;
  String? notiType;
  String? notiCreatedAt;
  String? notiUpdatedAt;
  bool? notiSeen;
  String? notiSeenAt;

  NotificationDto({this.notiId, this.notiUser, this.notiTitle, this.notiDescription, this.notiType, this.notiCreatedAt, this.notiUpdatedAt, this.notiSeen, this.notiSeenAt});

  factory NotificationDto.fromJson(Map<String, dynamic> json) {
    return NotificationDto(
      notiId: json['noti_id']?.toString(),
      notiUser: json['noti_user']?.toString(),
      notiTitle: json['noti_title']?.toString(),
      notiDescription: json['noti_description']?.toString(),
      notiType: json['noti_type']?.toString(),
      notiCreatedAt: json['noti_created_at']?.toString(),
      notiUpdatedAt: json['noti_updated_at']?.toString(),
      notiSeen: json['noti_seen'],
      notiSeenAt: json['noti_seen_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'noti_id': notiId, 'noti_user': notiUser, 'noti_title': notiTitle, 'noti_description': notiDescription, 'noti_type': notiType, 'noti_created_at': notiCreatedAt, 'noti_updated_at': notiUpdatedAt, 'noti_seen': notiSeen, 'noti_seen_at': notiSeenAt};
  }

  NotificationDto copyWith({String? notiId, String? notiUser, String? notiTitle, String? notiDescription, String? notiType, String? notiCreatedAt, String? notiUpdatedAt, bool? notiSeen, String? notiSeenAt}) {
    return NotificationDto(
      notiId: notiId ?? this.notiId,
      notiUser: notiUser ?? this.notiUser,
      notiTitle: notiTitle ?? this.notiTitle,
      notiDescription: notiDescription ?? this.notiDescription,
      notiType: notiType ?? this.notiType,
      notiCreatedAt: notiCreatedAt ?? this.notiCreatedAt,
      notiUpdatedAt: notiUpdatedAt ?? this.notiUpdatedAt,
      notiSeen: notiSeen ?? this.notiSeen,
      notiSeenAt: notiSeenAt ?? this.notiSeenAt,
    );
  }
}
