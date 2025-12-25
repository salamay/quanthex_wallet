import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/data/controllers/user/user_controller.dart';
import 'package:quanthex/data/controllers/wallet_controller.dart';
import 'package:quanthex/data/services/assets/asset_service.dart';
import 'package:quanthex/routes/app_routes.dart';
import 'package:quanthex/utils/assets/asset_utils.dart';
import 'package:quanthex/utils/logger.dart';
import 'package:quanthex/utils/navigator.dart';
import 'package:quanthex/views/home/components/asset_item.dart';
import 'package:quanthex/widgets/app_textfield.dart';
import 'package:quanthex/widgets/bottom_nav_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/constants/network_constants.dart';
import '../../data/Models/assets/supported_assets.dart';
import '../../data/Models/balance/CoinBalance.dart';
import '../../data/controllers/assets/asset_controller.dart';
import '../../data/controllers/balance/balance_controller.dart';
import '../../data/repository/assets/asset_repository.dart';
import '../../utils/my_currency_utils.dart';
import '../../widgets/global/error_modal.dart';
import 'components/quick_action.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _isBalanceVisible = true;
  ValueNotifier<bool> _loadingNotifier = ValueNotifier(true);
  ValueNotifier<bool> _errorNotifier = ValueNotifier(false);
  ValueNotifier<bool> balanceLoadingNotifier = ValueNotifier(true);
  late AssetController assetController;
  late WalletController walletController;
  late BalanceController balanceController;
  late UserController userController;
  AssetService assetService = AssetService.getInstance();

  @override
  void initState() {
    // TODO: implement initState
    assetController = Provider.of<AssetController>(context, listen: false);
    balanceController = Provider.of<BalanceController>(context, listen: false);
    walletController = Provider.of<WalletController>(context, listen: false);
    userController = Provider.of<UserController>(context, listen: false);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      getData();
    });
    super.initState();
  }

  Future<void> getData() async {
    try {
      _loadingNotifier.value = true;
      balanceLoadingNotifier.value = true;
      bool isCacheEmpty = await AssetRepo.isCacheAssetEmpty();
      bool isNew = isCacheEmpty ? true : false;
      logger("isNew: $isNew", runtimeType.toString());
      List<SupportedCoin> assets = await assetController.getAllAssets(isNew: isNew, assetService: assetService, walletController: walletController);
      logger("Assets ${assets.length}", runtimeType.toString());
      await assetController.getAssetsQuotes(balanceController: balanceController,assets: assets);
      await getTokenBalances(context: context);
      userController.getProfile();
      _loadingNotifier.value = false;
      balanceLoadingNotifier.value = false;
      _errorNotifier.value = false;
    } catch (e) {
      logger("Unable to get data", runtimeType.toString());
      _errorNotifier.value = true;
      _loadingNotifier.value = false;
      balanceLoadingNotifier.value = false;
    }
  }

  Future<void> reload()async {
    try{
      balanceController.clear();
      await getData();
      // await balanceController.unWatchAddress();
      // watchAddress();
    }catch(e){
      logger("Error reloading data: $e", runtimeType.toString());
      logger("Error getting data: $e", runtimeType.toString());
      _errorNotifier.value=true;
      _loadingNotifier.value=false;
      balanceLoadingNotifier.value=false;
      return;
    }

  }


  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: ()async{
        reload();
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            20.sp.verticalSpace,
            // Header
            Row(
              children: [
                CircleAvatar(
                  radius: 20.sp,
                  backgroundColor: const Color(0xFFF5F5F5),
                  backgroundImage: AssetImage(
                    'assets/images/logo.png',
                  ),
                  // child: Icon(
                  //   Icons.person,
                  //   size: 24.sp,
                  //   color: const Color(0xFF792A90),
                  // ),
                ),
                10.horizontalSpace,
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.sp,
                    vertical: 6.sp,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Main Wallet',
                        style: TextStyle(
                          color: const Color(0xFF2D2D2D),
                          fontSize: 13.sp,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      5.horizontalSpace,
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 16.sp,
                        color: const Color(0xFF2D2D2D),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                // IconButton(
                //   icon: Container(
                //     width: 41.sp,
                //     height: 41.sp,
                //     padding: const EdgeInsets.all(10),
                //     decoration: ShapeDecoration(
                //       color: const Color(0x7CDADADA),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(20.50),
                //       ),
                //     ),
                //     child: Image.asset(
                //       'assets/images/scan_icon.png',
                //       width: 19.sp,
                //       height: 19.sp,
                //     ),
                //   ),
                //   // Icon(
                //   //   Icons.qr_code_scanner,
                //   //   size: 24.sp,
                //   //   color: const Color(0xFF2D2D2D),
                //   // ),
                //   onPressed: () {
                //     Navigate.toNamed(context, name: '/qrscanview');
                //   },
                // ),
                // IconButton(
                //   icon: Container(
                //     width: 41.sp,
                //     height: 41.sp,
                //     padding: const EdgeInsets.all(10),
                //     decoration: ShapeDecoration(
                //       color: const Color(0x7CDADADA),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(20.50),
                //       ),
                //     ),
                //     child: Image.asset(
                //       'assets/images/noti_icon.png',
                //       width: 19.sp,
                //       height: 19.sp,
                //     ),
                //   ),
                //   onPressed: () {},
                // ),
              ],
            ),
            20.sp.verticalSpace,
            // Search Bar
            AppTextfield(
              hintText: 'Search token',
              prefixIcon: Icon(
                Icons.search,
                size: 20.sp,
                color: const Color(0xFF9E9E9E),
              ),
              filledColor: const Color(0xFFF5F5F5),
              borderColor: const Color(0xFFF5F5F5),
              radius: 25,
            ),
            25.sp.verticalSpace,
            // Portfolio Value
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Portfolio Value',
                  style: TextStyle(
                    color: const Color(0xFF757575),
                    fontSize: 14.sp,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                8.horizontalSpace,
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isBalanceVisible = !_isBalanceVisible;
                    });
                  },
                  child: Icon(
                    _isBalanceVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 18.sp,
                    color: const Color(0xFF757575),
                  ),
                ),
              ],
            ),
            10.sp.verticalSpace,
            ValueListenableBuilder(
                valueListenable: balanceLoadingNotifier,
                builder: (context,balanceLoading,_) {
                  return Consumer<BalanceController>(
                    builder: (context, balanceCtr, child) {
                      return Skeletonizer(
                        ignoreContainers: false,
                        enabled: balanceLoading,
                        effect:  ShimmerEffect(
                            duration: Duration(milliseconds: 1000),
                            baseColor: Colors.grey.withOpacity(0.4),
                            highlightColor: Colors.white54
                        ),
                        child: AutoSizeText(
                          MyCurrencyUtils.formatCurrency(balanceCtr.overallBalance),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF2D2D2D),
                            fontSize: 32.sp,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                        ),
                      );
                    },
                  );
              }
            ),
            8.sp.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon(
                //   Icons.trending_up,
                //   size: 16.sp,
                //   color: const Color(0xFF4CAF50),
                // ),
                // 5.horizontalSpace,
                // Text(
                //   '+\$214.67 (1.74%)',
                //   style: TextStyle(
                //     color: const Color(0xFF4CAF50),
                //     fontSize: 14.sp,
                //     fontFamily: 'Satoshi',
                //     fontWeight: FontWeight.w600,
                //   ),
                // ),
              ],
            ),
            30.sp.verticalSpace,
            // Quick Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: ()async {
                    SupportedCoin? coin = await AssetUtils.selectAssets(context: context);
                    if(coin!=null){
                      logger("Selected Coin: ${coin.name}", runtimeType.toString());
                      Navigate.toNamed(context, name: AppRoutes.receiveview,args: coin);
                    }
                  },
                  child: QuickAction(
                    icon: Icons.arrow_downward,
                    label: 'Deposit',
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    SupportedCoin? coin = await AssetUtils.selectAssets(context: context);
                    if(coin!=null){
                      logger("Selected Coin: ${coin.name}", runtimeType.toString());
                      Navigate.toNamed(context, name: AppRoutes.sendtokenview,args: coin);
                    }
                  },
                  child: QuickAction(
                    icon: Icons.arrow_upward,
                    label: 'Send',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigate.toNamed(context, name: AppRoutes.swaptokenview);
                  },
                  child: QuickAction(
                    icon: Icons.swap_horiz,
                    label: 'Swap',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigate.toNamed(context, name: AppRoutes.transactionhistoryview);
                  },
                  child: QuickAction(
                    icon: Image.asset(
                      'assets/images/history.png',
                      width: 24.sp,
                      height: 24.sp,
                      fit: BoxFit.contain,
                    ),
                    label: 'History',
                  ),
                ),
              ],
            ),
            30.sp.verticalSpace,
            // My Assets
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Assets',
                  style: TextStyle(
                    color: const Color(0xFF2D2D2D),
                    fontSize: 18.sp,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.sp,
                    vertical: 6.sp,
                  ),
                  decoration: BoxDecoration(
                    // color: const Color(0xFFF5F5F5),
                    border: Border.all(color: Color(0xFFF5F5F5)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add,
                        size: 16.sp,
                        color: const Color(0xFF2D2D2D),
                      ),
                      5.horizontalSpace,
                      Text(
                        'Add token',
                        style: TextStyle(
                          color: const Color(0xFF2D2D2D),
                          fontSize: 12.sp,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            20.sp.verticalSpace,
            // Assets List
            ValueListenableBuilder(
                valueListenable: _errorNotifier,
                builder: (context,isError,_) {
                return !isError?ValueListenableBuilder(
                    valueListenable: _loadingNotifier,
                    builder: (context,loading,_) {
                    return Skeletonizer(
                      ignoreContainers: false,
                      enabled: loading,
                      effect:  ShimmerEffect(
                          duration: Duration(milliseconds: 1000),
                          baseColor: Colors.grey.withOpacity(0.4),
                          highlightColor: Colors.white54
                      ),
                      child: Consumer<AssetController>(
                        builder: (context, assetCtr, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: assetCtr.assets.map((e){
                              return AssetItem(coin: e);
                            }).toList()
                          );
                        },
                      ),
                    );
                  }
                ):ErrorModal(
                  callBack: (){
                    _errorNotifier.value=false;
                    _loadingNotifier.value=true;
                    reload();
                  },
                );
              }
            ),
            10.sp.verticalSpace,
          ],
        ),
      ),
    );
  }

  Future<void> getTokenBalances({required BuildContext context})async{
    List<SupportedCoin> assets=assetController.assets;
    List<SupportedCoin> tokens=assets.where((element) => element.coinType==CoinType.TOKEN).toList();
    List<SupportedCoin> nativeTokens=assets.where((element) => element.coinType==CoinType.NATIVE_TOKEN||element.coinType==CoinType.WRAPPED_TOKEN).toList();
    Map<String,CoinBalance> results=await balanceController.getTokenBalance(tokens);
    await Future.wait(nativeTokens.map((e)async{
      int old=DateTime.now().second;
      await Future.delayed(const Duration(milliseconds: 500),() async {});
      int newTime=DateTime.now().second;
      logger("Time taken: ${newTime-old}",runtimeType.toString());
      CoinBalance? nativeBalance=await balanceController.getNativeCoinBalance(asset: e);
      results[e.symbol]=nativeBalance??CoinBalance(balanceInCrypto: 0, balanceInFiat: 0);
    }));
    balanceController.overallBalance = 0;
    balanceController.calculateTotalBalance(results);
  }
}
