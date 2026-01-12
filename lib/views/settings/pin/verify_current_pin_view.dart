import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/data/repository/secure_storage.dart';
import 'package:quanthex/data/utils/logger.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/routes/app_routes.dart';
import 'package:quanthex/widgets/snackbar/my_snackbar.dart';

class VerifyCurrentPinView extends StatefulWidget {
  const VerifyCurrentPinView({super.key});

  @override
  State<VerifyCurrentPinView> createState() => _VerifyCurrentPinViewState();
}

class _VerifyCurrentPinViewState extends State<VerifyCurrentPinView> {
  String _pin = '';
  bool _hasError = false;

  void _onNumberPressed(String number) async {
    if (_pin.length < 4) {
      setState(() {
        _pin += number;
        _hasError = false;
      });

      if (_pin.length == 4) {
        await _verifyPin();
      }
    }
  }

  void _onBackspace() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
        _hasError = false;
      });
    }
  }

  Future<void> _verifyPin() async {
    try {
      String savedPin = await SecureStorage.getInstance().getPin();
      await Future.delayed(Duration(milliseconds: 300));

      if (_pin == savedPin) {
        // PIN is correct, navigate to set new PIN
        Navigate.toNamed(context, name: AppRoutes.setnewpinview);
      } else {
        setState(() {
          _hasError = true;
          _pin = '';
        });
        showMySnackBar(context: context, message: "Incorrect PIN", type: SnackBarType.error);
      }
    } catch (e) {
      logger("Error verifying PIN: $e", runtimeType.toString());
      setState(() {
        _hasError = true;
        _pin = '';
      });
      showMySnackBar(context: context, message: "Error verifying PIN", type: SnackBarType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 5,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigate.back(context);
                    },
                    child: Icon(Icons.arrow_back, size: 17.sp),
                  ),
                  Text(
                    'Back',
                    style: TextStyle(color: const Color(0xFF292929), fontSize: 13.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF9E6FF),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: const Color(0xFFFAEBFF)),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 2,
                      children: [
                        Container(
                          width: 12.8.sp,
                          height: 12.8.sp,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage('assets/images/Union.png'), fit: BoxFit.fill),
                          ),
                        ),
                        5.verticalSpace,
                        Text(
                          'EN',
                          style: TextStyle(color: const Color(0xFF4F4F4F), fontSize: 13.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              30.sp.verticalSpace,
              15.sp.verticalSpace,
              Text(
                'Enter Current PIN',
                style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 19, fontFamily: 'Satoshi', fontWeight: FontWeight.w700, height: 1.16),
              ),
              10.sp.verticalSpace,
              Text(
                'Please enter your current PIN to continue.',
                style: TextStyle(color: const Color(0xFF757575), fontSize: 14, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
              ),
              40.sp.verticalSpace,
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.sp),
                      width: 16.sp,
                      height: 16.sp,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: _hasError ? Colors.red : const Color(0xFF2D2D2D), width: 2),
                        color: index < _pin.length ? const Color(0xFF2D2D2D) : Colors.transparent,
                      ),
                    );
                  }),
                ),
              ),
              if (_hasError) ...[
                15.sp.verticalSpace,
                Center(
                  child: Text(
                    'Incorrect PIN. Please try again.',
                    style: TextStyle(color: Colors.red, fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                  ),
                ),
              ],
              Spacer(),
              // Numeric Keypad
              Padding(
                padding: EdgeInsets.only(bottom: 30.sp),
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_buildKeypadButton('1'), _buildKeypadButton('2'), _buildKeypadButton('3')]),
                    20.sp.verticalSpace,
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_buildKeypadButton('4'), _buildKeypadButton('5'), _buildKeypadButton('6')]),
                    20.sp.verticalSpace,
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_buildKeypadButton('7'), _buildKeypadButton('8'), _buildKeypadButton('9')]),
                    20.sp.verticalSpace,
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_buildKeypadButton('*', isSpecial: true), _buildKeypadButton('0'), _buildKeypadButton('', isBackspace: true)]),
                  ],
                ),
              ),
            ],
          ),
        ),
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
