import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_auth/local_auth.dart';
import 'package:quanthex/data/services/auth/biometric_service.dart';

class BiometricAuthWidget extends StatefulWidget {
  final String reason;
  final Function(bool)? onAuthenticated;
  final Function(String)? onError;
  final bool showIcon;
  final String? buttonText;
  final Color? iconColor;
  final Color? textColor;

  const BiometricAuthWidget({super.key, this.reason = 'Please authenticate to continue', this.onAuthenticated, this.onError, this.showIcon = true, this.buttonText, this.iconColor, this.textColor});

  @override
  State<BiometricAuthWidget> createState() => _BiometricAuthWidgetState();
}

class _BiometricAuthWidgetState extends State<BiometricAuthWidget> {
  final BiometricService _biometricService = BiometricService();
  bool _isAuthenticating = false;
  bool _isSupported = false;
  String _biometricTypeName = 'Biometric';
  IconData _biometricIcon = Icons.fingerprint;

  @override
  void initState() {
    super.initState();
    _checkBiometricSupport();
  }

  Future<void> _checkBiometricSupport() async {
    final isSupported = await _biometricService.isDeviceSupported();
    final availableBiometrics = await _biometricService.getAvailableBiometrics();

    if (mounted) {
      final biometricTypeName = await _biometricService.getPrimaryBiometricTypeName();
      // Set icon based on biometric type
      IconData biometricIcon = Icons.fingerprint;
      if (availableBiometrics.contains(BiometricType.face)) {
        biometricIcon = Icons.face;
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        biometricIcon = Icons.fingerprint;
      }

      setState(() {
        _isSupported = isSupported && availableBiometrics.isNotEmpty;
        if (_isSupported) {
          _biometricTypeName = biometricTypeName;
          _biometricIcon = biometricIcon;
        }
      });
    }
  }

  Future<void> _authenticate() async {
    if (!_isSupported || _isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
    });

    try {
      final authenticated = await _biometricService.authenticate(reason: widget.reason);

      if (mounted) {
        if (authenticated) {
          widget.onAuthenticated?.call(true);
        } else {
          widget.onError?.call('Authentication failed or cancelled');
        }
      }
    } catch (e) {
      if (mounted) {
        widget.onError?.call('Error: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isSupported) {
      return const SizedBox.shrink();
    }

    final iconColor = widget.iconColor ?? const Color(0xFF792A90);
    final textColor = widget.textColor ?? const Color(0xFF792A90);

    return GestureDetector(
      onTap: _isAuthenticating ? null : _authenticate,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 12.sp),
        decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.showIcon) ...[
              _isAuthenticating
                  ? SizedBox(
                      width: 18.sp,
                      height: 18.sp,
                      child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(iconColor)),
                    )
                  : Icon(_biometricIcon, size: 18.sp, color: iconColor),
              8.horizontalSpace,
            ],
            Text(
              widget.buttonText ?? _biometricTypeName,
              style: TextStyle(color: textColor, fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
