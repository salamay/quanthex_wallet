import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TokensSectionHeader extends StatelessWidget {
  final String? selectedFilter;
  final VoidCallback? onFilterTap;

  const TokensSectionHeader({super.key, this.selectedFilter, this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Tokens',
            style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 20.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
          ),
          // GestureDetector(
          //   onTap: onFilterTap,
          //   child: Container(
          //     padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 6.sp),
          //     decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(8)),
          //     child: Row(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         Text(
          //           selectedFilter ?? 'Balance',
          //           style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 13.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
          //         ),
          //         4.horizontalSpace,
          //         Icon(Icons.keyboard_arrow_down, size: 18.sp, color: const Color(0xFF757575)),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
