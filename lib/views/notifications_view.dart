import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/utils/navigator.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  bool _generalNotification = true;
  bool _sound = false;
  bool _vibrate = false;
  bool _appUpdates = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigate.back(context);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back, size: 20.sp),
                        5.horizontalSpace,
                        Text(
                          'Back',
                          style: TextStyle(
                            color: const Color(0xFF2D2D2D),
                            fontSize: 16.sp,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Notifications',
                    style: TextStyle(
                      color: const Color(0xFF2D2D2D),
                      fontSize: 18.sp,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Spacer(),
                  SizedBox(width: 60.sp),
                ],
              ),
            ),
            30.sp.verticalSpace,
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildNotificationItem(
                    title: 'General Notification',
                    value: _generalNotification,
                    onChanged: (value) {
                      setState(() {
                        _generalNotification = value;
                      });
                    },
                  ),
                  _buildNotificationItem(
                    title: 'Sound',
                    value: _sound,
                    onChanged: (value) {
                      setState(() {
                        _sound = value;
                      });
                    },
                  ),
                  _buildNotificationItem(
                    title: 'Vibrate',
                    value: _vibrate,
                    onChanged: (value) {
                      setState(() {
                        _vibrate = value;
                      });
                    },
                  ),
                  _buildNotificationItem(
                    title: 'App Updates',
                    value: _appUpdates,
                    onChanged: (value) {
                      setState(() {
                        _appUpdates = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.sp),
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: const Color(0xFF2D2D2D),
              fontSize: 16.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w600,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF792A90),
          ),
        ],
      ),
    );
  }
}

