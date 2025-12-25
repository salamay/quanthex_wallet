import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
enum SnackBarType {
  success,
  error,
  info,
}
showMySnackBar({required BuildContext context, required String message,required SnackBarType type}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message),backgroundColor: type==SnackBarType.success?Colors.green:Colors.red,),
  );
}