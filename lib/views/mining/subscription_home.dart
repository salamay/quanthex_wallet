import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/data/Models/mining/mining_dto.dart';
import 'package:quanthex/data/controllers/assets/asset_controller.dart';
import 'package:quanthex/data/controllers/mining/mining_controller.dart';
import 'package:quanthex/data/controllers/user/user_controller.dart';
import 'package:quanthex/data/controllers/wallet_controller.dart';
import 'package:quanthex/data/utils/logger.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/routes/app_routes.dart';
import 'package:quanthex/views/mining/components/how_it_works_item.dart';
import 'package:quanthex/views/mining/mining_view.dart';
import 'package:quanthex/views/mining/subscription_list.dart';
import 'package:quanthex/views/mining/subscription_package.dart';
import 'package:quanthex/widgets/app_button.dart';
import 'package:quanthex/widgets/global/error_modal.dart';
import 'package:quanthex/widgets/quanthex_image_banner.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SubscriptionHome extends StatefulWidget {
  const SubscriptionHome({super.key});

  @override
  State<SubscriptionHome> createState() => _SubscriptionHomeState();
}

class _SubscriptionHomeState extends State<SubscriptionHome> {
  late AssetController assetController;
  late MiningController miningController;
  late UserController userController;
  late WalletController walletController;
  int selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    assetController = Provider.of<AssetController>(context, listen: false);
    miningController = Provider.of<MiningController>(context, listen: false);
    userController = Provider.of<UserController>(context, listen: false);
    walletController = Provider.of<WalletController>(context, listen: false);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      fetchData();
    });
    super.initState();
  }

  void fetchData() async {
    try {
      // await userController.getReferrals();
      String walletAddress = walletController.currentWallet!.walletAddress ?? "";
      await miningController.fetchMinings(walletAddress);
    } catch (e) {
      logger("Error fetching data: $e", runtimeType.toString());
      miningController.fetchingMiningError = true;
      miningController.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(8.sp),
       decoration: BoxDecoration(
        image: DecorationImage(colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken), image: AssetImage('assets/images/green_astro_bg.jpg'), fit: BoxFit.cover),
      ),
      child: Consumer<MiningController>(
        builder: (context, miningCtr, _) {
          String walletAddress = walletController.currentWallet!.walletAddress ?? "";
          List<MiningDto> minings = miningCtr.minings[walletAddress] ?? [];
          return Skeletonizer(
            ignoreContainers: false,
            enabled: miningCtr.fetchingMinings,
            effect: ShimmerEffect(
              duration: Duration(milliseconds: 1000),
               baseColor: Colors.grey.withOpacity(0.4), 
               highlightColor: Colors.white54
               ),
            child: RefreshIndicator(
              onRefresh: () async {
                fetchData();
              },
              child: !miningCtr.fetchingMiningError
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Subscriptions',
                              style: TextStyle(color: Colors.white, fontSize: 24.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                            ),
                            // TextButton(
                            //   onPressed: () {
                            //     Navigate.toNamed(context, name: AppRoutes.packageview);
                            //   },
                            //   child: Text(
                            //     'Activate Package',
                            //     style: TextStyle(color: Colors.white, fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                            //   ),
                            // ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: QuanthexImageBanner(width: 110.sp, height: 30.sp),
                        ),
                        minings.isEmpty
                            ? Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 24.sp),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Icon with gradient background
                                      Container(
                                        width: 120.sp,
                                        height: 120.sp,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [const Color(0xFF792A90).withOpacity(0.1), const Color(0xFF792A90).withOpacity(0.05)]),
                                        ),
                                        child: Icon(Icons.subscriptions_outlined, size: 60.sp, color: const Color(0xFF792A90)),
                                      ),
                                      20.sp.verticalSpace,
                                      // Title
                                      Text(
                                        'No Subscriptions Yet',
                                        style: TextStyle(color: Colors.white, fontSize: 24.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                                        textAlign: TextAlign.center,
                                      ),
                                      12.sp.verticalSpace,
                                      // Description
                                      Text(
                                        'Start your mining journey by subscribing to a package. Choose from our available plans and begin mining.',
                                        style: TextStyle(color: Colors.white70, fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400, height: 1.5),
                                        textAlign: TextAlign.center,
                                      ),
                                      40.sp.verticalSpace,
                                      // Subscribe Button with enhanced styling
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          boxShadow: [BoxShadow(color: greenColor.withOpacity(0.3), blurRadius: 12, offset: Offset(0, 4))],
                                        ),
                                        child: AppButton(
                                          text: 'Browse Packages',
                                          textColor: Colors.white,
                                          color: greenColor.withOpacity(0.2),
                                          onTap: () async {
                                            bool? result = await Navigate.awaitToNamed(context, name: AppRoutes.packageview);
                                            if (result == true) {
                                              fetchData();
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Expanded(child: SubscriptionList()),
                      ],
                    )
                  : Center(
                      child: ErrorModal(
                        textColor: Colors.white,
                        buttonColor: greenColor.withOpacity(0.2),
                        callBack: () {
                          fetchData();
                        },
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
