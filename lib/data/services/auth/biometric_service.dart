import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:quanthex/data/utils/logger.dart';

class BiometricService {
  static final BiometricService _instance = BiometricService._internal();
  factory BiometricService() => _instance;
  BiometricService._internal();

  final LocalAuthentication _localAuth = LocalAuthentication();

  /// Check if device supports biometric authentication
  Future<bool> isDeviceSupported() async {
    try {
      return await _localAuth.canCheckBiometrics || await _localAuth.isDeviceSupported();
    } catch (e) {
      logger("Error checking biometric support: $e", "BiometricService");
      return false;
    }
  }

  /// Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      logger("Error getting available biometrics: $e", "BiometricService");
      return [];
    }
  }

  /// Check if biometrics are enabled
  Future<bool> isBiometricsEnabled() async {
    try {
      final available = await getAvailableBiometrics();
      return available.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Authenticate using biometrics
  Future<bool> authenticate({String reason = 'Please authenticate to continue', bool useErrorDialogs = true, bool stickyAuth = true}) async {
    try {
      final isAvailable = await isDeviceSupported();
      if (!isAvailable) {
        logger("Biometric authentication not available", "BiometricService");
        return false;
      }

      final availableBiometrics = await getAvailableBiometrics();
      if (availableBiometrics.isEmpty) {
        logger("No biometrics available", "BiometricService");
        return false;
      }

      final didAuthenticate = await _localAuth.authenticate(localizedReason: reason);

      if (didAuthenticate) {
        logger("Biometric authentication successful", "BiometricService");
      } else {
        logger("Biometric authentication failed or cancelled", "BiometricService");
      }

      return didAuthenticate;
    } on PlatformException catch (e) {
      logger("Platform error during biometric authentication: ${e.message}", "BiometricService");
      return false;
    } catch (e) {
      logger("Error during biometric authentication: $e", "BiometricService");
      return false;
    }
  }

  /// Stop authentication (if in progress)
  Future<void> stopAuthentication() async {
    try {
      await _localAuth.stopAuthentication();
    } catch (e) {
      logger("Error stopping authentication: $e", "BiometricService");
    }
  }

  /// Get biometric type name for display
  String getBiometricTypeName(BiometricType type) {
    switch (type) {
      case BiometricType.face:
        return 'Face ID';
      case BiometricType.fingerprint:
        return 'Fingerprint';
      case BiometricType.strong:
        return 'Strong Authentication';
      case BiometricType.weak:
        return 'Weak Authentication';
      case BiometricType.iris:
        return 'Iris';
    }
  }

  /// Get primary biometric type name
  Future<String> getPrimaryBiometricTypeName() async {
    final available = await getAvailableBiometrics();
    if (available.isEmpty) return 'Biometric';

    // Prefer Face ID, then Fingerprint
    if (available.contains(BiometricType.face)) {
      return 'Face ID';
    } else if (available.contains(BiometricType.fingerprint)) {
      return 'Fingerprint';
    }

    return getBiometricTypeName(available.first);
  }
}
