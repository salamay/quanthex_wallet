import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/data/Models/assets/supported_assets.dart';
import 'package:quanthex/data/Models/subscription/subscription_dto.dart';
import 'package:quanthex/data/controllers/assets/asset_controller.dart';
import 'package:quanthex/data/controllers/user/user_controller.dart';
import 'package:quanthex/routes/app_routes.dart';
import 'package:quanthex/utils/logger.dart';
import 'package:quanthex/views/mining/components/how_it_works_item.dart';
import 'package:quanthex/views/mining/mining_view.dart';
import 'package:quanthex/widgets/snackbar/my_snackbar.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/constants/sub_constants.dart';
import '../../data/Models/mining/mining_dto.dart';
import '../../data/Models/mining/subscription_payload.dart';
import '../../data/controllers/mining/mining_controller.dart';
import '../../utils/navigator.dart';
import '../../widgets/app_button.dart';
import '../../widgets/global/error_modal.dart';
import 'earning_breakdown_modal.dart';
class SubscriptionPackage extends StatefulWidget {
  const SubscriptionPackage({super.key});

  @override
  State<SubscriptionPackage> createState() => _SubscriptionPackageState();
}

class _SubscriptionPackageState extends State<SubscriptionPackage> {

  late AssetController assetController;
  ValueNotifier<bool> _loadingNotifier = ValueNotifier(true);
  ValueNotifier<bool> _errorNotifier = ValueNotifier(false);
  late MiningController miningController;
  late UserController userController;
  int selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    assetController=Provider.of<AssetController>(context,listen: false);
    miningController=Provider.of<MiningController>(context,listen: false);
    userController=Provider.of<UserController>(context,listen: false);
    fetchData();
    super.initState();
  }

  void fetchData()async{
    try{
      _loadingNotifier.value=true;
      _errorNotifier.value=false;
      await userController.getReferrals();
      await miningController.fetchMinings();
      _loadingNotifier.value=false;
      _errorNotifier.value=false;
    }catch(e){
      logger("Error fetching data: $e", runtimeType.toString());
      _errorNotifier.value=true;
      _loadingNotifier.value=false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Consumer<MiningController>(
          builder: (context,miningCtr,_) {
            List<MiningDto> minings=miningCtr.minings;
          return  ValueListenableBuilder(
                valueListenable: _loadingNotifier,
                builder: (context,loading,child) {
              return ValueListenableBuilder(
                valueListenable: _errorNotifier,
                builder: (context,isError,child) {
                  return Skeletonizer(
                    ignoreContainers: false,
                    enabled: loading,
                    effect:  ShimmerEffect(
                        duration: Duration(milliseconds: 1000),
                        baseColor: Colors.grey.withOpacity(0.4),
                        highlightColor: Colors.white54
                    ),
                    child: RefreshIndicator(
                      onRefresh: ()async{
                        fetchData();
                      },
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: !isError?minings.isEmpty?Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            children: [
                              // Introduction Section
                              Text(
                                'Ignite Your Mining Power Let the Blockchain Work for You.',
                                style: TextStyle(
                                  color: const Color(0xFF2D2D2D),
                                  fontSize: 24.sp,
                                  fontFamily: 'Satoshi',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              15.sp.verticalSpace,
                              Text(
                                'Activate any mining package and begin generating rewards instantly. The higher your package and network growth, the more you earn.',
                                style: TextStyle(
                                  color: const Color(0xFF757575),
                                  fontSize: 14.sp,
                                  fontFamily: 'Satoshi',
                                  fontWeight: FontWeight.w400,
                                  height: 1.5,
                                ),
                              ),
                              30.sp.verticalSpace,
                              // How It Works
                              Text(
                                'How It Works',
                                style: TextStyle(
                                  color: const Color(0xFF2D2D2D),
                                  fontSize: 18.sp,
                                  fontFamily: 'Satoshi',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              15.sp.verticalSpace,
                              HowItWorksItem(
                                text: 'Choose a package',
                                onInfoTap: (){

                                },
                              ),
                              10.sp.verticalSpace,
                              HowItWorksItem(
                                text: 'Get your HexaPower referral link',
                                onInfoTap: (){

                                },
                              ),
                              10.sp.verticalSpace,
                              HowItWorksItem(
                                text: 'Share & grow your earnings',
                                onInfoTap: (){

                                },
                              ),
                              30.sp.verticalSpace,
                              // Available Packages
                              Text(
                                'Available Packages',
                                style: TextStyle(
                                  color: const Color(0xFF2D2D2D),
                                  fontSize: 18.sp,
                                  fontFamily: 'Satoshi',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              10.sp.verticalSpace,
                              Text(
                                'Pick a plan that matches your budget and unlock mining rewards.',
                                style: TextStyle(
                                  color: const Color(0xFF757575),
                                  fontSize: 14.sp,
                                  fontFamily: 'Satoshi',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              20.sp.verticalSpace,
                              GestureDetector(
                                onTap: (){
                                  selectedIndex=0;
                                  setState(() {});
                                },
                                child: _buildPackageCard(
                                  price: 50,
                                  name: 'Starter Package',
                                  description:
                                  'Offering up to 5,000 DOGE or 257,000 STB in rewards. Advance through the required stages to unlock the full payout.',
                                  isSelected: selectedIndex==0?true:false,
                                ),
                              ),
                              15.sp.verticalSpace,
                              GestureDetector(
                                onTap: (){
                                  selectedIndex=1;
                                  setState(() {});
                                },
                                child: _buildPackageCard(
                                  price: 200,
                                  name: 'Growth Package',
                                  description: 'Offering up to 28,600 DOGE or 1,315,000 STB in rewards. Move through all stages to claim the maximum benefit.',
                                  isSelected: selectedIndex==1?true:false,

                                ),
                              ),
                              15.sp.verticalSpace,
                              GestureDetector(
                                onTap: (){
                                  selectedIndex=2;
                                  setState(() {});
                                },
                                child: _buildPackageCard(
                                  price: 500,
                                  name: 'Advanced Package',
                                  description:
                                  'Offering up to 50,000 DOGE or 2,300,000 STB in rewards. Progress through the necessary stages to access the full reward.',
                                  isSelected: selectedIndex==2?true:false,
                                ),
                              ),
                              15.sp.verticalSpace,
                              GestureDetector(
                                onTap: (){
                                  selectedIndex=3;
                                  setState(() {});
                                },
                                child: _buildPackageCard(
                                  price: 1000,
                                  name: 'Pro Package',
                                  description:
                                  'Offering up to 79,000 DOGE or 3,660,000 STB in rewards. Complete all progression levels to receive the entire reward.',
                                  isSelected: selectedIndex==3?true:false,
                                ),
                              ),

                              40.sp.verticalSpace,
                            ],
                          ),
                        ):MiningView():ErrorModal(
                          callBack: (){
                            _errorNotifier.value=false;
                            _loadingNotifier.value=true;
                            fetchData();
                          },
                        ),
                      ),
                    ),
                  );
                }
              );
            }
          );
        }
      ),
    );
  }

  Widget _buildPackageCard({
    required int price,
    required String name,
    required String description,
    bool isSelected = false,
  }) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFAE9FF) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected
              ? const Color(0xFF792A90)
              : const Color(0xFFE0E0E0),
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
              onTap: () {
                double subPrice=price.toDouble();
                SubscriptionPayload subscriptionDto = SubscriptionPayload(
                  subPackageName: starter,
                  subType: mining,
                  subPrice: subPrice
                );
                List<SupportedCoin> supportedCoins = assetController.assets.where((e)=>e.symbol.toLowerCase()=="usdc"&&e.networkModel!.chainId==137).toList();
                if(supportedCoins.isEmpty){
                  showMySnackBar(context: context, message: "You don't have USDT for payment, Please not that USDT is required for payment", type: SnackBarType.error);
                  return;
                }
                var data={
                  "data":subscriptionDto,
                  "payment_token":supportedCoins.first
                };
                Navigate.toNamed(context, name: AppRoutes.subscribeview,args: data);
              },
            ),
          ],
        ],
      ),
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
