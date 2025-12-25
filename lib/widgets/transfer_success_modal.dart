import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:quanthex/data/Models/assets/network_model.dart';
import 'package:quanthex/data/Models/assets/supported_assets.dart';
import 'package:quanthex/utils/navigator.dart';
import 'package:quanthex/views/home/components/coin_image.dart';
import 'package:quanthex/widgets/app_button.dart';

class TransferSuccessModal extends StatelessWidget {
  final SupportedCoin token;
  final NetworkModel chain;
  final double amount;
  final String recipientAddress;
  final String? message; // Optional custom message

  const TransferSuccessModal({
    super.key,
    required this.token,
    required this.chain,
    required this.amount,
    required this.recipientAddress,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final truncatedAddress = recipientAddress.length > 20
        ? '${recipientAddress.substring(0, 10)}...${recipientAddress.substring(recipientAddress.length - 10)}'
        : recipientAddress;
    final displayMessage = message ??
        'Transfer of $amount ${token.symbol} to $truncatedAddress is successfully completed';

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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 30.sp),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CoinImage(
                        imageUrl: token.image,
                        height: 60.sp,
                        width: 60.sp
                    ),
                    Positioned(
                      left: -40.sp,
                      child: Container(
                        width: 60.sp,
                        height: 60.sp,
                        decoration: BoxDecoration(
                          color: const Color(0xFF792A90),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          size: 30.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              15.horizontalSpace,
              Text(
                '-$amount ${token.symbol}',
                style: TextStyle(
                  color: const Color(0xFF2D2D2D),
                  fontSize: 20.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          20.sp.verticalSpace,
          Text(
            displayMessage,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: const Color(0xFF2D2D2D),
              fontSize: 16.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          10.sp.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CoinImage(
                  imageUrl: token.networkModel!.imageUrl,
                width: 20.sp,
                height: 20.sp,
              ),
              8.horizontalSpace,
              Text(
                chain.chainName,
                style: TextStyle(
                  color: const Color(0xFF757575),
                  fontSize: 14.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          30.sp.verticalSpace,
          Row(
            children: [
              // Expanded(
              //   child: Container(
              //     height: 50.sp,
              //     decoration: BoxDecoration(
              //       color: const Color(0xFFF9E6FF),
              //       borderRadius: BorderRadius.circular(50),
              //     ),
              //     child: Center(
              //       child: Text(
              //         'Receipt',
              //         style: TextStyle(
              //           color: const Color(0xFF792A90),
              //           fontSize: 15.sp,
              //           fontFamily: 'Satoshi',
              //           fontWeight: FontWeight.w700,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // 15.horizontalSpace,
              Expanded(
                child: AppButton(
                  text: 'Done',
                  textColor: Colors.white,
                  color: const Color(0xFF792A90),
                  padding: EdgeInsets.all(5),
                  onTap: () {
                    context.pop();
                  },
                ),
              ),
            ],
          ),
          20.sp.verticalSpace,
        ],
      ),
    );
  }
}

