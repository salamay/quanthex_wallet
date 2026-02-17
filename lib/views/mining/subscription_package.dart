import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/data/Models/assets/supported_assets.dart';
import 'package:quanthex/data/controllers/assets/asset_controller.dart';
import 'package:quanthex/data/controllers/balance/balance_controller.dart';
import 'package:quanthex/data/controllers/user/user_controller.dart';
import 'package:quanthex/data/controllers/wallet_controller.dart';
import 'package:quanthex/routes/app_routes.dart';
import 'package:quanthex/data/utils/logger.dart';
import 'package:quanthex/views/mining/components/how_it_works_item.dart';
import 'package:quanthex/views/mining/mining_view.dart';
import 'package:quanthex/views/mining/subscription_list.dart';
import 'package:quanthex/widgets/quanthex_image_banner.dart';
import 'package:quanthex/widgets/snackbar/my_snackbar.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/constants/sub_constants.dart';
import '../../data/Models/mining/mining_dto.dart';
import '../../data/Models/mining/subscription_payload.dart';
import '../../data/controllers/mining/mining_controller.dart';
import '../../data/utils/navigator.dart';
import '../../widgets/app_button.dart';
import '../../widgets/global/error_modal.dart';
import 'components/mining_simulation_widget.dart';
import 'earning_breakdown_modal.dart';

class SubscriptionPackage extends StatefulWidget {
  const SubscriptionPackage({super.key});

  @override
  State<SubscriptionPackage> createState() => _SubscriptionPackageState();
}

