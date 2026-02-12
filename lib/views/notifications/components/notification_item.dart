import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:quanthex/data/Models/notifications/notification_dto.dart';
import 'package:quanthex/data/utils/date_utils.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/widgets/global/empty_view.dart';

class NotificationItem extends StatelessWidget {
  final NotificationDto notification;
  final String svgIcon;
  final Color iconColor;
  final VoidCallback onMarkAsRead;
  final VoidCallback onDelete;

  const NotificationItem({required this.notification, required this.svgIcon, required this.iconColor, required this.onMarkAsRead, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final isRead = notification.notiSeen ?? false;
    return Container(
      margin: EdgeInsets.only(bottom: 12.sp),
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: isRead?Colors.white : Color(0xFFF5F5F5), 
        borderRadius: BorderRadius.circular(12)
        ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 40.sp,
            height: 40.sp,
            decoration: BoxDecoration(color: iconColor.withOpacity(0.1), shape: BoxShape.circle),
            padding: EdgeInsets.all(10.sp),
            child: Center(child: SvgPicture.asset(svgIcon, width: 20.sp, height: 20.sp)),
          ),
          12.horizontalSpace,
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.notiTitle ?? 'Notification',
                  style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                4.sp.verticalSpace,
                Text(
                  notification.notiDescription ?? '',
                  style: TextStyle(color: const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                8.sp.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      notification.notiCreatedAt != null ? MyDateUtils.formatDate(int.parse(notification.notiCreatedAt??"")) : '',
                      style: TextStyle(color: const Color(0xFF757575), fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                    ),
                    Row(
                      children: [
                        if (!isRead)
                          GestureDetector(
                            onTap: onMarkAsRead,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check, size: 14.sp, color: const Color(0xFF2D2D2D)),
                                4.horizontalSpace,
                                Text(
                                  'Mark read',
                                  style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        12.horizontalSpace,
                        // GestureDetector(
                        //   onTap: onDelete,
                        //   child: Icon(Icons.close, size: 18.sp, color: const Color(0xFF757575)),
                        // ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
