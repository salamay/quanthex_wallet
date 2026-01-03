import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/core/constants/network_constants.dart';
import 'package:quanthex/data/Models/assets/scan_token.dart';
import 'package:quanthex/data/Models/assets/supported_assets.dart';
import 'package:quanthex/data/Models/balance/CoinBalance.dart';
import 'package:quanthex/data/Models/balance/platform_data.dart';
import 'package:quanthex/data/controllers/assets/asset_controller.dart';
import 'package:quanthex/data/controllers/balance/balance_controller.dart';
import 'package:quanthex/routes/app_routes.dart';
import 'package:quanthex/data/utils/assets/asset_utils.dart';
import 'package:quanthex/data/utils/logger.dart';
import 'package:quanthex/data/utils/my_currency_utils.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/widgets/app_button.dart';
import 'package:quanthex/views/home/components/coin_image.dart';
import 'package:quanthex/widgets/global/error_modal.dart';
import 'package:quanthex/widgets/global/empty_view.dart';
import 'package:quanthex/widgets/overview_tab_bar.dart';
import 'package:quanthex/views/transaction/transaction_screen.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:coingecko_api/data/coin.dart' as coingecko_coin;

class EthereumDetailView extends StatefulWidget {
  final SupportedCoin coin;
  const EthereumDetailView({super.key, required this.coin});

  @override
  State<EthereumDetailView> createState() => _EthereumDetailViewState();
}

