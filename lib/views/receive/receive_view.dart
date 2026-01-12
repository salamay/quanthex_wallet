import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quanthex/data/Models/assets/supported_assets.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/views/home/components/coin_image.dart';
import 'package:quanthex/widgets/app_button.dart';

import '../../widgets/arrow_back.dart';

class ReceiveView extends StatefulWidget {
  ReceiveView({super.key, required this.coin});

  SupportedCoin? coin;

  @override
  State<ReceiveView> createState() => _ReceiveViewState();
}

class _ReceiveViewState extends State<ReceiveView> {


  @override
  Widget build(BuildContext context) {
    String depositAddress = widget.coin!.walletAddress ?? "";
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigate.back(context);
          },
          child: ArrowBack()
        ),

        title: Text(
          'Receive',
          style: TextStyle(
            color: const Color(0xFF2D2D2D),
            fontSize: 18.sp,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [

                40.sp.verticalSpace,
                // Token Icon
                CoinImage( imageUrl: widget.coin!.image??"", height: 80.sp,width: 80.sp,),
                20.sp.verticalSpace,
                Text(
                  'Receive ${widget.coin!.symbol}',
                  style: TextStyle(
                    color: const Color(0xFF2D2D2D),
                    fontSize: 22.sp,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                40.sp.verticalSpace,
                // QR Code Placeholder
                QrImageView(
                  data: widget.coin!.walletAddress??"",
                  version: QrVersions.auto,
                  size: 250.sp,
                ),
                30.sp.verticalSpace,
                // Chain Network Card
                Container(
                  padding: EdgeInsets.all(16.sp),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Chain Network',
                              style: TextStyle(
                                color: const Color(0xFF757575),
                                fontSize: 12.sp,
                                fontFamily: 'Satoshi',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            4.sp.verticalSpace,
                            Text(
                              "${widget.coin!.networkModel!.chainName} (${widget.coin!.networkModel!.chainSymbol.toUpperCase()})",
                              style: TextStyle(
                                color: const Color(0xFF2D2D2D),
                                fontSize: 16.sp,
                                fontFamily: 'Satoshi',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            8.sp.verticalSpace,

                          ],
                        ),
                      ),
                      // Icon(
                      //   Icons.swap_horiz,
                      //   size: 24.sp,
                      //   color: const Color(0xFF757575),
                      // ),
                    ],
                  ),
                ),
                20.sp.verticalSpace,
                // Deposit Address Card
                Container(
                  padding: EdgeInsets.all(16.sp),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Deposit Address',
                              style: TextStyle(
                                color: const Color(0xFF757575),
                                fontSize: 12.sp,
                                fontFamily: 'Satoshi',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            4.sp.verticalSpace,
                            Text(
                              widget.coin!.walletAddress??"",
                              style: TextStyle(
                                color: const Color(0xFF2D2D2D),
                                fontSize: 12.sp,
                                fontFamily: 'Satoshi',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      10.horizontalSpace,
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(
                            ClipboardData(text: depositAddress),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Address copied to clipboard'),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.sp,
                            vertical: 8.sp,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF792A90),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.copy,
                                size: 16.sp,
                                color: Colors.white,
                              ),
                              5.horizontalSpace,
                              Text(
                                'Copy',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontFamily: 'Satoshi',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                40.sp.verticalSpace,
                // AppButton(
                //   text: 'Share Address',
                //   textColor: Colors.white,
                //   color: const Color(0xFF792A90),
                //   onTap: () {
                //     // Share functionality
                //     Clipboard.setData(ClipboardData(text: depositAddress));
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       SnackBar(content: Text('Address copied to clipboard')),
                //     );
                //   },
                // ),
                // 20.sp.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}


