import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ArrowBack extends StatelessWidget {
  ArrowBack({this.icon, this.iconColor,super.key});
  IconData? icon;
  Color? iconColor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pop();
      },
      child: Padding(
        padding: EdgeInsets.all(8.sp),
        child: Icon(icon ?? Icons.arrow_back, color:iconColor?? Theme.of(context).iconTheme.color!, size: 20.sp),
      ),
    );
  }
}
