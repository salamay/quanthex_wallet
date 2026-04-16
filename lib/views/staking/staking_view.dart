import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/core/constants/sub_constants.dart';
import 'package:quanthex/data/Models/staking/staking_dto.dart';
import 'package:quanthex/data/Models/staking/staking_payload.dart';
import 'package:quanthex/data/controllers/mining/mining_controller.dart';
import 'package:quanthex/data/controllers/assets/asset_controller.dart';
import 'package:quanthex/data/controllers/wallet_controller.dart';
import 'package:quanthex/routes/app_routes.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/views/staking/active_staking.dart';
import 'package:quanthex/views/staking/components/what_is_staking_card.dart';
import 'package:quanthex/views/staking/components/staking_token_item.dart';
import 'package:quanthex/widgets/arrow_back.dart';
import 'package:quanthex/widgets/bottom_nav_bar.dart';
import 'package:quanthex/widgets/global/empty_view.dart';
import 'package:quanthex/widgets/global/error_modal.dart';
import 'package:quanthex/widgets/quanthex_image_banner.dart';
import 'package:quanthex/widgets/snackbar/my_snackbar.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../data/utils/logger.dart';
import '../../data/Models/assets/supported_assets.dart';

class StakingView extends StatefulWidget {
  const StakingView({super.key});

  @override
  State<StakingView> createState() => _StakingViewState();
}

class _StakingViewState extends State<StakingView> {
  late MiningController miningController;
  late AssetController assetController;
  late WalletController walletController;

  @override
  void initState() {
    super.initState();
    miningController = Provider.of<MiningController>(context, listen: false);
    assetController = Provider.of<AssetController>(context, listen: false);
    walletController = Provider.of<WalletController>(context, listen: false);
  }

  List<SupportedCoin> get _stakableTokens {
    // Filter tokens that can be staked (e.g., USDT on BSC)
    return assetController.assets.where((coin) {
      return coin.symbol.toLowerCase() == 'usdt' && coin.networkModel?.chainId == 56;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: ArrowBack(iconColor: Colors.white),
        centerTitle: true,
       
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(8.sp),
        decoration: BoxDecoration(
          image: DecorationImage(colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken), image: AssetImage('assets/images/green_astro_bg.jpg'), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Content
              Skeletonizer(
                ignoreContainers: false,
                enabled: miningController.fetchingStakings,
                effect: ShimmerEffect(duration: const Duration(milliseconds: 1000), baseColor: Colors.grey.withOpacity(0.4), highlightColor: Colors.white54),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Active Staking Section
                    Consumer<MiningController>(
                      builder: (context, mCtr, child) {
                        String walletAddress = walletController.currentWallet!.walletAddress ?? "";
                        List<StakingDto> stakings = mCtr.stakings[walletAddress] ?? [];
                        return Column(
                          children: [
                            WhatIsStakingCard(
                              onLearnMore: () {
                                // Handle learn more action
                                List<SupportedCoin> supportedCoins = assetController.assets.where((e) => e.symbol.toLowerCase() == "usdt" && e.networkModel!.chainId == 56).toList();
                                if (supportedCoins.isEmpty) {
                                  showMySnackBar(context: context, message: "You don't have USDT on Bep20 to  stake, Please note that USDT is required for payment", type: SnackBarType.error);
                                  return;
                                }
                                SupportedCoin asset = supportedCoins.first;
                                _navigateToStakingView(asset);
                              },
                            ),
                            20.sp.verticalSpace,
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Stakable Tokens',
                                style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                              ),
                            ),
                            // Token List
                            Consumer<AssetController>(
                              builder: (context, assetCtr, child) {
                                List<SupportedCoin> tokens = _stakableTokens;
                                if (tokens.isEmpty) {
                                  return Padding(
                                    padding: EdgeInsets.all(40.sp),
                                    child: Center(
                                      child: Text(
                                        'No stakable tokens available',
                                        style: TextStyle(color: const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  );
                                }
                                return tokens.isEmpty
                                    ? EmptyView(message: "No stakable tokens available")
                                    : Column(
                                        children: tokens.map((token) {
                                          return StakingTokenItem(
                                            coin: token,
                                            onTap: () {
                                              _navigateToStakingView(token);
                                            },
                                          );
                                        }).toList(),
                                      );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    // Tokens Section
                    // TokensSectionHeader(
                    //   selectedFilter: _selectedFilter,
                    //   onFilterTap: () {
                    //     // Show filter options
                    //   },
                    // ),
                    // 10.sp.verticalSpace,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToStakingView(SupportedCoin asset) {
    String subWalletHash = walletController.currentWallet!.hash;
    String subWalletAddress = walletController.currentWallet!.walletAddress ?? "";
    StakingPayload payload = StakingPayload(stakingWalletHash: subWalletHash, stakingWalletAddress: subWalletAddress);
    payload.stakingRewardContract = asset.contractAddress ?? "";
    payload.stakingRewardAssetDecimals = asset.decimal ?? 18;
    payload.stakingRewardAssetSymbol = asset.symbol;
    payload.stakingRewardAssetImage = asset.image;
    payload.stakingRewardAssetName = asset.name;
    payload.stakingRewardChainId = asset.networkModel?.chainId ?? 56;
    payload.stakingRewardChainName = asset.networkModel!.chainName;
    var data = {"data": payload, "payment_token": asset};
    Navigate.toNamed(context, name: AppRoutes.subscribestakingview, args: data);
  }
}
