import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConfirmPinModal extends StatefulWidget {
  final String title;
  final int pinLength;
  final Function(String)? onPinComplete;
  final bool showFaceId;

  const ConfirmPinModal({
    super.key,
    this.title = 'Confirm Pay',
    this.pinLength = 5,
    this.onPinComplete,
    this.showFaceId = true,
  });

  @override
  State<ConfirmPinModal> createState() => _ConfirmPinModalState();
}

class _ConfirmPinModalState extends State<ConfirmPinModal> {
  String _pin = '';

  void _onNumberPressed(String number) {
    if (_pin.length < widget.pinLength) {
      setState(() {
        _pin += number;
      });

      if (_pin.length == widget.pinLength) {
        Future.delayed(Duration(milliseconds: 300), () {
          if (widget.onPinComplete != null) {
            widget.onPinComplete!(_pin);
          }
          // Navigator.pop(context, _pin);
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 550.sp,
      child: Column(
        children: [
          10.sp.verticalSpace,
          Container(
            width: 40.sp,
            height: 4.sp,
            margin: EdgeInsets.only(bottom: 20.sp),
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          2.sp.verticalSpace,
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF595959),
              fontSize: 15.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w700,
              height: 1.47,
              letterSpacing: -0.41,
            ),
          ),
          20.sp.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.pinLength, (index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 8.sp),
                width: 16.sp,
                height: 16.sp,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF2D2D2D), width: 2),
                  color: index < _pin.length
                      ? const Color(0xFF2D2D2D)
                      : Colors.transparent,
                ),
              );
            }),
          ),
          if (widget.showFaceId) ...[
            15.sp.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.face, size: 18.sp, color: const Color(0xFF792A90)),
                8.horizontalSpace,
                Text(
                  'Use Face ID Instead',
                  style: TextStyle(
                    color: const Color(0xFF792A90),
                    fontSize: 14.sp,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
          30.sp.verticalSpace,
          // Keypad
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildKeypadButton('1'),
                  _buildKeypadButton('2'),
                  _buildKeypadButton('3'),
                ],
              ),
              15.sp.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildKeypadButton('4'),
                  _buildKeypadButton('5'),
                  _buildKeypadButton('6'),
                ],
              ),
              15.sp.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildKeypadButton('7'),
                  _buildKeypadButton('8'),
                  _buildKeypadButton('9'),
                ],
              ),
              15.sp.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildKeypadButton('*', isSpecial: true),
                  _buildKeypadButton('0'),
                  _buildKeypadButton('', isBackspace: true),
                ],
              ),
            ],
          ),
          20.sp.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildKeypadButton(
    String text, {
    bool isSpecial = false,
    bool isBackspace = false,
  }) {
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
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: isBackspace
              ? Icon(
                  Icons.backspace_outlined,
                  color: const Color(0xFF2D2D2D),
                  size: 24.sp,
                )
              : Text(
                  text,
                  style: TextStyle(
                    color: const Color(0xFF2D2D2D),
                    fontSize: 24.sp,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      ),
    );
  }
}

