import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WhatIsStakingCard extends StatelessWidget {
  final VoidCallback? onLearnMore;

  const WhatIsStakingCard({super.key, this.onLearnMore});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 0.sp),
      padding: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What is Staking?',
                  style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 20.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                ),
                8.verticalSpace,
                Text(
                  'Staking Reward lets you earn daily returns on your capital while still keeping full control of your money. You subscribe to a staking plan, your capital is locked for daily earnings, and you can withdraw it anytime.',
                  style: TextStyle(color: const Color(0xFF757575), fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400, height: 1.4),
                ),
                16.verticalSpace,
                GestureDetector(
                  onTap: onLearnMore,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
                    decoration: BoxDecoration(color: const Color(0xFF2D2D2D), borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      'Stake now',
                      style: TextStyle(color: Colors.white, fontSize: 13.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
          16.horizontalSpace,
          // Illustration
          Container(
            width: 120.sp,
            height: 120.sp,
            decoration: BoxDecoration(color: const Color(0xFFF9E6FF), borderRadius: BorderRadius.circular(12)),
            child: Stack(
              children: [
                // Chart background
                Positioned(
                  top: 10.sp,
                  left: 10.sp,
                  right: 10.sp,
                  bottom: 40.sp,
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                    child: CustomPaint(painter: ChartPainter()),
                  ),
                ),
                // Coins stack
                Positioned(
                  bottom: 5.sp,
                  left: 15.sp,
                  child: Row(mainAxisSize: MainAxisSize.min, children: [_buildCoinStack(const Color(0xFF757575), 20.sp), 4.horizontalSpace, _buildCoinStack(const Color(0xFF792A90), 24.sp), 4.horizontalSpace, _buildCoinStack(const Color(0xFFE6B4F5), 22.sp)]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoinStack(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 2))],
      ),
    );
  }
}

class ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.lineTo(size.width * 0.2, size.height * 0.7);
    path.lineTo(size.width * 0.4, size.height * 0.5);
    path.lineTo(size.width * 0.6, size.height * 0.4);
    path.lineTo(size.width * 0.8, size.height * 0.3);
    path.lineTo(size.width, size.height * 0.2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
