import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:quanthex/data/repository/secure_storage.dart';
import 'package:quanthex/routes/app_routes.dart';
import 'package:quanthex/utils/logger.dart';
import 'package:quanthex/utils/navigator.dart';
import 'package:quanthex/widgets/app_button.dart';

class SetPinView extends StatefulWidget {
  final bool isImport; // To determine which success modal to show

  SetPinView({super.key, this.isImport = false});

  @override
  State<SetPinView> createState() => _SetPinViewState();
}

class _SetPinViewState extends State<SetPinView> {
  String _pin = '';

  void _onNumberPressed(String number)async {
    if (_pin.length < 4) {
      setState(() {
        _pin += number;
      });
      // Auto-navigate when PIN is complete
      if (_pin.length == 4) {
        try{
          context.loaderOverlay.show();
          await SecureStorage.getInstance().savePin(_pin);
          context.loaderOverlay.hide();
          await _showSuccessModal();
          Navigate.go(context, name: AppRoutes.homepage);

        }catch(e){
          context.loaderOverlay.hide();
          logger("", runtimeType.toString());
        }

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

  Future<void> _showSuccessModal()async {
    await showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => SuccessModal(isImport: widget.isImport),
      isScrollControlled: true,
    );
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
                    style: TextStyle(
                      color: const Color(0xFF292929),
                      fontSize: 13.sp,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF9E6FF),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          color: const Color(0xFFFAEBFF),
                        ),
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
                            image: DecorationImage(
                              image: AssetImage('assets/images/Union.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        5.verticalSpace,
                        Text(
                          'EN',
                          style: TextStyle(
                            color: const Color(0xFF4F4F4F),
                            fontSize: 13.sp,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              30.sp.verticalSpace,
              Center(
                child: SizedBox(
                  width: 228.sp,
                  child: Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          borderRadius: BorderRadius.circular(30),
                          minHeight: 8,
                          value: 1.0, // 4/4
                          backgroundColor: const Color(0xFFF9E6FF),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            const Color(0xFF792A90),
                          ),
                        ),
                      ),
                      15.horizontalSpace,
                      Text(
                        '4 / 4',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF454545),
                          fontSize: 10.sp,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              15.sp.verticalSpace,
              Text(
                'Set Up Your PIN',
                style: TextStyle(
                  color: const Color(0xFF2D2D2D),
                  fontSize: 19,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                  height: 1.16,
                ),
              ),
              10.sp.verticalSpace,
              Text(
                'Create a secure PIN to protect your wallet and authorize transactions. Choose a PIN you can remember, but keep it private—no one else should have access.',
                style: TextStyle(
                  color: const Color(0xFF757575),
                  fontSize: 14,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w500,
                ),
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
                        border: Border.all(
                          color: const Color(0xFF2D2D2D),
                          width: 2,
                        ),
                        color: index < _pin.length
                            ? const Color(0xFF2D2D2D)
                            : Colors.transparent,
                      ),
                    );
                  }),
                ),
              ),
              Spacer(),
              // Numeric Keypad
              Padding(
                padding: EdgeInsets.only(bottom: 30.sp),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildKeypadButton('1'),
                        _buildKeypadButton('2'),
                        _buildKeypadButton('3'),
                      ],
                    ),
                    20.sp.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildKeypadButton('4'),
                        _buildKeypadButton('5'),
                        _buildKeypadButton('6'),
                      ],
                    ),
                    20.sp.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildKeypadButton('7'),
                        _buildKeypadButton('8'),
                        _buildKeypadButton('9'),
                      ],
                    ),
                    20.sp.verticalSpace,
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
              ),
            ],
          ),
        ),
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

class SuccessModal extends StatelessWidget {
  final bool isImport;

  const SuccessModal({super.key, required this.isImport});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(44)),
      ),
      padding: EdgeInsets.all(24.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Illustration placeholder - you can replace with actual image
          // Container(
          //   width: 200.sp,
          //   height: 150.sp,
          //   decoration: BoxDecoration(
          //     color: const Color(0xFFF9E6FF),
          //     borderRadius: BorderRadius.circular(16),
          //   ),
          //   child: Icon(
          //     Icons.check_circle,
          //     size: 80.sp,
          //     color: const Color(0xFF792A90),
          //   ),
          // ),
          20.sp.verticalSpace,
          Container(
            width: 147.sp,
            height: 171.sp,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/wallet_import_successfull.png",
                ),
                fit: BoxFit.contain,
              ),
            ),
          ),
          30.sp.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isImport
                    ? 'Wallet Imported Successfully!'
                    : 'Wallet Created Successfully!',
                style: TextStyle(
                  color: const Color(0xFF2D2D2D),
                  fontSize: 22.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(' 🎉', style: TextStyle(fontSize: 22.sp)),
            ],
          ),
          15.sp.verticalSpace,
          Text(
            isImport
                ? 'You\'re all set! Your wallet has been successfully imported, and you\'re ready to manage your crypto assets securely.'
                : 'Congratulations, your new wallet is now live. Be sure to secure your seed phrase, it\'s the key to your crypto kingdom.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF757575),
              fontSize: 14.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
          30.sp.verticalSpace,
          AppButton(
            text: isImport ? 'Let\'s Go' : 'Get Started',
            textColor: Colors.white,
            color: const Color(0xFF792A90),
            onTap: () {
              // Navigate to main app/home screen
              Navigate.go(context, name: AppRoutes.homepage);
              // Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
          10.sp.verticalSpace,
        ],
      ),
    );
  }
}
