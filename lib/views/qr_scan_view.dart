import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/utils/navigator.dart';
import 'package:quanthex/widgets/app_button.dart';

class QRScanView extends StatefulWidget {
  const QRScanView({super.key});

  @override
  State<QRScanView> createState() => _QRScanViewState();
}

class _QRScanViewState extends State<QRScanView> {
  String? _scannedAddress;
  bool _isScanning = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.black,
          child: Stack(
            children: [
              // Scanner Area
              Column(
                children: [
                  // Header
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15.sp,
                    ),
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
                          'QR Code Scan',
                          style: TextStyle(
                            color: const Color(0xFF2D2D2D),
                            fontSize: 18.sp,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Spacer(),
                        SizedBox(width: 60.sp),
                      ],
                    ),
                  ),
                  // Scanner View
                  Expanded(
                    child: Container(
                      color: Colors.black87,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Scanning Frame
                          Container(
                            width: 250.sp,
                            height: 250.sp,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Stack(
                              children: [
                                // Corner indicators
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Container(
                                    width: 30.sp,
                                    height: 30.sp,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                          color: Colors.white,
                                          width: 4,
                                        ),
                                        top: BorderSide(
                                          color: Colors.white,
                                          width: 4,
                                        ),
                                      ),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    width: 30.sp,
                                    height: 30.sp,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                          color: Colors.white,
                                          width: 4,
                                        ),
                                        top: BorderSide(
                                          color: Colors.white,
                                          width: 4,
                                        ),
                                      ),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  child: Container(
                                    width: 30.sp,
                                    height: 30.sp,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                          color: Colors.white,
                                          width: 4,
                                        ),
                                        bottom: BorderSide(
                                          color: Colors.white,
                                          width: 4,
                                        ),
                                      ),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 30.sp,
                                    height: 30.sp,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                          color: Colors.white,
                                          width: 4,
                                        ),
                                        bottom: BorderSide(
                                          color: Colors.white,
                                          width: 4,
                                        ),
                                      ),
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),

                                // Scanning line
                                if (_isScanning)
                                  Positioned(
                                    top: 20,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      height: 2,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            const Color(0xFF792A90),
                                            const Color(0xFFAA45C7),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Bottom Sheet
              if (_scannedAddress != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
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
                          'Scanned Crypto Wallet',
                          style: TextStyle(
                            color: const Color(0xFF757575),
                            fontSize: 14.sp,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        15.sp.verticalSpace,
                        Text(
                          _scannedAddress!,
                          style: TextStyle(
                            color: const Color(0xFF2D2D2D),
                            fontSize: 18.sp,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        30.sp.verticalSpace,
                        Row(
                          children: [
                            Expanded(
                               child: AppButton(
                                 text: 'Confirm',
                                 textColor: Colors.white,
                                 color: const Color(0xFF792A90),
                                 padding: EdgeInsets.all(5),
 
                                 onTap: () {
                                   // Handle confirm - return scanned address
                                   Navigator.pop(context, _scannedAddress);
                                 },
                               ),
                            ),
                            15.horizontalSpace,
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Clipboard.setData(
                                    ClipboardData(text: _scannedAddress!),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Address copied')),
                                  );
                                },
                                child: Container(
                                  height: 50.sp,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF9E6FF),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.copy,
                                        size: 18.sp,
                                        color: const Color(0xFF792A90),
                                      ),
                                      8.horizontalSpace,
                                      Text(
                                        'Copy',
                                        style: TextStyle(
                                          color: const Color(0xFF792A90),
                                          fontSize: 15.sp,
                                          fontFamily: 'Satoshi',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        20.sp.verticalSpace,
                      ],
                    ),
                  ),
                )
              else
                // Simulate scan button
                Positioned(
                  bottom: 40.sp,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        // Simulate scanning
                        setState(() {
                          _scannedAddress = '0x352hhxj3.....hds67';
                          _isScanning = false;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30.sp,
                          vertical: 12.sp,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF792A90),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          'Scan QR Code',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
