import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/data/Models/mining/mining_dto.dart';
import 'package:quanthex/data/Models/subscription/subscription_dto.dart';
import 'package:quanthex/data/controllers/mining/mining_controller.dart';
import 'package:quanthex/data/utils/date_utils.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/routes/app_routes.dart';
import 'package:quanthex/views/mining/subscription_package.dart';
import 'package:quanthex/widgets/quanthex_image_banner.dart';

class SubscriptionList extends StatefulWidget {
  const SubscriptionList({super.key});

  @override
  State<SubscriptionList> createState() => _SubscriptionListState();
}

class _SubscriptionListState extends State<SubscriptionList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SafeArea(
        child: Consumer<MiningController>(
          builder: (context, miningController, _) {
            // Extract subscriptions from minings
            List<MiningDto> minings = miningController.minings.where((mining) => mining.subscription != null).toList();
            return Column(
              children: [
                
                // Header
                // Align(
                //   alignment: Alignment.centerLeft,
                //   child: QuanthexImageBanner(width: 110.sp, height: 30.sp),
                // ),
              
              10.sp.verticalSpace,
                // Grid View
                Expanded(
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
                      : GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12.sp, mainAxisSpacing: 12.sp, childAspectRatio: 0.75),
                          itemCount: minings.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: (){
                                MiningDto mining = minings[index];
                                Navigate.toNamed(context, name: AppRoutes.miningview,args: mining);

                              },
                              child: _buildSubscriptionCard(minings[index].subscription!)
                              );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSubscriptionCard(SubscriptionDto subscription) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Package Name and Price
              Text(
                subscription.subPackageName ?? 'Unknown Package',
                style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              8.sp.verticalSpace,
              if (subscription.subPrice != null)
                Text(
                  '\$${subscription.subPrice!.toStringAsFixed(0)}',
                  style: TextStyle(color: const Color(0xFF792A90), fontSize: 20.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                ),
              12.sp.verticalSpace,
              // Subscription Type
              if (subscription.subType != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
                  decoration: BoxDecoration(color: const Color(0xFF792A90).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    subscription.subType!.toUpperCase(),
                    style: TextStyle(color: const Color(0xFF792A90), fontSize: 10.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                  ),
                ),
              12.sp.verticalSpace,
              // Duration
              if (subscription.subDuration != null)
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14.sp, color: const Color(0xFF757575)),
                    4.sp.horizontalSpace,
                    Expanded(
                      child: Text(
                        MyDateUtils.dateToSingleFormat(DateTime.fromMillisecondsSinceEpoch(int.parse(subscription.subDuration!))),
                        style: TextStyle(color: const Color(0xFF757575), fontSize: 11.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              8.sp.verticalSpace,
              // Reward Asset
              if (subscription.subRewardAssetSymbol != null)
                Row(
                  children: [
                    Icon(Icons.monetization_on_outlined, size: 14.sp, color: const Color(0xFF757575)),
                    4.sp.horizontalSpace,
                    Expanded(
                      child: Text(
                        'Reward: ${subscription.subRewardAssetSymbol}',
                        style: TextStyle(color: const Color(0xFF757575), fontSize: 11.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          // Status indicator
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 6.sp),
            decoration: BoxDecoration(color: const Color(0xFF792A90).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6.sp,
                  height: 6.sp,
                  decoration: BoxDecoration(color: const Color(0xFF792A90), shape: BoxShape.circle),
                ),
                6.sp.horizontalSpace,
                Text(
                  'Active',
                  style: TextStyle(color: const Color(0xFF792A90), fontSize: 11.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
