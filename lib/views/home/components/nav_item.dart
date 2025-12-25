import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class NavItem extends StatelessWidget {
   NavItem({super.key, required this.onTap,required this.icon, required this.label, required this. index, required this. isActive,});

   Function onTap;
   dynamic icon;
   String label;
   int index;
   bool isActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
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
    );;
  }
}
