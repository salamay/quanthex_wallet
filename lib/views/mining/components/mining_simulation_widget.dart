import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/data/utils/sub/product_utils.dart';

class MiningSimulationWidget extends StatefulWidget {
  final int totalReferrals; // Static hash rate value
  final double
  fluctuationRange; // How much the value can fluctuate (as percentage, e.g., 0.1 for 10%)
  final Duration animationSpeed; // Speed of the animation updates
  final String hashUnit; // Unit to display (e.g., "DH/s", "Hex MH/s")
  double hashRate;

   MiningSimulationWidget({
    super.key,
    required this.totalReferrals,
    required this.fluctuationRange, // Default 15% fluctuation
    this.animationSpeed = const Duration(milliseconds: 500),
    this.hashRate = 0.0,
    this.hashUnit = "Hex MH/s",
  });

  @override
  State<MiningSimulationWidget> createState() => _MiningSimulationWidgetState();
}

class _MiningSimulationWidgetState extends State<MiningSimulationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  final Random _random = Random();
  double _progress = 0.0;
  double _currentValue = 0;
  double _currentHashRate = 0;

  @override
  void initState() {
    super.initState();
    _progress = (widget.totalReferrals / ProductUtils.LEVEL_THREE_REFERRALS) + (_random.nextDouble()*0.1); // Start between 85-95%
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
          double fluctuation = (widget.totalReferrals * widget.fluctuationRange);
          double minValue = widget.totalReferrals - fluctuation;
          double maxValue = widget.totalReferrals + fluctuation;

          // Ensure values don't go too low or too high
          minValue = max(minValue, widget.totalReferrals * 0.95);
          maxValue = min(maxValue, widget.totalReferrals * 1);
          _progress = (_currentValue / ProductUtils.LEVEL_THREE_REFERRALS) + (_random.nextDouble() * 0.05);
          _currentValue = minValue + (_random.nextDouble() * (maxValue - minValue));

          double minHashRate = ProductUtils.LEVEL_ONE_HASHRATE - fluctuation;
          double maxHashRate = ProductUtils.LEVEL_FOUR_HASHRATE + fluctuation;

          // Ensure values don't go too low or too high
          minHashRate = max(minHashRate, widget.hashRate * 0.95);
          maxHashRate = min(maxHashRate, widget.hashRate * 1);
          _currentHashRate = minHashRate + (_random.nextDouble() * (maxHashRate - minHashRate));
          // Update progress bar slightly
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Progress Bar
          Expanded(
            child: AnimatedBuilder(
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
          ),
          8.sp.horizontalSpace,
          // Hash Rate Value
          AnimatedSwitcher(
            duration: widget.animationSpeed,
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AutoSizeText(
                  _currentHashRate.toStringAsFixed(2),
                  key: ValueKey(_currentValue),
                  maxLines: 1,
                  style: TextStyle(
                    color: const Color(0xFF00D4FF),
                    fontSize: 12.sp,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w900,
                
                    letterSpacing: 1,
                    shadows: [
                      Shadow(
                        color: const Color(0xFF00D4FF).withOpacity(0.8),
                         blurRadius: 15,
                         offset: const Offset(0, 0))
                        ],
                  ),
                ),
                8.horizontalSpace,  
                AutoSizeText(
                  widget.hashUnit,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
