import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum TransactionStatus { completed, pending, failed }

class TransactionStatusBadge extends StatelessWidget {
  final TransactionStatus status;

  const TransactionStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    String statusText;
    Color statusColor;

    switch (status) {
      case TransactionStatus.completed:
        statusText = 'Transaction completed';
        statusColor = const Color(0xFF4CAF50);
        break;
      case TransactionStatus.pending:
        statusText = 'Pending';
        statusColor = const Color(0xFFFF9800);
        break;
      case TransactionStatus.failed:
        statusText = 'Failed';
        statusColor = const Color(0xFFF44336);
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(status == TransactionStatus.completed ? Icons.check_circle : Icons.access_time, size: 14.sp, color: statusColor),
        4.horizontalSpace,
        Text(
          statusText,
          style: TextStyle(color: statusColor, fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
