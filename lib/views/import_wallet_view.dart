import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/utils/navigator.dart';
import 'package:quanthex/views/set_pin_view.dart';
import 'package:quanthex/widgets/app_button.dart';
import 'package:quanthex/widgets/app_textfield.dart';

class ImportWalletView extends StatefulWidget {
  const ImportWalletView({super.key});

  @override
  State<ImportWalletView> createState() => _ImportWalletViewState();
}

class _ImportWalletViewState extends State<ImportWalletView> {
  final TextEditingController _seedPhraseController = TextEditingController();
  bool _hasError = false;
  bool _isValid = false;

  @override
  void dispose() {
    _seedPhraseController.dispose();
    super.dispose();
  }

  void _validateSeedPhrase(String value) {
    // Basic validation - check if it's approximately 12 words
    final words = value.trim().split(RegExp(r'\s+'));
    final isValid =
        words.length == 12 && words.every((word) => word.isNotEmpty);

    setState(() {
      _hasError = !isValid && value.isNotEmpty;
      _isValid = isValid;
    });
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
                          value: 0.75, // 3/4
                          backgroundColor: const Color(0xFFF9E6FF),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            const Color(0xFF792A90),
                          ),
                        ),
                      ),
                      15.horizontalSpace,
                      Text(
                        '3 / 4',
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
                'Import Your Wallet',
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
                'Enter your exact 12-word recovery phrase to gain access to your wallet.',
                style: TextStyle(
                  color: const Color(0xFF757575),
                  fontSize: 14,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w500,
                ),
              ),
              20.sp.verticalSpace,
              if (_hasError)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.sp,
                    vertical: 10.sp,
                  ),
                  margin: EdgeInsets.only(bottom: 15.sp),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFFFCDD2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.close,
                        color: const Color(0xFFD32F2F),
                        size: 18.sp,
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: Text(
                          'Your seed phrase is incorrect',
                          style: TextStyle(
                            color: const Color(0xFFD32F2F),
                            fontSize: 13.sp,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Text(
                'Seed Phrase',
                style: TextStyle(
                  color: const Color(0xFF2D2D2D),
                  fontSize: 14.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
              10.sp.verticalSpace,
              AppTextfield(
                controller: _seedPhraseController,
                hintText: 'Enter your 12 - Digit seed phrase',
                maxLines: 4,
                borderColor: _hasError
                    ? const Color(0xFFFF5252)
                    : const Color(0xFF792A90),
                textStyle: TextStyle(
                  color: const Color(0xFF2D2D2D),
                  fontSize: 14.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w400,
                ),
                onChanged: _validateSeedPhrase,
              ),
              15.sp.verticalSpace,
              Container(
                padding: EdgeInsets.all(12.sp),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9E6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 20.sp,
                      height: 20.sp,
                      decoration: BoxDecoration(
                        color: const Color(0xFF792A90),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          'i',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    10.horizontalSpace,
                    Expanded(
                      child: Text(
                        'Your recovery phrase is private and never shared with our servers, Keep it safe anyone with your phrase can access your wallet.',
                        style: TextStyle(
                          color: const Color(0xFF2D2D2D),
                          fontSize: 12.sp,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              AppButton(
                text: 'Import',
                textColor: Colors.white,
                color: _isValid
                    ? const Color(0xFF792A90)
                    : const Color(0xFFB5B5B5),
                onTap: _isValid
                    ? () {
                        // Navigate to PIN setup with import flag
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) =>
                                const SetPinView(isImport: true),
                          ),
                        );
                      }
                    : null,
              ),
              10.sp.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
