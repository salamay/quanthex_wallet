import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/data/Models/wallets/wallet_model.dart';
import 'package:quanthex/data/controllers/user/user_controller.dart';
import 'package:quanthex/data/controllers/wallet_controller.dart';
import 'package:quanthex/data/services/assets/asset_service.dart';
import 'package:quanthex/routes/app_routes.dart';
import 'package:quanthex/data/utils/assets/asset_utils.dart';
import 'package:quanthex/data/utils/logger.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/views/home/components/asset_item.dart';
import 'package:quanthex/views/home/components/token_search_delegate.dart';
import 'package:quanthex/widgets/quanthex_image_banner.dart';
import 'package:quanthex/widgets/snackbar/my_snackbar.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/constants/network_constants.dart';
import '../../data/Models/assets/supported_assets.dart';
import '../../data/Models/balance/CoinBalance.dart';
import '../../data/controllers/assets/asset_controller.dart';
import '../../data/controllers/balance/balance_controller.dart';
import '../../data/repository/assets/asset_repository.dart';
import '../../data/utils/my_currency_utils.dart';
import '../../widgets/global/error_modal.dart';
import 'components/quick_action.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
      await assetController.getAssetsQuotes(balanceController: balanceController, assets: assets);
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

  Future<void> reload() async {
    try {
      balanceController.clear();
      await getData();
      // await balanceController.unWatchAddress();
      // watchAddress();
    } catch (e) {
      logger("Error reloading data: $e", runtimeType.toString());
      logger("Error getting data: $e", runtimeType.toString());
      _errorNotifier.value = true;
      _loadingNotifier.value = false;
      balanceLoadingNotifier.value = false;
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
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
                  backgroundImage: AssetImage('assets/images/logo.png'),
                  // child: Icon(
                  //   Icons.person,
                  //   size: 24.sp,
                  //   color: const Color(0xFF792A90),
                  // ),
                ),
                10.horizontalSpace,
                Consumer<WalletController>(
                  builder: (context, walletCtr, child) {
                    String walletName = walletCtr.currentWallet?.name ?? 'Wallet ${walletCtr.currentWallet?.walletAddress?.substring(0, 6) ?? 'Unknown'}';
                    return GestureDetector(
                      onTap: () => _showWalletSelector(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 6.sp),
                        decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              walletName,
                              style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 13.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                            ),
                            5.horizontalSpace,
                            Icon(Icons.keyboard_arrow_down, size: 16.sp, color: const Color(0xFF2D2D2D)),
                          ],
                        ),
                      ),
                    );
                  },
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
            // Quanthex Image Banner
            10.sp.verticalSpace,
            // Search Bar
            GestureDetector(
              onTap: () {
                final assetCtr = Provider.of<AssetController>(context, listen: false);
                showSearch(context: context, delegate: TokenSearchDelegate(assetCtr.assets));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: const Color(0xFFF5F5F5), width: 1),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, size: 20.sp, color: const Color(0xFF9E9E9E)),
                    10.horizontalSpace,
                    Text(
                      'Search token',
                      style: TextStyle(color: const Color(0xFF9E9E9E), fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
            15.sp.verticalSpace,
            // Portfolio Value
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Portfolio Value',
                  style: TextStyle(color: const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                ),
                8.horizontalSpace,
                Consumer<BalanceController>(
                  builder: (context, balanceCtr, child) {
                    return GestureDetector(
                      onTap: () {
                        balanceCtr.toggleHideBalance();
                      },
                      child: Icon(!balanceCtr.hideBalance ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 18.sp, color: const Color(0xFF757575)),
                    );
                  },
                ),
              ],
            ),
            10.sp.verticalSpace,
            ValueListenableBuilder(
              valueListenable: balanceLoadingNotifier,
              builder: (context, balanceLoading, _) {
                return Consumer<BalanceController>(
                  builder: (context, balanceCtr, child) {
                    return Skeletonizer(
                      ignoreContainers: false,
                      enabled: balanceLoading,
                      effect: ShimmerEffect(duration: Duration(milliseconds: 1000), baseColor: Colors.grey.withOpacity(0.4), highlightColor: Colors.white54),
                      child: AutoSizeText(
                        balanceCtr.hideBalance ? '****' : MyCurrencyUtils.formatCurrency(balanceCtr.overallBalance),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 32.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                        maxLines: 1,
                      ),
                    );
                  },
                );
              },
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
            10.sp.verticalSpace,
            // Quick Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    SupportedCoin? coin = await AssetUtils.selectAssets(context: context);
                    if (coin != null) {
                      logger("Selected Coin: ${coin.name}", runtimeType.toString());
                      Navigate.toNamed(context, name: AppRoutes.receiveview, args: coin);
                    }
                  },
                  child: QuickAction(icon: Icons.arrow_downward, label: 'Deposit'),
                ),
                20.horizontalSpace,
                GestureDetector(
                  onTap: () async {
                    SupportedCoin? coin = await AssetUtils.selectAssets(context: context);
                    if (coin != null) {
                      logger("Selected Coin: ${coin.name}", runtimeType.toString());
                      Navigate.toNamed(context, name: AppRoutes.sendtokenview, args: coin);
                    }
                  },
                  child: QuickAction(icon: Icons.arrow_upward, label: 'Send'),
                ),
                // GestureDetector(
                //   onTap: () {
                //     Navigate.toNamed(context, name: AppRoutes.swaptokenview);
                //   },
                //   child: QuickAction(
                //     icon: Icons.swap_horiz,
                //     label: 'Swap',
                //   ),
                // ),
                // GestureDetector(
                //   onTap: () {
                //     Navigate.toNamed(
                //       context,
                //       name: AppRoutes.transactionhistoryview,
                //     );
                //   },
                //   child: QuickAction(
                //     icon: Image.asset(
                //       'assets/images/history.png',
                //       width: 24.sp,
                //       height: 24.sp,
                //       fit: BoxFit.contain,
                //     ),
                //     label: 'History',
                //   ),
                // ),
              ],
            ),
            20.sp.verticalSpace,
            // My Assets
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Assets',
                  style: TextStyle(color: const Color(0xFF757575), fontSize: 18.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                ),
                // Container(
                //   padding: EdgeInsets.symmetric(
                //     horizontal: 12.sp,
                //     vertical: 6.sp,
                //   ),
                //   decoration: BoxDecoration(
                //     // color: const Color(0xFFF5F5F5),
                //     border: Border.all(color: Color(0xFFF5F5F5)),
                //     borderRadius: BorderRadius.circular(20),
                //   ),
                //   child: Row(
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       Icon(
                //         Icons.add,
                //         size: 16.sp,
                //         color: const Color(0xFF2D2D2D),
                //       ),
                //       5.horizontalSpace,
                //       Text(
                //         'Add token',
                //         style: TextStyle(
                //           color: const Color(0xFF2D2D2D),
                //           fontSize: 12.sp,
                //           fontFamily: 'Satoshi',
                //           fontWeight: FontWeight.w500,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
            5.sp.verticalSpace,
            // Assets List
            ValueListenableBuilder(
              valueListenable: _errorNotifier,
              builder: (context, isError, _) {
                return !isError
                    ? ValueListenableBuilder(
                        valueListenable: _loadingNotifier,
                        builder: (context, loading, _) {
                          return Skeletonizer(
                            ignoreContainers: false,
                            enabled: loading,
                            effect: ShimmerEffect(duration: Duration(milliseconds: 1000), baseColor: Colors.grey.withOpacity(0.4), highlightColor: Colors.white54),
                            child: Consumer<AssetController>(
                              builder: (context, assetCtr, child) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: assetCtr.assets.map((e) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigate.toNamed(context, name: AppRoutes.ethereumdetailview, args: e);
                                      },
                                      child: AssetItem(coin: e),
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                          );
                        },
                      )
                    : ErrorModal(
                        callBack: () {
                          _errorNotifier.value = false;
                          _loadingNotifier.value = true;
                          reload();
                        },
                      );
              },
            ),
            10.sp.verticalSpace,
          ],
        ),
      ),
    );
  }

  Future<void> getTokenBalances({required BuildContext context}) async {
    List<SupportedCoin> assets = assetController.assets;
    List<SupportedCoin> tokens = assets.where((element) => element.coinType == CoinType.TOKEN).toList();
    List<SupportedCoin> nativeTokens = assets.where((element) => element.coinType == CoinType.NATIVE_TOKEN || element.coinType == CoinType.WRAPPED_TOKEN).toList();
    Map<String, CoinBalance> results = await balanceController.getTokenBalance(tokens);
    await Future.wait(
      nativeTokens.map((e) async {
        int old = DateTime.now().second;
        await Future.delayed(const Duration(milliseconds: 500), () async {});
        int newTime = DateTime.now().second;
        logger("Time taken: ${newTime - old}", runtimeType.toString());
        CoinBalance? nativeBalance = await balanceController.getNativeCoinBalance(asset: e);
        results[e.symbol] = nativeBalance ?? CoinBalance(balanceInCrypto: 0, balanceInFiat: 0);
      }),
    );
    balanceController.overallBalance = 0;
    balanceController.calculateTotalBalance(results);
  }

  List<Color> _generateGradientFromAddress(String address) {
    final colors = [
      [Colors.blue, Colors.purple],
      [Colors.purple, Colors.pink],
      [Colors.red, Colors.orange],
      [Colors.orange, Colors.yellow],
      [Colors.green, Colors.teal],
      [Colors.teal, Colors.blue],
      [Colors.pink, Colors.red],
      [Colors.yellow, Colors.green],
    ];
    int hash = address.hashCode;
    int index = hash.abs() % colors.length;
    return colors[index];
  }

  String _getWalletDisplayName(WalletModel wallet) {
    return wallet.name ?? 'Wallet ${wallet.walletAddress?.substring(0, 6) ?? 'Unknown'}';
  }

  String _getShortAddress(WalletModel wallet) {
    if (wallet.walletAddress == null || wallet.walletAddress!.isEmpty) {
      return 'Unknown';
    }
    String address = wallet.walletAddress!;
    if (address.length > 10) {
      return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
    }
    return address;
  }

  void _showWalletSelector(BuildContext context) {
    // Ensure wallets are loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WalletController>(context, listen: false).loadWallets();
    });

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.sp,
              height: 4.sp,
              margin: EdgeInsets.only(top: 10.sp, bottom: 20.sp),
              decoration: BoxDecoration(color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(2)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.sp),
              child: Row(
                children: [
                  Text(
                    'Select Wallet',
                    style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 20.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline, size: 24.sp),
                    onPressed: () {
                      Navigator.pop(context);
                      _showAddWalletOptions(context);
                    },
                  ),
                ],
              ),
            ),
            10.sp.verticalSpace,
            Flexible(
              child: Consumer<WalletController>(
                builder: (context, walletCtr, child) {
                  if (walletCtr.wallets.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.all(40.sp),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.account_balance_wallet_outlined, size: 64.sp, color: const Color(0xFF757575)),
                          20.sp.verticalSpace,
                          Text(
                            'No Wallets',
                            style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 18.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                          ),
                          8.sp.verticalSpace,
                          Text(
                            'Create or import a wallet to get started',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 20.sp),
                    itemCount: walletCtr.wallets.length,
                    itemBuilder: (context, index) {
                      final wallet = walletCtr.wallets[index];
                      final isSelected = walletCtr.currentWallet?.walletAddress == wallet.walletAddress;
                      return _buildWalletSelectorItem(context, wallet, isSelected);
                    },
                  );
                },
              ),
            ),
            20.sp.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildWalletSelectorItem(BuildContext context, WalletModel wallet, bool isSelected) {
    final gradient = _generateGradientFromAddress(wallet.walletAddress ?? '');

    return GestureDetector(
      onTap: () async {
        if (!isSelected) {
          Navigator.pop(context);
          await _switchWallet(wallet);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 16.sp),
        margin: EdgeInsets.only(bottom: 8.sp),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF9E6FF) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: const Color(0xFF792A90), width: 1) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 40.sp,
              height: 40.sp,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
                shape: BoxShape.circle,
              ),
            ),
            15.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getWalletDisplayName(wallet),
                    style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                  ),
                  4.sp.verticalSpace,
                  Text(
                    _getShortAddress(wallet),
                    style: TextStyle(color: const Color(0xFF757575), fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, size: 20.sp, color: const Color(0xFF792A90)),
          ],
        ),
      ),
    );
  }

  Future<void> _switchWallet(WalletModel wallet) async {
    try {
      await walletController.switchWallet(wallet);
      // Refresh data after switching wallet
      await reload();
      if (mounted) {
        showMySnackBar(context: context, message: 'Wallet switched successfully', type: SnackBarType.success);
      }
    } catch (e) {
      logger("Error switching wallet: $e", runtimeType.toString());
      if (mounted) {
        showMySnackBar(context: context, message: 'Failed to switch wallet', type: SnackBarType.error);
      }
    }
  }

  void _showAddWalletOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.sp,
              height: 4.sp,
              margin: EdgeInsets.only(top: 10.sp, bottom: 20.sp),
              decoration: BoxDecoration(color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(2)),
            ),
            _buildAddOption(
              context,
              icon: Icons.add_circle_outline,
              title: 'Create New Wallet',
              onTap: () {
                Navigator.pop(context);
                Navigate.toNamed(context, name: AppRoutes.setupwalletview);
              },
            ),
            _buildAddOption(
              context,
              icon: Icons.download_outlined,
              title: 'Import Wallet',
              onTap: () {
                Navigator.pop(context);
                Navigate.toNamed(context, name: AppRoutes.importwalletview);
              },
            ),
            20.sp.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildAddOption(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 16.sp),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF2D2D2D), size: 24.sp),
            15.horizontalSpace,
            Text(
              title,
              style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
