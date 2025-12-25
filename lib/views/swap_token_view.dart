import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/utils/navigator.dart';
import 'package:quanthex/widgets/app_button.dart';
import 'package:quanthex/widgets/app_textfield.dart';
import 'package:quanthex/widgets/bottom_nav_bar.dart';

class SwapTokenView extends StatefulWidget {
  const SwapTokenView({super.key});

  @override
  State<SwapTokenView> createState() => _SwapTokenViewState();
}

class _SwapTokenViewState extends State<SwapTokenView> {
  final String _fromToken = 'ETH';
  String _toToken = '';
  final double _fromAmount = 0.00032;
  final double _toAmount = 0.000002;

  void _showReceiverModal() {
    // showModalBottomSheet(
    //   context: context,
    //   isScrollControlled: true,
    //   useSafeArea: true,
    //   backgroundColor: Colors.white,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
    //   ),
    //   builder: (context) => ReceiverModal(
    //     onTokenSelected: (token) {
    //       setState(() {
    //         _toToken = token;
    //       });
    //       Navigator.pop(context);
    //     },
    //   ),
    // );
  }

  void _showConfirmSwap() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ConfirmSwapModal(
        fromToken: _fromToken,
        toToken: _toToken,
        fromAmount: _fromAmount,
        toAmount: _toAmount,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigate.back(context);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back, size: 20.sp),
                    5.horizontalSpace,
                    Text(
                      'Back',
                      style: TextStyle(
                        color: const Color(0xFF2D2D2D),
                        fontSize: 16.sp,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Text(
                'Swap Token',
                style: TextStyle(
                  color: const Color(0xFF2D2D2D),
                  fontSize: 18.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              IconButton(
                icon: Container(
                  width: 41,
                  height: 41,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 2,
                    vertical: 9,
                  ),
                  decoration: ShapeDecoration(
                    color: const Color(0x7CDADADA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.50),
                    ),
                  ),
                  child: Image.asset(
                    'assets/images/history.png',
                    width: 19.sp,
                    height: 19.sp,
                  ),
                ),
                // Icon(
                //   Icons.description_outlined,
                //   size: 24.sp,
                //   color: const Color(0xFF2D2D2D),
                // ),
                onPressed: () {
                  Navigate.toNamed(
                    context,
                    name: '/transactionhistoryview',
                  );
                },
              ),
            ],
          ),
        ),
        30.sp.verticalSpace,
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // From Section
                Stack(
                  alignment: AlignmentGeometry.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(16.sp),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'From',
                                    style: TextStyle(
                                      color: const Color(0xFF757575),
                                      fontSize: 14.sp,
                                      fontFamily: 'Satoshi',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    '$_fromAmount $_fromToken',
                                    style: TextStyle(
                                      color: const Color(0xFF757575),
                                      fontSize: 12.sp,
                                      fontFamily: 'Satoshi',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  8.horizontalSpace,
                                  Text(
                                    'Max',
                                    style: TextStyle(
                                      color: Color(0xFF792A90),
                                      fontSize: 13.sp,
                                      fontFamily: 'Satoshi',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              10.sp.verticalSpace,
                              Row(
                                children: [
                                  Container(
                                    width: 32.sp,
                                    height: 32.sp,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.asset(
                                      'assets/images/eth_logo.png',
                                      width: 24.sp,
                                      height: 24.sp,
                                    ),
                                  ),
                                  8.horizontalSpace,
                                  Text(
                                    _fromToken,
                                    style: TextStyle(
                                      color: const Color(0xFF2D2D2D),
                                      fontSize: 16.sp,
                                      fontFamily: 'Satoshi',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 20.sp,
                                    color: const Color(0xFF757575),
                                  ),
                                  Spacer(),
                                  Text(
                                    '0.48',
                                    style: TextStyle(
                                      color: const Color(0xFF2D2D2D),
                                      fontSize: 28.sp,
                                      fontFamily: 'Satoshi',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              10.sp.verticalSpace,
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(),
                                  Text(
                                    '\$1500.00',
                                    style: TextStyle(
                                      color: const Color(0xFF757575),
                                      fontSize: 14.sp,
                                      fontFamily: 'Satoshi',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        10.sp.verticalSpace,

                        _toToken.isEmpty
                            ? Container(
                          width: MediaQuery.sizeOf(context).width,
                          height: 67,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFF0F0F0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(19),
                            ),
                          ),
                          child: Row(
                            children: [
                              10.horizontalSpace,

                              //GREY LOADER
                              SizedBox(
                                width: 116,
                                height: 25,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 0,
                                      top: 0,
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        decoration: ShapeDecoration(
                                          color: const Color(
                                            0xFFDFDFDF,
                                          ),
                                          shape: OvalBorder(),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 31,
                                      top: 9,
                                      child: Container(
                                        width: 85,
                                        height: 6,
                                        decoration: ShapeDecoration(
                                          color: const Color(
                                            0xFFDFDFDF,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                              30,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: _showReceiverModal,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.sp,
                                    vertical: 8.sp,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF792A90),
                                    borderRadius:
                                    BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Select Token',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontFamily: 'Satoshi',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              10.horizontalSpace,
                            ],
                          ),
                        )
                            :
                        // To Section
                        Container(
                          padding: EdgeInsets.all(16.sp),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'To',
                                    style: TextStyle(
                                      color: const Color(0xFF757575),
                                      fontSize: 14.sp,
                                      fontFamily: 'Satoshi',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    '$_toAmount',
                                    style: TextStyle(
                                      color: const Color(0xFF757575),
                                      fontSize: 12.sp,
                                      fontFamily: 'Satoshi',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              10.sp.verticalSpace,
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: _showReceiverModal,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 32.sp,
                                          height: 32.sp,
                                          decoration: BoxDecoration(
                                            color: Colors.blue
                                                .withOpacity(0.2),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.circle,
                                            size: 20.sp,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        8.horizontalSpace,
                                        Text(
                                          _toToken,
                                          style: TextStyle(
                                            color: const Color(
                                              0xFF2D2D2D,
                                            ),
                                            fontSize: 16.sp,
                                            fontFamily: 'Satoshi',
                                            fontWeight:
                                            FontWeight.w600,
                                          ),
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 20.sp,
                                          color: const Color(
                                            0xFF757575,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '3155.02',
                                    style: TextStyle(
                                      color: const Color(0xFF2D2D2D),
                                      fontSize: 28.sp,
                                      fontFamily: 'Satoshi',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              5.sp.verticalSpace,
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Swap Direction Button
                    Container(
                      width: 30.sp,
                      height: 30.sp,
                      padding: const EdgeInsets.all(3),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFD9D9D9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      child: Icon(
                        Icons.swap_vert,
                        size: 24.sp,
                        color: const Color(0xFF2D2D2D),
                      ),
                    ),
                  ],
                ),
                30.sp.verticalSpace,
                // Swap Details
                Column(
                  children: [
                    _buildSwapDetail('Swap Rate', '1 ETH = 6572.96 ADA'),
                    // Divider(height: 20.sp),
                    15.sp.verticalSpace,
                    _buildSwapDetail('Min Receive', '3025.32 ADA'),
                    // Divider(height: 20.sp),
                    15.sp.verticalSpace,
                    _buildSwapDetail('Slippage Tolerance', '0.50%'),
                    // Divider(height: 20.sp),
                    15.sp.verticalSpace,
                    _buildSwapDetail('Price Impact', '0%'),
                    // Divider(height: 20.sp),
                    15.sp.verticalSpace,
                    _buildSwapDetail('Service Fees', '\$1.82 (0.18%)'),
                    // Divider(height: 20.sp),
                    15.sp.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Route',
                          style: TextStyle(
                            color: const Color(0xFF757575),
                            fontSize: 14.sp,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Row(
                          children: [
                            // Container(
                            //   width: 24.sp,
                            //   height: 24.sp,
                            //   decoration: BoxDecoration(
                            //     color: Colors.blue,
                            //     shape: BoxShape.circle,
                            //   ),
                            //   child: Center(
                            //     child: Text(
                            //       'T',
                            //       style: TextStyle(
                            //         color: Colors.white,
                            //         fontSize: 12.sp,
                            //         fontFamily: 'Satoshi',
                            //         fontWeight: FontWeight.w700,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            Container(
                              width: 21.sp,
                              height: 21.sp,
                              decoration: ShapeDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    "assets/images/transit_icon.png",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                            ),
                            8.horizontalSpace,
                            Text(
                              'Transit',
                              style: TextStyle(
                                color: const Color(0xFF2D2D2D),
                                fontSize: 14.sp,
                                fontFamily: 'Satoshi',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                30.sp.verticalSpace,
                AppButton(
                  text: 'Swap',
                  textColor: Colors.white,
                  color: const Color(0xFF792A90),
                  onTap: _showConfirmSwap,
                ),
                20.sp.verticalSpace,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwapDetail(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFF757575),
            fontSize: 14.sp,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: const Color(0xFF2D2D2D),
            fontSize: 14.sp,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}


// Confirm Swap Modal
class ConfirmSwapModal extends StatefulWidget {
  final String fromToken;
  final String toToken;
  final double fromAmount;
  final double toAmount;

  const ConfirmSwapModal({
    super.key,
    required this.fromToken,
    required this.toToken,
    required this.fromAmount,
    required this.toAmount,
  });

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
      builder: (context) => SwapSuccessModal(
        fromToken: widget.fromToken,
        toToken: widget.toToken,
      ),
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
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(
            'Confirm Swap',
            style: TextStyle(
              color: const Color(0xFF2D2D2D),
              fontSize: 20.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w700,
            ),
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
                  color: index < _pin.length
                      ? const Color(0xFF2D2D2D)
                      : Colors.transparent,
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
                style: TextStyle(
                  color: const Color(0xFF792A90),
                  fontSize: 14.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
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

// Swap Success Modal
class SwapSuccessModal extends StatelessWidget {
  final String fromToken;
  final String toToken;

  const SwapSuccessModal({
    super.key,
    required this.fromToken,
    required this.toToken,
  });

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
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          10.sp.verticalSpace,
          // Stack(
          //   alignment: Alignment.center,
          //   children: [
          //     Container(
          //       width: 60.sp,
          //       height: 60.sp,
          //       decoration: BoxDecoration(
          //         color: const Color(0xFFF9E6FF),
          //         shape: BoxShape.circle,
          //       ),
          //       child: Icon(
          //         Icons.diamond,
          //         size: 32.sp,
          //         color: const Color(0xFF792A90),
          //       ),
          //     ),
          //     Positioned(
          //       right: 0,
          //       child: Container(
          //         width: 40.sp,
          //         height: 40.sp,
          //         decoration: BoxDecoration(
          //           color: Colors.blue,
          //           shape: BoxShape.circle,
          //         ),
          //         child: Icon(Icons.circle, size: 24.sp, color: Colors.white),
          //       ),
          //     ),
          //   ],
          // ),
          Container(
            width: 137.sp,
            height: 80.sp,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/swapduo.png"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          20.sp.verticalSpace,
          Text(
            'Swap Successful',
            style: TextStyle(
              color: const Color(0xFF2D2D2D),
              fontSize: 22.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w700,
            ),
          ),
          10.sp.verticalSpace,
          Text(
            'Your token swap went through successfully.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF757575),
              fontSize: 14.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w400,
            ),
          ),
          30.sp.verticalSpace,
          AppButton(
            text: 'Done',
            textColor: Colors.white,
            color: const Color(0xFF792A90),
            onTap: () {
              Navigator.of(context).pop();
              // Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
          20.sp.verticalSpace,
        ],
      ),
    );
  }
}
