import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/data/utils/product_utils.dart';

class MiningSimulationWidget extends StatefulWidget {
  final double baseHashRate; // Static hash rate value
  final double
  fluctuationRange; // How much the value can fluctuate (as percentage, e.g., 0.1 for 10%)
  final Duration animationSpeed; // Speed of the animation updates
  final String hashUnit; // Unit to display (e.g., "DH/s", "Hex MH/s")
  final String title; // Title to display (e.g., "DIGIT HASH")
  final String subtitle; // Subtitle to display

  const MiningSimulationWidget({
    super.key,
    required this.baseHashRate,
    this.fluctuationRange = 0.15, // Default 15% fluctuation
    this.animationSpeed = const Duration(milliseconds: 500),
    this.hashUnit = "DH/s",
    this.title = "QUANTHEX HASH",
    this.subtitle = "MINING ENGINE.",
  });

  @override
  State<MiningSimulationWidget> createState() => _MiningSimulationWidgetState();
}

class _MiningSimulationWidgetState extends State<MiningSimulationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  double _currentHashRate = 0;
  final Random _random = Random();
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _currentHashRate = widget.baseHashRate;
    _progress = (_currentHashRate / ProductUtils.LEVEL_SIX_HASHRATE) + (_random.nextDouble() * 0.1); // Start between 85-95%
    print("progress: $_progress");
    _controller = AnimationController(
      duration: widget.animationSpeed,
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.85,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat(reverse: true);
    _updateHashRate();
  }

  void _updateHashRate() {
    Future.delayed(widget.animationSpeed, () {
      if (mounted) {
        setState(() {
          // Generate a random fluctuation around the base value
          double fluctuation = (widget.baseHashRate * widget.fluctuationRange);
          double minValue = widget.baseHashRate - fluctuation;
          double maxValue = widget.baseHashRate + fluctuation;

          // Ensure values don't go too low or too high
          minValue = max(minValue, widget.baseHashRate * 0.85);
          maxValue = min(maxValue, widget.baseHashRate * 1.15);

          _currentHashRate =
              minValue + (_random.nextDouble() * (maxValue - minValue));

          // Update progress bar slightly
          _progress = (_currentHashRate / ProductUtils.LEVEL_SIX_HASHRATE) + (_random.nextDouble() * 0.1);
        });
        _updateHashRate();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.sp),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFF792A90), const Color(0xFF1A1F3A)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text(
            widget.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 32.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              shadows: [
                Shadow(
                  color: const Color(0xFF00D4FF).withOpacity(0.8),
                  blurRadius: 10,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
          ),
          8.sp.verticalSpace,
          // Subtitle
          Text(
            widget.subtitle,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          30.sp.verticalSpace,
          // Progress Bar
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Container(
                height: 8.sp,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black.withOpacity(0.3),
                ),
                child: Stack(
                  children: [
                    // Background
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ),
                    // Filled portion
                    FractionallySizedBox(
                      widthFactor: _progress,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF792A90),
                              const Color(0xFF0099CC),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00D4FF).withOpacity(0.6),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          20.sp.verticalSpace,
          // Hash Rate Label
          Text(
            "Hash Rate",
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
            ),
          ),
          8.sp.verticalSpace,
          // Hash Rate Value
          AnimatedSwitcher(
            duration: widget.animationSpeed,
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: AutoSizeText(
              '${_currentHashRate.toStringAsFixed(2)} ${widget.hashUnit}',
              key: ValueKey(_currentHashRate),
              maxLines: 1,
              style: TextStyle(
                color: const Color(0xFF00D4FF),
                fontSize: 30.sp,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w900,

                letterSpacing: 1,
                shadows: [
                  Shadow(
                    color: const Color(0xFF00D4FF).withOpacity(0.8),
                    blurRadius: 15,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
