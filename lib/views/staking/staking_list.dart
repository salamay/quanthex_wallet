import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/core/constants/sub_constants.dart';
import 'package:quanthex/data/Models/staking/staking_dto.dart';
import 'package:quanthex/data/controllers/assets/asset_controller.dart';
import 'package:quanthex/data/controllers/mining/mining_controller.dart';
import 'package:quanthex/data/controllers/wallet_controller.dart';
import 'package:quanthex/data/utils/logger.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/routes/app_routes.dart';
import 'package:quanthex/views/home/components/coin_image.dart';
import 'package:quanthex/views/mining/mining_view.dart';
import 'package:quanthex/widgets/app_button.dart';
import 'package:quanthex/widgets/global/empty_view.dart';
import 'package:quanthex/widgets/global/error_modal.dart';
import 'package:quanthex/widgets/quanthex_image_banner.dart';

class StakingList extends StatefulWidget {
  const StakingList({super.key});

  @override
  State<StakingList> createState() => _StakingListState();
}

class _StakingListState extends State<StakingList> {
  static const Color _accent = Color(0xFF792A90);
  late WalletController walletController;
  late MiningController miningController;
  late AssetController assetController;

  @override
  void initState() {
    // TODO: implement initState
    walletController = Provider.of<WalletController>(context, listen: false);
    miningController = Provider.of<MiningController>(context, listen: false);
    assetController = Provider.of<AssetController>(context, listen: false);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      fetchData();
    });
    super.initState();
  }

  void fetchData() async {
    try {
      String walletAddress = walletController.currentWallet!.walletAddress ?? "";
      await miningController.fetchStakings(walletAddress, active);
      List<StakingDto> stakings = miningController.stakings[walletAddress] ?? [];
      if (stakings.isNotEmpty) {
        await miningController.fetchWithdrawals(stakings.first.stakingId ?? "");
        await miningController.fetchReferrals(stakings.first.stakingId ?? "");
      }
    } catch (e) {
      logger("Error fetching data: $e", runtimeType.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Staking',
          style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
        ),
        actions: [
          SizedBox(
            width: 80.w,
            height: 30.h,
            child: AppButton(
              text: 'Create',
              padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
              borderRadius: 10,
              textColor: Colors.white,
              color: greenColor.withOpacity(0.35),
              onTap: () {
                Navigate.toNamed(context, name: AppRoutes.stakingview);
              },
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          fetchData();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
              image: DecorationImage(colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken), image: AssetImage('assets/images/green_astro_bg.jpg'), fit: BoxFit.cover),
            ),
            child: SafeArea(
              child: Consumer<MiningController>(
                builder: (context, miningCtr, child) {
                  String walletAddress = walletController.currentWallet!.walletAddress ?? "";
                  print(walletAddress);
                  List<StakingDto> stakings = miningCtr.stakings[walletAddress] ?? [];
                  return !miningController.fetchingStakingsError
                      ? Column(
                          mainAxisAlignment: stakings.isNotEmpty?MainAxisAlignment.start:MainAxisAlignment.center,
                          children: [
                            stakings.isNotEmpty? Column(
                                    children: stakings.map((e) {
                                      return Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: greenColor.withOpacity(0.6), width: 1.5),
                                          boxShadow: [BoxShadow(color: Colors.black87.withOpacity(0.25), blurRadius: 20, spreadRadius: 0)],
                                        ),
                                        child: ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          minTileHeight: 30.h,
                                          leading: CoinImage(imageUrl: e.stakedAssetImage??"", height: 30, width: 30),
                                          onTap: () {
                                            Navigate.toNamed(context, name: AppRoutes.activeStakingview,args: e);

                                          },
                                          title: Text(
                                            "${e.stakedAmountCrypto.toString()} ${e.stakingRewardAssetSymbol}",
                                            style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                                          ),
                                          subtitle: Text(
                                            e.planName??"N/A",
                                            style: TextStyle(color: Colors.white60, fontSize: 14, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                                          ),
                                          trailing: Text(
                                            "${e.duration.toString()} Months",
                                            style: TextStyle(color: Colors.white60, fontSize: 14, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                                          ),
                                          ),
                                      );
                                    }).toList(),
                                  )
                                : EmptyView(
                                  message: "Stake your tokens to earn rewards. Create a staking position to get started.",
                                  textColor: Colors.white60,
                                  ),
                          ],
                        ) : Center(
                          child: ErrorModal(
                            textColor: Colors.white60,
                            buttonColor: greenColor.withOpacity(0.35),
                            callBack: () {
                              fetchData();
                            },
                          ),
                        );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
