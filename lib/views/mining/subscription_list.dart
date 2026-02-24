import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/data/Models/mining/mining_dto.dart';
import 'package:quanthex/data/Models/mining/mining_info_dto.dart';
import 'package:quanthex/data/Models/subscription/subscription_dto.dart';
import 'package:quanthex/data/controllers/mining/mining_controller.dart';
import 'package:quanthex/data/controllers/wallet_controller.dart';
import 'package:quanthex/data/utils/date_utils.dart';
import 'package:quanthex/data/utils/date_utils.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/routes/app_routes.dart';
import 'package:quanthex/views/home/components/coin_image.dart';
import 'package:quanthex/views/mining/components/horizontal_divider.dart';
import 'package:quanthex/views/mining/mining_view.dart';
import 'package:quanthex/views/mining/subscription_package.dart';
import 'package:quanthex/widgets/app_button.dart';
import 'package:quanthex/views/mining/subscription_package.dart';
import 'package:quanthex/widgets/app_button.dart';
import 'package:quanthex/widgets/global/error_modal.dart';
import 'package:quanthex/widgets/loading_overlay/loading.dart';

const Color _kAccentPurple = Color(0xFF792A90);

class SubscriptionList extends StatefulWidget {
  const SubscriptionList({super.key});

  @override
  State<SubscriptionList> createState() => _SubscriptionListState();
}

class _SubscriptionListState extends State<SubscriptionList> {
  late WalletController walletController;
  @override
  void initState() {
    // TODO: implement initState
    walletController = Provider.of<WalletController>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SafeArea(
        child: Consumer<MiningController>(
          builder: (context, miningController, _) {
            // Extract subscriptions from minings
            String walletAddress = walletController.currentWallet!.walletAddress ?? "";
            List<MiningDto> minings = miningController.minings[walletAddress] ?? [];
            return miningController.fetchingMinings
                ? Loading(size: 30.sp)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      10.sp.verticalSpace,
                      // Header: "> ACTIVE MINING PACKAGE"
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.sp),
                        child: Row(
                          children: [
                            Icon(Icons.arrow_forward_ios, size: 14.sp, color: Colors.white),
                            6.sp.horizontalSpace,
                            Text(
                              'ACTIVE MINING PACKAGE',
                              style: TextStyle(color: Colors.white, fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600, letterSpacing: 0.5),
                            ),
                          ],
                        ),
                      ),
                      16.sp.verticalSpace,
                      !miningController.fetchingMinings && !miningController.fetchingMiningError
                          ? Expanded(
                              child: minings.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.subscriptions_outlined, size: 64.sp, color: const Color(0xFF757575)),
                                          16.sp.verticalSpace,
                                          Text(
                                            'No subscriptions yet',
                                            style: TextStyle(color: const Color(0xFF757575), fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    )
                                  : LayoutBuilder(
                                      builder: (context, constraints) {
                                        return SingleChildScrollView(
                                          padding: EdgeInsets.symmetric(horizontal: 16.sp),
                                          child: SizedBox(height: constraints.maxHeight, child: _buildSubscriptionCard(minings.first)),
                                        );
                                      },
                                    ),
                            )
                          : ErrorModal(
                              callBack: () {
                                miningController.fetchMinings(walletAddress);
                              },
                              message: "Error fetching minings",
                            ),
                    ],
                  );
          },
        ),
      ),
    );
  }

  Widget _buildSubscriptionCard(MiningDto mining) {
    SubscriptionDto subscription = mining.subscription!;
    MiningInfoDto miningInfo = mining.mining!;
    return Container(
      padding: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: greenColor.withOpacity(0.6), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black87.withOpacity(0.25), blurRadius: 20, spreadRadius: 0)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          // Top row: Package name + ACTIVE badge
          Row(
            children: [
              Icon(Icons.rocket_launch_outlined, size: 22.sp, color: Colors.white70),
              8.sp.horizontalSpace,
              Expanded(
                child: Text(
                  subscription.subPackageName ?? '',
                  style: TextStyle(color: Colors.white, fontSize: 18.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 6.sp),
                decoration: BoxDecoration(color: greenColor.withOpacity(0.2).withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6.sp,
                      height: 6.sp,
                      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    ),
                    6.sp.horizontalSpace,
                    Text(
                      'ACTIVE',
                      style: TextStyle(color: Colors.white, fontSize: 11.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          16.sp.verticalSpace,
          // Price
          if (subscription.subPrice != null)
            Text(
              '\$${subscription.subPrice!.toStringAsFixed(0)}',
              style: TextStyle(color: Colors.white, fontSize: 28.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
            ),
          12.sp.verticalSpace,
          // Divider
          HorizontalDivider(),
          16.sp.verticalSpace,
          // Stats: Hash Power, Total Earned, Today
          Container(
            padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 12.sp),
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Expanded(
                  child: _StatItem(icon: Icons.lock_clock, label: 'Date created', value: MyDateUtils.dateToSingleFormat(DateTime.fromMillisecondsSinceEpoch(int.parse(mining.mining!.minCreatedAt!))), accentColor: _kAccentPurple),
                ),
                Container(width: 1, height: 36.sp, color: Colors.white24),
                Expanded(
                  child: _StatItem(icon: Icons.wallet, label: 'Wallet', value: mining.mining?.miningWalletAddress ?? '', accentColor: _kAccentPurple),
                ),
              ],
            ),
          ),
          10.sp.verticalSpace,
          // Mining Progress
          Row(
            children: [
              CoinImage(imageUrl: mining.subscription?.subRewardAssetImage ?? "", height: 20.sp, width: 20.sp),
              4.sp.horizontalSpace,
              Text(
                'Reward: ${mining.subscription?.subRewardAssetSymbol ?? ''}',
                style: TextStyle(color: Colors.white, fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
              ),
              const Spacer(),
            ],
          ),
          const Spacer(),
          20.sp.verticalSpace,
          // VIEW FULL DETAILS button
          GestureDetector(
            onTap: () => Navigate.toNamed(context, name: AppRoutes.miningview, args: mining),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 14.sp),
              decoration: BoxDecoration(
                color: greenColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'VIEW FULL DETAILS',
                  style: TextStyle(color: Colors.white, fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700, letterSpacing: 0.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.icon, required this.label, required this.value, required this.accentColor});

  final IconData icon;
  final String label;
  final String value;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 18.sp, color: accentColor),
        4.sp.verticalSpace,
        Text(
          label,
          style: TextStyle(color: Colors.white70, fontSize: 10.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
          maxLines: 1,
        ),
        2.sp.verticalSpace,
        Text(
          value,
          style: TextStyle(color: Colors.white, fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
