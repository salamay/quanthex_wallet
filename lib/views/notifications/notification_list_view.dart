import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/core/constants/sub_constants.dart';
import 'package:quanthex/data/Models/notifications/notification_dto.dart';
import 'package:quanthex/data/controllers/notification/notification_controller.dart';
import 'package:quanthex/data/utils/logger.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/views/notifications/components/notification_item.dart';
import 'package:quanthex/widgets/global/empty_view.dart';
import 'package:quanthex/widgets/global/error_modal.dart';
import 'package:quanthex/widgets/loading_overlay/loading.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';

class NotificationListView extends StatefulWidget {
  const NotificationListView({super.key});

  @override
  State<NotificationListView> createState() => _NotificationListViewState();
}

class _NotificationListViewState extends State<NotificationListView> {
  late NotificationController notificationController;
  int offset = 0;
  bool _hasError = false;
  bool _isMax = false;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    notificationController = Provider.of<NotificationController>(context, listen: false);
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
     try {
      _hasError = false;
      _isLoading = true;
      setState(() {});
      if (!mounted) {
        return;
      }

      // List<UserMessage> results=await getChats(context, offset);
      offset = notificationController.notifications.length;
      logger("Offset: $offset", 'NotificationListView');

      List<NotificationDto> results = await notificationController.fetchNotifications(offset: offset, limit: 25);
      if (results.isEmpty) {
        _isMax = true;
      }
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      logger("Error fetching data: $error", 'MyFriends');
      _hasError = true;
      _isLoading = false;
      setState(() {});
    }
  }

  int get _unreadCount => notificationController.notifications.where((n) => !(n.notiSeen ?? false)).length;

  Future<void> _markAllAsRead() async {
    
    }

  Future<void> _markAsRead(String id) async {
      await notificationController.markAsRead(id);

  }

  Future<void> _deleteNotification(String id) async {
    // TODO: Replace with actual API call
    setState(() {
      notificationController.notifications.removeWhere((n) => n.notiId == id);
    });
  }

  String _getIconForType(String? type) {
    logger("Type: $type", "NotificationListView");
    switch (type) {
      case withrawal_notification:
        return "assets/svgs/out.svg";
      case staking_notification:
        return "assets/svgs/stake.svg";
      case subscription_notification:
        return "assets/svgs/subscription.svg";
      case mining_notification:
        return "assets/svgs/mining.svg";
      default:
        return "assets/svgs/notification_unread.svg";
    }
  }

  Color _getIconColorForType(String? type) {
    switch (type) {
      case withrawal_notification:
        return const Color(0xFF4CAF50); // Green
      case staking_notification:
        return const Color(0xFF2196F3); // Blue
      case subscription_notification:
        return const Color(0xFF4CAF50); // Green
      case mining_notification:
        return const Color(0xFF4CAF50); // Green
      default:
        return const Color(0xFF757575); // Gray
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.sp.verticalSpace,
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigate.back(context);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.arrow_back, size: 20.sp, color: const Color(0xFF2D2D2D)),
                            5.horizontalSpace,
                            Text(
                              'Back',
                              style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      // Spacer(),
                      // GestureDetector(
                      //   onTap: _markAllAsRead,
                      //   child: Text(
                      //     'Mark all read',
                      //     style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                      //   ),
                      // ),
                    ],
                  ),
                  10.sp.verticalSpace,
                  Text(
                    'Notifications',
                    style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 24.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                  ),
                  4.sp.verticalSpace,
                  Text(
                    '$_unreadCount unread notifications',
                    style: TextStyle(color: const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            20.sp.verticalSpace,
            // Notifications List
            Expanded(
              child: Consumer<NotificationController>(
                builder: (context, notiCtr, child) {
                  return InfiniteList(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20.sp),
                    itemCount: notiCtr.notifications.length,
                    isLoading: _isLoading,
                    hasReachedMax: _isMax, // 👈 prevents extra calls
                    hasError: _hasError,
                    centerEmpty: true,
                    onFetchData: _loadNotifications,
                    separatorBuilder: (context, index) => const SizedBox(),
                    emptyBuilder: (context) => _isLoading ? const SizedBox() : EmptyView(message: 'No notifications found'),
                    loadingBuilder: (context) => Loading(),
                    centerError: true,
                    centerLoading: true,
                    errorBuilder: (context) {
                      return ErrorModal(
                        callBack: () {
                          _hasError = false;
                          _isLoading = true;
                          setState(() {});
                          _loadNotifications();
                        },
                      );
                    },
                    itemBuilder: (BuildContext context, int index) {
                    final notification = notiCtr.notifications[index];
                      return NotificationItem(notification: notification, svgIcon: _getIconForType(notification.notiType), iconColor: _getIconColorForType(notification.notiType), onMarkAsRead: () => _markAsRead(notification.notiId ?? ''), onDelete: () => _deleteNotification(notification.notiId ?? ''));
                          
                    },
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
