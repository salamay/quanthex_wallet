import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/data/controllers/assets/asset_controller.dart';
import 'package:quanthex/data/controllers/balance/balance_controller.dart';
import 'package:quanthex/data/controllers/home/home_controller.dart';
import 'package:quanthex/data/controllers/mining/mining_controller.dart';
import 'package:quanthex/data/controllers/notification/notification_controller.dart';
import 'package:quanthex/data/controllers/user/user_controller.dart';
import 'package:quanthex/data/controllers/wallet_controller.dart';
import 'package:quanthex/data/repository/my_local_storage.dart';
import 'package:quanthex/data/repository/secure_storage.dart';
import 'package:quanthex/data/services/auth/auth_service.dart';
import 'package:quanthex/data/utils/logger.dart';
import 'package:quanthex/routes/app_routes.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/widgets/quanthex_image_banner.dart';
import 'package:quanthex/widgets/snackbar/my_snackbar.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Settings',
                style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 22.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        // Quanthex Image Banner
        QuanthexImageBanner(),
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
                    Navigate.toNamed(context, name: AppRoutes.walletsview);
                  },
                  context: context,
                ),
                _buildSettingItem(
                  icon: Icons.call_made,
                  iconColor: Colors.blue,
                  title: 'Withdrawals',
                  onTap: () {
                    Navigate.toNamed(context, name: AppRoutes.withdrawalsview);
                  },
                  context: context,
                ),
                // _buildSettingItem(
                //   icon: Icons.grid_view,
                //   iconColor: Colors.orange,
                //   title: 'General',
                //   onTap: () {
                //     Navigate.toNamed(context, name: '/generalsettingsview');
                //   },
                //   context: context,
                // ),
                _buildSettingItem(
                  icon: Icons.security,
                  iconColor: const Color(0xFF792A90),
                  title: 'Security & Privacy',
                  onTap: () {
                    Navigate.toNamed(context, name: AppRoutes.securityprivacyview);
                  },
                  context: context,
                ),
                // _buildSettingItem(
                //   icon: Icons.lightbulb_outline,
                //   iconColor: Colors.red,
                //   title: 'Dark Mode',
                //   hasToggle: true,
                //   toggleValue: false,
                //   onToggle: (value) {
                //     // Handle dark mode toggle
                //   },
                //   context: context,
                // ),
                // _buildSettingItem(
                //   icon: Icons.notifications_outlined,
                //   iconColor: const Color(0xFF792A90),
                //   title: 'Notification',
                //   onTap: () {
                //     Navigate.toNamed(context, name: '/notificationsview');
                //   },
                //   context: context,
                // ),
                // _buildSettingItem(
                //   icon: Icons.help_outline,
                //   iconColor: Colors.red,
                //   title: 'Help Center',
                //   onTap: () {
                //     // Navigate to help center
                //   },
                //   context: context,
                // ),
                // _buildSettingItem(
                //   icon: Icons.share,
                //   iconColor: Colors.green,
                //   title: 'Refer and Earn',
                //   onTap: () {
                //     Navigate.toNamed(context, name: '/referearnview');
                //   },
                //   context: context,
                // ),
                40.sp.verticalSpace,
                // Log Out Button
                GestureDetector(
                  onTap: () {
                    _showLogoutConfirmationBottomSheet(context);
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
                        style: TextStyle(color: Colors.red, fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                40.sp.verticalSpace,
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showLogoutConfirmationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.all(24.sp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.sp,
              height: 4.sp,
              margin: EdgeInsets.only(bottom: 20.sp),
              decoration: BoxDecoration(color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(2)),
            ),
            Text(
              'Log Out',
              style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 20.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
            ),
            16.sp.verticalSpace,
            Text(
              'Are you sure you want to log out?',
              textAlign: TextAlign.center,
              style: TextStyle(color: const Color(0xFF757575), fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
            ),
            30.sp.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(modalContext);
                    },
                    child: Container(
                      height: 50.sp,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'No',
                          style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
                16.horizontalSpace,
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(modalContext);
                      _performLogout(context);
                    },
                    child: Container(
                      height: 50.sp,
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                      child: Center(
                        child: Text(
                          'Yes',
                          style: TextStyle(color: Colors.white, fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            20.sp.verticalSpace,
          ],
        ),
      ),
    );
  }

  Future<void> _performLogout(BuildContext context) async {
    try {
      await SecureStorage.getInstance().clear();
      await MyLocalStorage().clear();
      Provider.of<WalletController>(context, listen: false).clear();
      Provider.of<AssetController>(context, listen: false).clear();
      Provider.of<BalanceController>(context, listen: false).clear();
      Provider.of<HomeController>(context, listen: false).clear();
      Provider.of<UserController>(context, listen: false).clear();
      Provider.of<NotificationController>(context, listen: false).clear();
      Provider.of<MiningController>(context, listen: false).clear();
      AuthService.getInstance().authToken = "";
      
      Navigate.go(context, name: AppRoutes.landingview);
    } catch (e) {
      logger("Error logging out", runtimeType.toString());
      showMySnackBar(context: context, message: "Failed to log out", type: SnackBarType.error);
    }
  }

  Widget _buildSettingItem({required IconData icon, required Color iconColor, required String title, VoidCallback? onTap, bool hasToggle = false, bool toggleValue = false, Function(bool)? onToggle, context}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // margin: EdgeInsets.only(bottom: 16.sp),
        padding: EdgeInsets.only(left: 16.sp, top: 12.sp, bottom: 12.sp, right: 16.sp),
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
                  decoration: BoxDecoration(color: iconColor.withOpacity(0.1), shape: BoxShape.circle),
                  child: Icon(icon, color: iconColor, size: 24.sp),
                ),
                15.horizontalSpace,
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                  ),
                ),
                if (hasToggle) Switch(value: toggleValue, onChanged: onToggle, activeTrackColor: const Color(0xFF792A90), activeThumbColor: const Color(0xFF792A90)) else Icon(Icons.chevron_right, color: const Color(0xFF757575), size: 24.sp),
              ],
            ),
            12.sp.verticalSpace,
            Container(height: 1, width: MediaQuery.sizeOf(context).width, color: Color(0xffEEEEEE)),
          ],
        ),
      ),
    );
  }
}
