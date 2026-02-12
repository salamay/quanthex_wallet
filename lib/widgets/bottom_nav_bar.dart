import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/data/controllers/home/home_controller.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/views/home/components/nav_item.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const BottomNavBar({super.key, required this.currentIndex, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 70.h,
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
            NavItem(
              onTap: (){
                Provider.of<HomeController>(context,listen: false).changeIndex(0);
              },
              icon: 'assets/images/home_nav.png', //Icons.home_outlined,
              label: 'Home',
              index: 0,
              isActive: currentIndex == 0,
            ),
            NavItem(
              onTap: (){
                Provider.of<HomeController>(context,listen: false).changeIndex(1);
              },
              icon: 'assets/images/swap_nav.png', // Icons.swap_horiz,
              label: 'Swap',
              index: 1,
              isActive: currentIndex == 1,
            ),
            NavItem(
              onTap: (){
                Provider.of<HomeController>(context,listen: false).changeIndex(2);
              },
              icon: 'assets/images/mine_nav.png', //Icons.diamond_outlined,
              label: 'Mine',
              index: 2,
              isActive: currentIndex == 2,
            ),
            NavItem(
              onTap: (){
                Provider.of<HomeController>(context,listen: false).changeIndex(3);
              },
              icon:
                  'assets/images/stake_nav.png', // Icons.account_balance_wallet_outlined,
              label: 'Stake',
              index: 3,
              isActive: currentIndex == 3,
            ),
            NavItem(
              onTap: (){
                Provider.of<HomeController>(context,listen: false).changeIndex(4);
              },
              icon: 'assets/images/settings_nav.png', // Icons.settings_outlined,
              label: 'Settings',
              index: 4,
              isActive: currentIndex == 4,
            ),
          ],
        ),
      ),
    );
  }
}
