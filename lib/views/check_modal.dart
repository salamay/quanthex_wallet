import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/data/controllers/assets/asset_controller.dart';

import '../data/controllers/balance/balance_controller.dart';
import '../widgets/global/MyFadeSlideEffect.dart';
import '../widgets/loading_overlay/loading.dart';

class CheckModal extends StatefulWidget {
  Widget child;
  Color? textColor;
   CheckModal({super.key,required this.child,this.textColor});

  @override
  State<CheckModal> createState() => _CheckModalState();
}

class _CheckModalState extends State<CheckModal> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<AssetController>(
        builder: (context, assetCtr, child) {
          return Consumer<BalanceController>(
              builder: (context, balanceCtr, child) {
                if(assetCtr.assetLoading||balanceCtr.balanceLoading){
                  return Center(
                    child: Loading(
                      size: 30.sp,
                    ),
                  );
                }else if(assetCtr.assetLoadingError||balanceCtr.balanceLoadingError) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyFadeSlideEffect(
                          child: Text(
                            'Unable to load your assets, go to your wallet section to refresh',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: widget.textColor??Colors.white60,
                              fontSize: 14.sp,
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }else if(!assetCtr.assetLoading&&!assetCtr.assetLoadingError&&!balanceCtr.balanceLoading&&!balanceCtr.balanceLoadingError){
                   return widget.child;
                } else{
                  return const SizedBox();
                }
              }
          );
        },
      ),
    );
  }
}
