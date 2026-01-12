// Payment Success Modal
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:quanthex/data/Models/assets/network_model.dart';
import 'package:quanthex/data/Models/assets/supported_assets.dart';
import 'package:quanthex/data/Models/mining/subscription_payload.dart';
import 'package:quanthex/data/Models/subscription/subscription_dto.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/views/home/components/coin_image.dart';
import 'package:quanthex/widgets/quanthex_image_banner.dart';

import '../../../widgets/app_button.dart';

class SubscriptionSuccessModal extends StatelessWidget {
  final SubscriptionPayload sub;
  final SupportedCoin token;
  final NetworkModel chain;
  final void Function()? onDoneTap;

  const SubscriptionSuccessModal({
    super.key,
    required this.sub,
    required this.token,
    required this.chain,
    this.onDoneTap,
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
                      width: 60.sp,
                      height: 60.sp,
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
                '-${sub.subPrice} ${token.symbol}',
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
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              style: TextStyle(
                color: const Color(0xFF2D2D2D),
                fontSize: 16.sp,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
              children: [
                TextSpan(text: 'Payment of '),
                TextSpan(
                  text: '${sub.subPrice} ${token.symbol}',
                  style: TextStyle(
                    color: const Color(0xFF792A90),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: ' is successful, Your mining package is now '),
                TextSpan(
                  text: 'active',
                  style: TextStyle(
                    color: const Color(0xFF792A90),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: ' and your HexaPower is running.'),
              ],
            ),
          ),
          10.sp.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CoinImage(
                  imageUrl: chain.imageUrl,
                  width: 20.sp,
                  height: 20.sp
              ),
              8.horizontalSpace,
              Text(
                chain.chainSymbol,
                style: TextStyle(
                  color: const Color(0xFF757575),
                  fontSize: 14.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w400,
                ),
              ),
                const Spacer(),
              QuanthexImageBanner(height: 60.sp, width: 100.sp),
            ],
          ),
          30.sp.verticalSpace,
          AppButton(
            text: 'Done',
            textColor: Colors.white,
            color: const Color(0xFF792A90),
            padding: EdgeInsets.all(5),
            onTap:
            onDoneTap ??
                    () {
                  Navigate.back(context);
                  // Navigator.of(context).popUntil((route) => route.isFirst);
                },
          ),
          20.sp.verticalSpace,
        ],
      ),
    );
  }
}