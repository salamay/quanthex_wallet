import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quanthex/data/repository/my_local_storage.dart';

import '../repository/secure_storage.dart';
import '../services/auth/biometric_service.dart';
import '../../widgets/confirm_pin_modal.dart';
import '../../widgets/snackbar/my_snackbar.dart';
import 'logger.dart';

class SecurityUtils {
  static final BiometricService _biometricService = BiometricService();

  /// Show PIN dialog with optional biometric authentication
  static Future<bool> showPinDialog({required BuildContext context}) async {
    String userPin = await SecureStorage.getInstance().getPin();
    if (userPin.isEmpty) {
      logger("User PIN is empty, redirecting to set PIN", "SecurityUtils");
      return true;
    }

    // Check if biometric is available and should be used
    bool allowBiometric = await MyLocalStorage().getBiometricAuth();
    if (allowBiometric) {
      final isBiometricAvailable = await _biometricService.isDeviceSupported();
      if (isBiometricAvailable) {
        final authenticated = await _biometricService.authenticate(reason: 'Please authenticate to confirm');
        if (authenticated) {
          logger("Biometric authentication successful", "SecurityUtils");
          return true;
        }
      }
    }

    // Fall back to PIN
    String? result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
      builder: (context) => ConfirmPinModal(
        title: 'Confirm pin',
        pinLength: 4,
        showFaceId: allowBiometric,
        onPinComplete: (pin) {
          context.pop(pin);
        },
      ),
    );

    if (result == 'BIOMETRIC_SUCCESS') {
      logger("Biometric authentication successful via modal", "SecurityUtils");
      return true;
    }
    if(result==null){
      showMySnackBar(context: context, message: "Cancelled", type: SnackBarType.error);
      return false;
    }
    if (result == userPin) {
      logger("PIN verified successfully", "SecurityUtils");
      return true;
    } else {
      showMySnackBar(context: context, message: "Incorrect pin", type: SnackBarType.error);
      return false;
    }
  }

  /// Authenticate using biometrics only
  static Future<bool> authenticateWithBiometric({required BuildContext context, String reason = 'Please authenticate to continue'}) async {
    try {
      final authenticated = await _biometricService.authenticate(reason: reason);
      if (!authenticated) {
        showMySnackBar(context: context, message: "Authentication failed or cancelled", type: SnackBarType.error);
      }
      return authenticated;
    } catch (e) {
      logger("Error in biometric authentication: $e", "SecurityUtils");
      showMySnackBar(context: context, message: "Biometric authentication error", type: SnackBarType.error);
      return false;
    }
  }

  

  /// Check if biometric authentication is available
  static Future<bool> isBiometricAvailable() async {
    return await _biometricService.isDeviceSupported();
  }
}
