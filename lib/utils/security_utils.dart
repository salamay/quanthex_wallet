import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/repository/secure_storage.dart';
import '../widgets/confirm_pin_modal.dart';
import '../widgets/snackbar/my_snackbar.dart';
import 'logger.dart';

class SecurityUtils{


   static Future<bool> showPinDialog({required BuildContext context})async{
     String userPin=await SecureStorage.getInstance().getPin();
     if(userPin.isEmpty){
       logger("User PIN is empty, redirecting to set PIN", "SecurityUtils");
       return true;
     }
     String? result=await showModalBottomSheet(
       context: context,
       isScrollControlled: true,
       backgroundColor: Colors.white,
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
       ),
       builder: (context) => ConfirmPinModal(
         title: 'Confirm pin',
         pinLength: 4,
         onPinComplete: (pin) {
           // Navigator.pop(context);
           context.pop(pin);
           // onConfirm();
         },
       ),
     );
     if (result == userPin) {
       logger("PIN verified successfully", "SecurityUtils");
       return true;
     }else{
       showMySnackBar(context: context, message: "Incorrect pin", type: SnackBarType.error);
       return false;
     }
   }
}