import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/data/Models/staking/staking_payload.dart';
import 'package:quanthex/data/controllers/assets/asset_controller.dart';
import 'package:quanthex/routes/app_routes.dart';
import 'package:quanthex/widgets/app_button.dart';

import '../../data/Models/assets/supported_assets.dart';
import '../../data/utils/navigator.dart';
import '../../widgets/snackbar/my_snackbar.dart';
class EmptyStakingView extends StatelessWidget {
  EmptyStakingView({super.key});
  late AssetController assetController;
  @override
  Widget build(BuildContext context) {
    assetController=Provider.of<AssetController>(context,listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.sp.verticalSpace,
        // Description
        Text(
          'Staking Reward lets you earn daily returns on your capital while still keeping full control of your money. You subscribe to a staking plan, your capital is locked for daily earnings, and you can withdraw it anytime.',
          style: TextStyle(
            color: const Color(0xFF757575),
            fontSize: 14.sp,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
        30.sp.verticalSpace,
        // Active Plans Section
        Text(
          'Active Plans',
          style: TextStyle(
            color: const Color(0xFF2D2D2D),
            fontSize: 18.sp,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w700,
          ),
        ),
        15.sp.verticalSpace,
        // Empty State
        Container(
          padding: EdgeInsets.all(20.sp),
          child: Column(
            children: [
              Container(
                width: 107.sp,
                height: 107.sp,
                decoration: BoxDecoration(
                  // color: const Color(0xFFF5F5F5),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/empty_stake_imaage.png'),
                  ),
                ),
                // child: Icon(
                //   Icons.inbox_outlined,
                //   size: 60.sp,
                //   color: const Color(0xFFE0E0E0),
                // ),
              ),
              20.sp.verticalSpace,
              Text(
                'You currently have not subscribed to any staking. stake and they will display here.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF757575),
                  fontSize: 14.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        40.sp.verticalSpace,
        // Stake Now Button
        AppButton(
          text: 'Stake Now',
          textColor: Colors.white,
          color: const Color(0xFF792A90),
          onTap: () {
            List<SupportedCoin> supportedCoins = assetController.assets.where((e)=>e.symbol.toLowerCase()=="usdt"&&e.networkModel!.chainId==56).toList();
            if(supportedCoins.isEmpty){
              showMySnackBar(context: context, message: "You don't have USDT on Bep20 to  stake, Please note that USDT is required for payment", type: SnackBarType.error);
              return;
            }
            SupportedCoin asset=supportedCoins.first;
            StakingPayload payload = StakingPayload();
            payload.stakingRewardContract=asset.contractAddress??"";
            payload.stakingRewardAssetDecimals=asset.decimal??18;
            payload.stakingRewardAssetSymbol=asset.symbol;
            payload.stakingRewardAssetImage=asset.image??"";
            payload.stakingRewardAssetName=asset.name??"";
            payload.stakingRewardChainId=asset.networkModel?.chainId??56;
            payload.stakingRewardChainName=asset.networkModel!.chainName??"";
            var data={
              "data":payload,
              "payment_token":supportedCoins.first
            };
            Navigate.toNamed(context, name: AppRoutes.subscribestakingview,args: data);
          },
        ),
        40.sp.verticalSpace,
      ],
    );
  }
}
