import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/widgets/app_button.dart' show AppButton;

import 'MyFadeSlideEffect.dart';


class ErrorModal extends StatelessWidget {
  ErrorModal({super.key,required this.callBack, this.message});
  String? message;
  Function callBack;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyFadeSlideEffect(
                child: Text(
                  'An error occurred, check your internet connection and try again. If the problem persists, please contact support.',
                  style: TextStyle(
                    color: const Color(0xFF757575),
                    fontSize: 14.sp,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ),
              SizedBox(height: 16,),
              AppButton(
                  text: 'Retry',
                  textColor: Colors.white,
                  color: const Color(0xFF792A90),
                  onTap: ()async {
                    callBack();
                  }
              ),

            ],
          ),
        ),
      ),
    );
  }
}
