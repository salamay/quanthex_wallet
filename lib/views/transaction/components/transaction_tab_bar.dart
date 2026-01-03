import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransactionTabBar extends StatelessWidget {
  final String selectedTab;
  final Function(String) onTabSelected;

  const TransactionTabBar({super.key, required this.selectedTab, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    final tabs = ['All', 'In', 'Out'];

    return Container(
      child: Row(
        children: tabs.map((tab) {
          final isSelected = selectedTab == tab;
          return GestureDetector(
            onTap: () => onTabSelected(tab),
            child: Container(
              margin: EdgeInsets.only(right: 30.sp),
              padding: EdgeInsets.only(bottom: 8.sp),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: isSelected ? const Color(0xFF792A90) : Colors.transparent, width: 2)),
              ),
              child: Text(
                tab,
                style: TextStyle(color: isSelected ? const Color(0xFF792A90) : const Color(0xFF757575), fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
