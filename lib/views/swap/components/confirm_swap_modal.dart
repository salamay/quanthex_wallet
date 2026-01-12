// Confirm Swap Modal
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/views/swap/components/swap_success_modal.dart';

class ConfirmSwapModal extends StatefulWidget {
  final String fromToken;
  final String toToken;
  final double fromAmount;
  final double toAmount;

  const ConfirmSwapModal({super.key, required this.fromToken, required this.toToken, required this.fromAmount, required this.toAmount});

  @override
  State<ConfirmSwapModal> createState() => _ConfirmSwapModalState();
}

class _ConfirmSwapModalState extends State<ConfirmSwapModal> {
  String _pin = '';

  void _onNumberPressed(String number) {
    if (_pin.length < 6) {
      setState(() {
        _pin += number;
      });

      if (_pin.length == 6) {
        // Show success modal
        Future.delayed(Duration(milliseconds: 300), () {
          Navigator.pop(context);
          _showSuccessModal();
        });
      }
    }
  }

  void _onBackspace() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  void _showSuccessModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SwapSuccessModal(fromToken: widget.fromToken, toToken: widget.toToken),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.all(24.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.sp,
            height: 4.sp,
            margin: EdgeInsets.only(bottom: 20.sp),
            decoration: BoxDecoration(color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(2)),
          ),
          Text(
            'Confirm Swap',
            style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 20.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
          ),
          30.sp.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 8.sp),
                width: 16.sp,
                height: 16.sp,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF2D2D2D), width: 2),
                  color: index < _pin.length ? const Color(0xFF2D2D2D) : Colors.transparent,
                ),
              );
            }),
          ),
          15.sp.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.face, size: 18.sp, color: const Color(0xFF792A90)),
              8.horizontalSpace,
              Text(
                'Use Face ID Instead',
                style: TextStyle(color: const Color(0xFF792A90), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
              ),
            ],
          ),
          30.sp.verticalSpace,
          // Keypad
          Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_buildKeypadButton('1'), _buildKeypadButton('2'), _buildKeypadButton('3')]),
              15.sp.verticalSpace,
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_buildKeypadButton('4'), _buildKeypadButton('5'), _buildKeypadButton('6')]),
              15.sp.verticalSpace,
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_buildKeypadButton('7'), _buildKeypadButton('8'), _buildKeypadButton('9')]),
              15.sp.verticalSpace,
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_buildKeypadButton('*', isSpecial: true), _buildKeypadButton('0'), _buildKeypadButton('', isBackspace: true)]),
            ],
          ),
          20.sp.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildKeypadButton(String text, {bool isSpecial = false, bool isBackspace = false}) {
    return GestureDetector(
      onTap: () {
        if (isBackspace) {
          _onBackspace();
        } else if (text.isNotEmpty) {
          _onNumberPressed(text);
        }
      },
      child: Container(
        width: 70.sp,
        height: 70.sp,
        decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: isBackspace
              ? Icon(Icons.backspace_outlined, color: const Color(0xFF2D2D2D), size: 24.sp)
              : Text(
                  text,
                  style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 24.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                ),
        ),
      ),
    );
  }
}
