import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color,
    this.textColor,
    this.padding,
  });

  final String text;
  final Function onTap;
  final Color? color, textColor;
  final EdgeInsetsGeometry? padding;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        widget.onTap();
      },
      child: Container(
        width: 333.sp,
        height: 50.sp,
        padding: widget.padding ??const EdgeInsets.symmetric( vertical: 9),
        decoration: ShapeDecoration(
          color: widget.color ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              color: widget.textColor ?? const Color(0xFF792A90),
              fontSize: 15.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w700,
              letterSpacing: -0.41,
            ),
          ),
        ),
      ),
    );
  }
}
