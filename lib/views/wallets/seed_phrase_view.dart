import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/data/Models/wallets/wallet_model.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/views/settings/pin/set_pin_view.dart';
import 'package:quanthex/widgets/app_button.dart';

import '../../routes/app_routes.dart';

class SeedPhraseView extends StatefulWidget {
  SeedPhraseView({super.key,required this.wallet});
  WalletModel wallet;

  @override
  State<SeedPhraseView> createState() => _SeedPhraseViewState();
}

class _SeedPhraseViewState extends State<SeedPhraseView> {
  bool _copied = false;

  // Sample seed phrase - in real app, this would come from wallet generation
  final List<String> _seedPhrase = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _seedPhrase.addAll(widget.wallet.mnemonic!.split(' '));
  }

  void _copyToClipboard() {
    final phrase = _seedPhrase.join(' ');
    Clipboard.setData(ClipboardData(text: phrase));
    setState(() {
      _copied = true;
    });
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _copied = false;
        });
      }
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
                'Write down your seed phrase',
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
                'Write down your seed phrase and keep it safe in a place, you will need it to recover your wallet.',
                style: TextStyle(
                  color: const Color(0xFF757575),
                  fontSize: 14,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w500,
                ),
              ),
              30.sp.verticalSpace,
              Container(
                padding: EdgeInsets.all(16.sp),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: const Color(0xFF792A90), width: 1),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: List.generate(6, (index) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 12.sp),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.sp,
                                    vertical: 10.sp,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5F5F5),
                                    borderRadius: BorderRadius.circular(95),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${index + 1}.',
                                        style: TextStyle(
                                          color: const Color(0xFF2D2D2D),
                                          fontSize: 14.sp,
                                          fontFamily: 'Satoshi',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      8.horizontalSpace,
                                      Expanded(
                                        child: Text(
                                          _seedPhrase[index],
                                          style: TextStyle(
                                            color: const Color(0xFF2D2D2D),
                                            fontSize: 14.sp,
                                            fontFamily: 'Satoshi',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        15.horizontalSpace,
                        Expanded(
                          child: Column(
                            children: List.generate(6, (index) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 12.sp),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.sp,
                                    vertical: 10.sp,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5F5F5),
                                    borderRadius: BorderRadius.circular(95),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${index + 7}.',
                                        style: TextStyle(
                                          color: const Color(0xFF2D2D2D),
                                          fontSize: 14.sp,
                                          fontFamily: 'Satoshi',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      8.horizontalSpace,
                                      Expanded(
                                        child: Text(
                                          _seedPhrase[index + 6],
                                          style: TextStyle(
                                            color: const Color(0xFF2D2D2D),
                                            fontSize: 14.sp,
                                            fontFamily: 'Satoshi',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              20.sp.verticalSpace,
              if (_copied)
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.sp,
                      vertical: 8.sp,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9E6FF),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check,
                          color: const Color(0xFF792A90),
                          size: 16.sp,
                        ),
                        8.horizontalSpace,
                        Text(
                          'Copied',
                          style: TextStyle(
                            color: const Color(0xFF792A90),
                            fontSize: 12.sp,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                GestureDetector(
                  onTap: _copyToClipboard,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.sp,
                        vertical: 12.sp,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF792A90),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.copy,
                            color: const Color(0xFF792A90),
                            size: 18.sp,
                          ),
                          8.horizontalSpace,
                          Text(
                            'Copy to clipboard',
                            style: TextStyle(
                              color: const Color(0xFF792A90),
                              fontSize: 14.sp,
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              Spacer(),
              AppButton(
                text: 'Complete',
                textColor: Colors.white,
                color: const Color(0xFF792A90),
                onTap: () {
                  // Navigate to PIN setup (create new wallet)
                  Navigate.go(context, name: AppRoutes.setpinview,args: false);
                },
              ),
              10.sp.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
