import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/utils/navigator.dart';
import 'package:quanthex/widgets/app_button.dart';

class SetupWalletView extends StatefulWidget {
  const SetupWalletView({super.key});

  @override
  State<SetupWalletView> createState() => _SetupWalletViewState();
}

class _SetupWalletViewState extends State<SetupWalletView> {
  int? selectedOption; // 0 for create, 1 for import

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
                'Let\'s Set Up Your Wallet',
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
                'Choose how you want to access your crypto wallet.',
                style: TextStyle(
                  color: const Color(0xFF757575),
                  fontSize: 14,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w500,
                ),
              ),
              30.sp.verticalSpace,
              // Create New Wallet Option
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedOption = 0;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(16.sp),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selectedOption == 0
                          ? const Color(0xFF792A90)
                          : const Color(0xFFE0E0E0),
                      width: selectedOption == 0 ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48.sp,
                        height: 48.sp,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9E6FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.account_balance_wallet_outlined,
                          color: const Color(0xFF792A90),
                          size: 24.sp,
                        ),
                      ),
                      15.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Create a New Wallet',
                              style: TextStyle(
                                color: const Color(0xFF2D2D2D),
                                fontSize: 16.sp,
                                fontFamily: 'Satoshi',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            5.verticalSpace,
                            Text(
                              'We\'ll generate a secure and a unique seedphrase for you. This seedphrase is the only way to recover your wallet.',
                              style: TextStyle(
                                color: const Color(0xFF757575),
                                fontSize: 12.sp,
                                fontFamily: 'Satoshi',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              15.sp.verticalSpace,
              // Import Wallet Option
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedOption = 1;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(16.sp),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selectedOption == 1
                          ? const Color(0xFF792A90)
                          : const Color(0xFFE0E0E0),
                      width: selectedOption == 1 ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48.sp,
                        height: 48.sp,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.download_outlined,
                          color: const Color(0xFF9E9E9E),
                          size: 24.sp,
                        ),
                      ),
                      15.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Import Wallet',
                              style: TextStyle(
                                color: const Color(0xFF2D2D2D),
                                fontSize: 16.sp,
                                fontFamily: 'Satoshi',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            5.verticalSpace,
                            Text(
                              'Already have a wallet somewhere else? Restore it instantly using your existing seedphrase.',
                              style: TextStyle(
                                color: const Color(0xFF757575),
                                fontSize: 12.sp,
                                fontFamily: 'Satoshi',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              AppButton(
                text: 'Next',
                textColor: Colors.white,
                color: selectedOption != null
                    ? const Color(0xFF792A90)
                    : const Color(0xFFB5B5B5),
                onTap: selectedOption != null
                    ? () {
                        if (selectedOption == 0) {
                          // Create new wallet - go to seed phrase view
                          Navigate.toNamed(context, name: '/seedphraseview');
                        } else {
                          // Import wallet - go to import view
                          Navigate.toNamed(context, name: '/importwalletview');
                        }
                      }
                    : null,
              ),
              10.sp.verticalSpace,
              Center(
                child: GestureDetector(
                  onTap: () {
                    _showSeedPhraseModal(context);
                  },
                  child: Text(
                    'What is seed phrase?',
                    style: TextStyle(
                      color: const Color(0xFF792A90),
                      fontSize: 14.sp,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              10.sp.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  void _showSeedPhraseModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(24.sp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'What is a Seed Phrase?',
                style: TextStyle(
                  color: const Color(0xFF2D2D2D),
                  fontSize: 20.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            15.sp.verticalSpace,
            Container(height: 1.sp, color: Color(0xffD4D4D4)),
            15.sp.verticalSpace,

            Text(
              'A seed phrase is a set of 12 or 24 words that acts as the key to your wallet. It\'s the only way to recover your wallet if you lose access to your device.',
              style: TextStyle(
                color: const Color(0xFF757575),
                fontSize: 14.sp,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
            10.sp.verticalSpace,
            Text(
              'Think of it as your backup—without it, you risk losing your funds. Always store it in a safe place and never share it with anyone.',
              style: TextStyle(
                color: const Color(0xFF757575),
                fontSize: 14.sp,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
            25.sp.verticalSpace,
            AppButton(
              text: 'Okay, I Got it',
              textColor: Colors.white,
              color: const Color(0xFF792A90),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            10.sp.verticalSpace,
          ],
        ),
      ),
    );
  }
}