class _EthereumDetailViewState extends State<EthereumDetailView> {
  String _selectedTimeframe = '1W';
  bool _isFavorited = false;
  PageController _pageController = PageController();
  int _currentPage = 0;
  final List<String> _timeframes = ['1D', '1W', '1M', '6M', '1Y', 'ALL'];
  late AssetController assetController;
  late BalanceController balanceController;
  ValueNotifier<bool> scannedTokenLoadingNotifier = ValueNotifier(true);
  ValueNotifier<bool> scannedTokenErrorNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    assetController = Provider.of<AssetController>(context, listen: false);
    balanceController = Provider.of<BalanceController>(context, listen: false);
    _pageController.addListener(() {
      if (_pageController.page != null) {
        int newPage = _pageController.page!.round();
        if (newPage != _currentPage) {
          setState(() {
            _currentPage = newPage;
          });
        }
      }
    });
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      getTokenData();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> getTokenData() async {
    try {
      scannedTokenErrorNotifier.value = false;
      scannedTokenLoadingNotifier.value = true;
      Map<String, PlatformData>? existingPlatform = balanceController.platforms;
      if (existingPlatform.isEmpty) {
        existingPlatform = await balanceController.getAssetsPlatform();
      }
      String chainId = widget.coin.networkModel!.chainId.toString();
      String id = existingPlatform?[chainId]?.nativeCoinId ?? "";
      if (widget.coin.coinType == CoinType.TOKEN || widget.coin.coinType == CoinType.WRAPPED_TOKEN) {
        String tokenAddress = widget.coin.contractAddress!.toLowerCase();
        String chainSymbol = widget.coin.networkModel!.chainSymbol.toUpperCase();
        await assetController.getScannedTokens(tokenAddress: tokenAddress, chainSymbol: chainSymbol);
      } else {
        await assetController.getTokenMetaDatabyId(id: id, symbol: widget.coin.symbol.toUpperCase());
      }
      scannedTokenLoadingNotifier.value = false;
      scannedTokenErrorNotifier.value = false;
    } catch (e) {
      logger("Unable to get data", runtimeType.toString());
      scannedTokenLoadingNotifier.value = true;
      scannedTokenErrorNotifier.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        leadingWidth: 80.sp,
        leading: GestureDetector(
          onTap: () {
            Navigate.back(context);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back, size: 20.sp),
              5.horizontalSpace,
              Text(
                'Back',
                style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        actions: [],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.sp.verticalSpace,

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CoinImage(imageUrl: widget.coin.image, height: 20.sp, width: 20.sp),
                    8.horizontalSpace,
                    Text(
                      widget.coin.name,
                      style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 18.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                    ),
                    4.horizontalSpace,
                    Text(
                      "(${widget.coin.networkModel!.chainSymbol.toUpperCase()})",
                      style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                    ),
                  ],
                ),

                // Price
                Consumer<BalanceController>(
                  builder: (context, bCtr, child) {
                    double? priceQuote = bCtr.priceQuotes[widget.coin.symbol.toUpperCase()];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          priceQuote != null ? MyCurrencyUtils.formatCurrency(priceQuote) : 'Loading...',
                          style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 32.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                        ),
                        15.horizontalSpace,
                      ],
                    );
                  },
                ),

                10.sp.verticalSpace,
                // Asset Balance Card
                Consumer<BalanceController>(
                  builder: (context, bCtr, child) {
                    double? priceQuote = bCtr.priceQuotes[widget.coin.symbol.toUpperCase()];
                    CoinBalance? balance = widget.coin.coinType == CoinType.TOKEN ? bCtr.balances[widget.coin.contractAddress!] : bCtr.balances[widget.coin.symbol];

                    double balanceInCrypto = balance?.balanceInCrypto ?? 0.0;
                    double balanceInFiat = balance?.balanceInFiat ?? 0.0;
                    bool hideBalance = bCtr.hideBalance;

                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 8.sp),
                      decoration: ShapeDecoration(
                        gradient: LinearGradient(begin: Alignment(0.00, 0.50), end: Alignment(1.00, 0.50), colors: [const Color(0xFFFBF0FF), const Color(0xFFE6B4F5)]),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 2, color: const Color(0xFFEDE5F0)),
                          borderRadius: BorderRadius.circular(19),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Asset\'s Balance',
                                  style: TextStyle(color: const Color(0xFF393939), fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700, height: 1.83, letterSpacing: -0.41),
                                ),
                                Text(
                                  'Token Balance',
                                  style: TextStyle(color: const Color(0xFF959595), fontSize: 10.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500, height: 2.20),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      hideBalance
                                          ? '****'
                                          : balanceInCrypto != 0
                                          ? '${MyCurrencyUtils.format(balanceInCrypto, widget.coin.coinType == CoinType.TOKEN ? 2 : 6)} ${widget.coin.symbol}'
                                          : '0 ${widget.coin.symbol}',
                                      style: TextStyle(color: const Color(0xFF333333), fontSize: 18.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w900, height: 1.22),
                                    ),
                                    if (!hideBalance && balanceInFiat > 0)
                                      Text(
                                        ' ≈ ${MyCurrencyUtils.formatCurrency(balanceInFiat)}',
                                        style: TextStyle(color: const Color(0xFF595959), fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700, height: 1.83, letterSpacing: -0.41),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 86,
                            height: 76,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(19),
                              image: DecorationImage(
                                image: AssetImage("assets/images/photoroomimage.png"), 
                                colorFilter: ColorFilter.mode(Color(0xFFE6B4F5), BlendMode.colorBurn), 
                                fit: BoxFit.fill
                                ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                10.sp.verticalSpace,
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: 'Send',
                        textColor: Colors.white,
                        padding: EdgeInsets.all(5),
                        color: const Color(0xFF792A90),
                        onTap: () async {
                          Navigate.toNamed(context, name: AppRoutes.sendtokenview, args: widget.coin);
                        },
                      ),
                    ),
                    15.horizontalSpace,
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigate.toNamed(context, name: AppRoutes.receiveview, args: widget.coin);
                        },
                        child: Container(
                          height: 50.sp,
                          decoration: BoxDecoration(color: const Color(0xFFF9E6FF), borderRadius: BorderRadius.circular(50)),
                          child: Center(
                            child: Text(
                              'Receive',
                              style: TextStyle(color: const Color(0xFF792A90), fontSize: 15.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    ),
                    15.horizontalSpace,
                    Container(
                      width: 50.sp,
                      height: 50.sp,
                      decoration: BoxDecoration(color: const Color(0xFFF9E6FF), shape: BoxShape.circle),
                      child: Icon(Icons.swap_horiz, color: const Color(0xFF792A90), size: 24.sp),
                    ),
                  ],
                ),
                20.sp.verticalSpace,
                // Tab Bar
                OverviewTabBar(
                  selectedIndex: _currentPage,
                  onTabSelected: (index) {
                    _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                  },
                ),
                // PageView Content
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: PageView(
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    children: [
                      // Overview Page
                      SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: ValueListenableBuilder(
                          valueListenable: scannedTokenErrorNotifier,
                          builder: (context, error, child) {
                            if (error) {
                              return ErrorModal(
                                callBack: () async {
                                  getTokenData();
                                },
                              );
                            }
                            return ValueListenableBuilder(
                              valueListenable: scannedTokenLoadingNotifier,
                              builder: (context, loading, child) {
                                return Skeletonizer(
                                  ignoreContainers: true,
                                  enabled: loading,
                                  effect: ShimmerEffect(duration: Duration(milliseconds: 1000), baseColor: Colors.grey.withOpacity(0.4), highlightColor: Colors.white54),
                                  child: Consumer<AssetController>(
                                    builder: (context, assetController, child) {
                                      ScannedToken? scannedToken = assetController.scannedTokens[widget.coin.contractAddress!.toLowerCase()];
                                      coingecko_coin.Coin? tokenMetadata = assetController.tokenMetadatas[widget.coin.symbol.toLowerCase()];

                                      return widget.coin.coinType == CoinType.TOKEN || widget.coin.coinType == CoinType.WRAPPED_TOKEN
                                          ? Builder(
                                              builder: (context) {
                                                if (scannedToken == null) {
                                                  return EmptyView(message: 'No token data available');
                                                }
                                                return Column(
                                                  children: [
                                                    _buildInfoItem('Name', scannedToken.name ?? ''),
                                                    _buildInfoItem('Symbol', scannedToken.symbol ?? ''),
                                                    _buildInfoItem('Decimals', scannedToken.decimals ?? ''),
                                                    _buildInfoItem('Total Supply', scannedToken.totalSupply ?? ''),
                                                    _buildInfoItem('Address', scannedToken.address ?? '', isCopy: true),
                                                    _buildInfoItem('Website', scannedToken.links?.website ?? '', isLink: true),
                                                    _buildInfoItem('Github', scannedToken.links?.github ?? '', isLink: true),
                                                    _buildInfoItem('Reddit', scannedToken.links?.reddit ?? '', isLink: true),
                                                    _buildInfoItem('Security Score', scannedToken.securityScore?.toString() ?? ''),
                                                    _buildInfoItem('Validated', scannedToken.validated?.toString() ?? ''),
                                                    _buildInfoItem('Created At', scannedToken.createdAt?.toIso8601String() ?? ''),
                                                    _buildInfoItem('Possible Spam', scannedToken.possibleSpam?.toString() ?? ''),
                                                    _buildInfoItem('Verified Contract', scannedToken.verifiedContract?.toString() ?? ''),
                                                    _buildInfoItem('Categories', scannedToken.categories?.join(', ') ?? ''),
                                                  ],
                                                );
                                              },
                                            )
                                          : Builder(
                                              builder: (context) {
                                                if (tokenMetadata == null) {
                                                  return EmptyView(message: 'No token data available');
                                                }
                                                return Column(
                                                  children: [
                                                    _buildInfoItem('Name', tokenMetadata.name),
                                                    _buildInfoItem('Symbol', tokenMetadata.symbol),
                                                    // _buildInfoItem('Description', tokenMetadata?.description?.translations['en'] ?? ''),
                                                    _buildInfoItem('Market rank', tokenMetadata.marketCapRank?.toString() ?? ''),
                                                    _buildInfoItem('Total supply', tokenMetadata.marketData?.totalSupply?.toString() ?? ''),
                                                    _buildInfoItem('Circulating supply', tokenMetadata.marketData?.circulatingSupply?.toString() ?? ''),
                                                    _buildInfoItem('Max supply', tokenMetadata.marketData?.maxSupply?.toString() ?? ''),
                                                    _buildInfoItem('Total supply', tokenMetadata.marketData?.totalSupply?.toString() ?? ''),
                                                    _buildInfoItem('Roi', tokenMetadata.marketData?.roi?.toString() ?? 'N/A'),
                                                  ],
                                                );
                                              },
                                            );
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      // Transactions Page
                      TransactionScreen(coin: widget.coin),
                    ],
                  ),
                ),

                30.sp.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String label, {required bool isSelected}) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: isSelected ? const Color(0xFF2D2D2D) : const Color(0xFF757575), fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
        ),
        8.verticalSpace,
        Container(
          width: 80.sp,
          height: 3.sp,
          decoration: BoxDecoration(color: isSelected ? const Color(0xFF792A90) : Colors.transparent, borderRadius: BorderRadius.circular(2)),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value, {bool isLink = false, bool isCopy = false}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 15.sp),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: const Color(0xFFE0E0E0), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(color: const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
          ),
          10.horizontalSpace,
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.end,
            ),
          ),
          5.horizontalSpace,
          if (isLink || isCopy)
            Container(
              width: 20.sp,
              height: 20.sp,
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),

              child: Icon(Icons.copy, size: 12.sp, color: const Color(0xFF792A90)),
            ),
        ],
      ),
    );
  }
}
