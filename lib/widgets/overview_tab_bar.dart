import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OverviewTabBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;
  final List<String> tabs;

  const OverviewTabBar({super.key, required this.selectedIndex, required this.onTabSelected, this.tabs = const ['Overview', 'Transactions']});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () => onTabSelected(index),
            child: Container(
              margin: EdgeInsets.only(right: 12.sp),
              padding: EdgeInsets.symmetric(horizontal: 0.sp, vertical: 8.sp),
              decoration: BoxDecoration(color: isSelected ? const Color(0xFFE6B4F5).withOpacity(0.1) : Colors.transparent, borderRadius: BorderRadius.circular(8)),
              child: Text(
                tab,
                style: TextStyle(color: isSelected ? const Color(0xFF792A90) : const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
