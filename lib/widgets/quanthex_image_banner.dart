import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuanthexImageBanner extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxFit fit;
  final EdgeInsets? margin;

  const QuanthexImageBanner({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 20.sp,
      height: height ?? 20.sp,
      child: Image.asset(
        'assets/images/quanthex.png',
        fit: fit,
        width: width,
        height: height,
      ),
    );
  }
}
