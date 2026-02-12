import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:quanthex/data/utils/logger.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/widgets/app_button.dart';
import 'package:quanthex/widgets/loading_overlay/loading.dart';

class QRScanView extends StatefulWidget {
  const QRScanView({super.key});

  @override
  State<QRScanView> createState() => _QRScanViewState();
}

class _QRScanViewState extends State<QRScanView> with WidgetsBindingObserver {
  String? _scannedAddress;
  bool _isScanning = true;
final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late MobileScannerController cameraController;
    ValueNotifier<bool> isScanned = ValueNotifier(false);

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    cameraController = MobileScannerController();
    super.initState();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    // If the controller is not ready, do not try to start or stop it.
    // Permission dialogs can trigger lifecycle changes before the controller is ready.

    switch (state) {
      case AppLifecycleState.detached:
        unawaited(cameraController.stop());

      case AppLifecycleState.hidden:
        unawaited(cameraController.stop());
      case AppLifecycleState.paused:
        unawaited(cameraController.stop());
        return;
      case AppLifecycleState.resumed:
        unawaited(cameraController.start());
        return;
      case AppLifecycleState.inactive:
        unawaited(cameraController.stop());
        return;
    }
  }



  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cameraController.dispose();
    super.dispose();
  }

  
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
                                MobileScanner(
                                  controller: cameraController,
                                  fit: BoxFit.cover,
                                  onDetect: _handleBarcode,
                                  placeholderBuilder: (context) {
                                    return Center(child: Loading(size: 40));
                                  },
                                ),
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
            ],
          ),
        ),
      ),
    );
  }
    void _handleBarcode(BarcodeCapture code) {
    // Do something with the barcode data.
    final data = code.barcodes.last.displayValue;
    logger(data.toString(), 'MyScanner');
    if (!isScanned.value) {
      Navigator.pop(context, data);
    }
    isScanned.value = true;
  }
}
