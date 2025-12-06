import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/utils/navigator.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const BottomNavBar({super.key, required this.currentIndex, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.sp,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context,
            icon: 'assets/images/home_nav.png', //Icons.home_outlined,

            label: 'Home',
            index: 0,
            isActive: currentIndex == 0,
          ),
          _buildNavItem(
            context,
            icon: 'assets/images/swap_nav.png', // Icons.swap_horiz,
            label: 'Swap',
            index: 1,
            isActive: currentIndex == 1,
          ),
          _buildNavItem(
            context,
            icon: 'assets/images/mine_nav.png', //Icons.diamond_outlined,
            label: 'Mine',
            index: 2,
            isActive: currentIndex == 2,
          ),
          _buildNavItem(
            context,
            icon:
                'assets/images/stake_nav.png', // Icons.account_balance_wallet_outlined,
            label: 'Stake',
            index: 3,
            isActive: currentIndex == 3,
          ),
          _buildNavItem(
            context,
            icon: 'assets/images/settings_nav.png', // Icons.settings_outlined,
            label: 'Settings',
            index: 4,
            isActive: currentIndex == 4,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required icon,
    required String label,
    required int index,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!(index);
        } else {
          // Default navigation
          switch (index) {
            case 0:
              Navigate.toNamed(context, name: '/homeview');
              break;
            case 1:
              Navigate.toNamed(context, name: '/swaptokenview');
              break;
            // Add other routes as needed
          }
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon.runtimeType == IconData)
            Icon(
              icon,
              color: isActive
                  ? const Color(0xFF792A90)
                  : const Color(0xFF9E9E9E),
              size: 24.sp,
            )
          else
            Image.asset(
              icon,
              width: 24.sp,
              height: 24.sp,
              color: isActive
                  ? const Color(0xFF792A90)
                  : const Color(0xFF9E9E9E),
            ),
          4.verticalSpace,
          Text(
            label,
            style: TextStyle(
              color: isActive
                  ? const Color(0xFF792A90)
                  : const Color(0xFF9E9E9E),
              fontSize: 11.sp,
              fontFamily: 'Satoshi',
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