class _SubscriptionPackageState extends State<SubscriptionPackage> {
  late AssetController assetController;
  late WalletController walletController;
  ValueNotifier<bool> _loadingNotifier = ValueNotifier(true);
  ValueNotifier<bool> _errorNotifier = ValueNotifier(false);
  late MiningController miningController;
  late UserController userController;
  int selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    assetController = Provider.of<AssetController>(context, listen: false);
    miningController = Provider.of<MiningController>(context, listen: false);
    userController = Provider.of<UserController>(context, listen: false);
    walletController = Provider.of<WalletController>(context, listen: false);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Mining',
          style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 20.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          onPressed: () {
            
            Navigate.back(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 16.sp),
        child: Consumer<MiningController>(
          builder: (context, miningCtr, _) {
            String walletAddress = walletController.currentWallet!.walletAddress ?? "";
            List<MiningDto> minings = miningCtr.minings[walletAddress] ?? [];
            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // Quanthex Image Banner
                  Center(
                    child: QuanthexImageBanner(width: 110.sp, height: 20.sp),
                  ),
                  10.sp.verticalSpace,
                  // Introduction Section
                  Text(
                    'Ignite Your Mining Power Let the Blockchain Work for You.',
                    style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 24.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                  ),
                  15.sp.verticalSpace,
                  Text(
                    'Activate any mining package and begin generating rewards instantly. The higher your package and network growth, the more you earn.',
                    style: TextStyle(color: const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400, height: 1.5),
                  ),
                  30.sp.verticalSpace,
                  // How It Works
                  Text(
                    'How It Works',
                    style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 18.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                  ),
                  15.sp.verticalSpace,
                  HowItWorksItem(text: 'Choose a package', onInfoTap: () {}),
                  10.sp.verticalSpace,
                  HowItWorksItem(text: 'Get your HexaPower referral link', onInfoTap: () {}),
                  10.sp.verticalSpace,
                  HowItWorksItem(text: 'Share & grow your earnings', onInfoTap: () {}),
                  30.sp.verticalSpace,
                  // Available Packages
                  Text(
                    'Available Packages',
                    style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 18.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                  ),
                  10.sp.verticalSpace,
                  Text(
                    'Pick a plan that matches your budget and unlock mining rewards.',
                    style: TextStyle(color: const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                  ),
                  20.sp.verticalSpace,
                  GestureDetector(
                    onTap: () {
                      selectedIndex = 0;
                      setState(() {});
                    },
                    child: _buildPackageCard(price: 50, name: starter, isSelected: selectedIndex == 0 ? true : false),
                  ),
                  15.sp.verticalSpace,
                  GestureDetector(
                    onTap: () {
                      selectedIndex = 1;
                      setState(() {});
                    },
                    child: _buildPackageCard(price: 200, name: growth, isSelected: selectedIndex == 1 ? true : false),
                  ),
                  15.sp.verticalSpace,
                  GestureDetector(
                    onTap: () {
                      selectedIndex = 2;
                      setState(() {});
                    },
                    child: _buildPackageCard(price: 500, name: advance, isSelected: selectedIndex == 2 ? true : false),
                  ),
                  15.sp.verticalSpace,
                  GestureDetector(
                    onTap: () {
                      selectedIndex = 3;
                      setState(() {});
                    },
                    child: _buildPackageCard(price: 1000, name: pro, isSelected: selectedIndex == 3 ? true : false),
                  ),
               15.sp.verticalSpace,
                  GestureDetector(
                    onTap: () {
                      selectedIndex = 4;
                      setState(() {});
                    },
                    child: _buildPackageCard(price: 2000, name: mega, isSelected: selectedIndex == 4 ? true : false),
                  ),
              
                  40.sp.verticalSpace,
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPackageCard({
    required int price,
    required String name,
    bool isSelected = false,
  }) {
    return Consumer<BalanceController>(
      builder: (context, balanceCtr, child) {
        String rewardAssetSymbol = "DOGE";
        double rewardPriceQuotes = balanceCtr.priceQuotes[rewardAssetSymbol] ?? 0;
        String amountInCrypto = (price / rewardPriceQuotes).toStringAsFixed(0);
         String description = "";
        if (name == starter) {
          description = "Offering up to $amountInCrypto DOGE in mining outputs. Advance through the required stages to unlock the full outputs.";
        } else if (name == growth) {
          description = "Offering up to $amountInCrypto DOGE in mining outputs. Move through all stages to claim the maximum outputs.";
        } else if (name == advance) {
          description = "Offering up to $amountInCrypto DOGE in mining outputs. Progress through the necessary stages to access the full mining outputs.";
        } else if (name == pro) {
          description = "Offering up to $amountInCrypto DOGE in mining outputs. Complete all progression levels to receive the entire mining outputs.";
        } else if (name == mega) {
          description = "Offering up to $amountInCrypto DOGE in mining outputs. Complete all progression levels to receive the entire mining outputs.";
        }
        return Container(
          padding: EdgeInsets.all(16.sp),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFAE9FF) : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? const Color(0xFF792A90) : const Color(0xFFE0E0E0),
              width: isSelected ? 1 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$$price $name',
                    style: TextStyle(
                      color: const Color(0xFF2D2D2D),
                      fontSize: 18.sp,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (isSelected)
                    GestureDetector(
                      onTap: _showEarningBreakdownModal,
                      child: Container(
                        width: 24.sp,
                        height: 24.sp,
                        decoration: BoxDecoration(
                          color: const Color(0xFF792A90).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.help_outline,
                          size: 16.sp,
                          color: const Color(0xFF792A90),
                        ),
                      ),
                    ),
                ],
              ),
              10.sp.verticalSpace,
              Text(
                description,
                style: TextStyle(
                  color: const Color(0xFF757575),
                  fontSize: 12.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
              if (isSelected) ...[
                15.sp.verticalSpace,
                AppButton(
                  text: 'Subscribe',
                  textColor: Colors.white,
                  color: const Color(0xFF792A90),
                  onTap: () async{
                    double subPrice = price.toDouble();
                    String subWalletHash = walletController.currentWallet!.hash;
                    String subWalletAddress = walletController.currentWallet!.walletAddress??"";
                    SubscriptionPayload subscriptionDto = SubscriptionPayload(
                      subPackageName: name,
                      subType: mining,
                      subPrice: subPrice,
                      subWalletHash: subWalletHash,
                      subWalletAddress: subWalletAddress,
                       );
                    List<SupportedCoin> supportedCoins = assetController.assets
                        .where(
                          (e) =>
                              e.symbol.toLowerCase() == "usdt" &&
                              e.networkModel!.chainId == 56,
                        )
                        .toList();
                    if (supportedCoins.isEmpty) {
                      showMySnackBar(
                        context: context,
                        message: "You don't have USDT on Bep20 for payment, Please note that USDT is required for payment",
                        type: SnackBarType.error,
                      );
                      return;
                    }
                    var data = {
                      "data": subscriptionDto,
                      "payment_token": supportedCoins.first,
                    };
                    bool? result = await Navigate.awaitToNamed(
                      context,
                      name: AppRoutes.subscribeview,
                      args: data,
                    );
                    if (result == true) {
                      Navigate.back(context);
                    }
                  },
                ),
              ],
            ],
          ),
        );
      }
    );
  }

  void _showEarningBreakdownModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      builder: (context) => EarningBreakdownModal(),
    );
  }
}
