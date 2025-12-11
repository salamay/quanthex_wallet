import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/utils/navigator.dart';
import 'package:quanthex/widgets/bottom_nav_bar.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

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
                    'Settings',
                    style: TextStyle(
                      color: const Color(0xFF2D2D2D),
                      fontSize: 22.sp,
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
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildSettingItem(
                      icon: Icons.account_balance_wallet,
                      iconColor: Colors.green,
                      title: 'Wallets',
                      onTap: () {
                        Navigate.toNamed(context, name: '/walletsview');
                      },
                      context: context,
                    ),
                    _buildSettingItem(
                      icon: Icons.grid_view,
                      iconColor: Colors.orange,
                      title: 'General',
                      onTap: () {
                        Navigate.toNamed(context, name: '/generalsettingsview');
                      },
                      context: context,
                    ),
                    _buildSettingItem(
                      icon: Icons.security,
                      iconColor: const Color(0xFF792A90),
                      title: 'Security & Privacy',
                      onTap: () {
                        Navigate.toNamed(context, name: '/securityprivacyview');
                      },
                      context: context,
                    ),
                    _buildSettingItem(
                      icon: Icons.lightbulb_outline,
                      iconColor: Colors.red,
                      title: 'Dark Mode',
                      hasToggle: true,
                      toggleValue: false,
                      onToggle: (value) {
                        // Handle dark mode toggle
                      },
                      context: context,
                    ),
                    _buildSettingItem(
                      icon: Icons.notifications_outlined,
                      iconColor: const Color(0xFF792A90),
                      title: 'Notification',
                      onTap: () {
                        Navigate.toNamed(context, name: '/notificationsview');
                      },
                      context: context,
                    ),
                    _buildSettingItem(
                      icon: Icons.help_outline,
                      iconColor: Colors.red,
                      title: 'Help Center',
                      onTap: () {
                        // Navigate to help center
                      },
                      context: context,
                    ),
                    _buildSettingItem(
                      icon: Icons.share,
                      iconColor: Colors.green,
                      title: 'Refer and Earn',
                      onTap: () {
                        Navigate.toNamed(context, name: '/referearnview');
                      },
                      context: context,
                    ),
                    40.sp.verticalSpace,
                    // Log Out Button
                    GestureDetector(
                      onTap: () {
                        Navigate.backAll(context);
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50.sp,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Log Out',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16.sp,
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    40.sp.verticalSpace,
                  ],
                ),
              ),
            ),
            BottomNavBar(currentIndex: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    VoidCallback? onTap,
    bool hasToggle = false,
    bool toggleValue = false,
    Function(bool)? onToggle,
    context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // margin: EdgeInsets.only(bottom: 16.sp),
        padding: EdgeInsets.only(
          left: 16.sp,
          top: 12.sp,
          bottom: 12.sp,
          right: 16.sp,
        ),
        decoration: BoxDecoration(
          // color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 40.sp,
                  height: 40.sp,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 24.sp),
                ),
                15.horizontalSpace,
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: const Color(0xFF2D2D2D),
                      fontSize: 16.sp,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (hasToggle)
                  Switch(
                    value: toggleValue,
                    onChanged: onToggle,
                    activeTrackColor: const Color(0xFF792A90),
                    activeThumbColor: const Color(0xFF792A90),
                  )
                else
                  Icon(
                    Icons.chevron_right,
                    color: const Color(0xFF757575),
                    size: 24.sp,
                  ),
              ],
            ),
            12.sp.verticalSpace,
            Container(
              height: 1,
              width: MediaQuery.sizeOf(context).width,
              color: Color(0xffEEEEEE),
            ),
          ],
        ),
      ),
    );
  }
}
