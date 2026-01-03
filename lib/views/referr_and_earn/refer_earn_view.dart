import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/data/Models/mining/mining_dto.dart';
import 'package:quanthex/data/Models/users/profile_dto.dart';
import 'package:quanthex/data/Models/users/referral_dto.dart';
import 'package:quanthex/data/controllers/mining/mining_controller.dart';
import 'package:quanthex/data/controllers/user/user_controller.dart';
import 'package:quanthex/data/utils/date_utils.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/views/referr_and_earn/components/referral_item.dart';
import 'package:quanthex/views/referr_and_earn/components/round_container_icon.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../data/utils/logger.dart';
import '../../widgets/global/error_modal.dart';

class ReferEarnView extends StatefulWidget {
  ReferEarnView({super.key});

  @override
  State<ReferEarnView> createState() => _ReferEarnViewState();
}

class _ReferEarnViewState extends State<ReferEarnView> {
  late UserController userController;
  ValueNotifier<bool> _loadingNotifier = ValueNotifier(true);
  ValueNotifier<bool> _errorNotifier = ValueNotifier(false);

  void fetchData() async {
    try {
      _loadingNotifier.value = true;
      _errorNotifier.value = false;
      await userController.getReferrals();
      _loadingNotifier.value = false;
      _errorNotifier.value = false;
    } catch (e) {
      logger("Error fetching referrals: $e", runtimeType.toString());
      _errorNotifier.value = true;
      _loadingNotifier.value = false;
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    userController = Provider.of<UserController>(context, listen: false);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      fetchData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Consumer<UserController>(
            builder: (context, userCtr, child) {
              ProfileDto? userProfile=userCtr.profile;
              List<ReferralDto> referrals = userCtr.referrals;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.sp.verticalSpace,
                  // Header
                  Row(
                    children: [
                      GestureDetector(
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
                              style: TextStyle(
                                color: const Color(0xFF2D2D2D),
                                fontSize: 16.sp,
                                fontFamily: 'Satoshi',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Text(
                        'Refer and Earn',
                        style: TextStyle(
                          color: const Color(0xFF2D2D2D),
                          fontSize: 18.sp,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Spacer(),
                      SizedBox(width: 60.sp),
                    ],
                  ),
                  20.sp.verticalSpace,
                  // Refer & Earn Header
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Refer & Earn',
                          style: TextStyle(
                            color: const Color(0xFF2D2D2D),
                            fontSize: 24.sp,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        width: 102.sp,
                        height: 102.sp,
                        decoration: BoxDecoration(
                          // color: const Color(0xFF792A90),
                          image: DecorationImage(
                            image: AssetImage('assets/images/refer_earn_image.png'),
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.campaign,
                          color: Colors.white,
                          size: 30.sp,
                        ),
                      ),
                    ],
                  ),
                  15.sp.verticalSpace,
                  Text(
                    'Share your HexaPower link and grow your mining and staking network. Every new member boosts your mining progress and helps you unlock higher rewards.',
                    style: TextStyle(
                      color: const Color(0xFF757575),
                      fontSize: 14.sp,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                  20.sp.verticalSpace,
                  // Referral Link
                  Container(
                    padding: EdgeInsets.all(16.sp),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF792A90), width: 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: userProfile!=null?Text(
                            userProfile.referralCode??"",
                            style: TextStyle(
                              color: const Color(0xFF2D2D2D),
                              fontSize: 14.sp,
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w500,
                            ),
                          ):const SizedBox(),
                        ),
                        10.horizontalSpace,
                        GestureDetector(
                          onTap: () {
                            if(userProfile!=null){
                              Clipboard.setData(ClipboardData(text: userProfile!.referralCode??""));
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(SnackBar(content: Text('Link copied')));
                            }
                          },
                          child: Icon(
                            Icons.copy,
                            size: 20.sp,
                            color: const Color(0xFF757575),
                          ),
                        ),
                        10.horizontalSpace,
                        Icon(
                          Icons.share,
                          size: 20.sp,
                          color: const Color(0xFF757575),
                        ),
                      ],
                    ),
                  ),
                  40.sp.verticalSpace,
                  // How It Works
                  Text(
                    'How It Works',
                    style: TextStyle(
                      color: const Color(0xFF2D2D2D),
                      fontSize: 20.sp,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  20.sp.verticalSpace,
                  RoundContainerIcon(
                    icon: Icons.share,
                    iconColor: Colors.cyan,
                    title: 'Share your referal code',
                    description:
                    'Invite your friend to join Quanthex by sharing your unique referral code',
                  ),
                  15.sp.verticalSpace,
                  RoundContainerIcon(
                    icon: Icons.person_add,
                    iconColor: Colors.orange,
                    title: 'Friends sign up',
                    description:
                    'Your friends use your referral link to download and sign up on the app.',
                  ),
                  15.sp.verticalSpace,
                  RoundContainerIcon(
                    icon: Icons.rocket_launch,
                    iconColor: Colors.blue,
                    title: 'Friends Join & Boost Your Earnings',
                    description:
                    'Your start earning from the mining and also gain more ROI from the staking when they also join.',
                  ),
                  20.sp.verticalSpace,
                  // Referral List
                  Text(
                    'Referral List',
                    style: TextStyle(
                      color: const Color(0xFF2D2D2D),
                      fontSize: 20.sp,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  10.sp.verticalSpace,
                  ValueListenableBuilder(
                    valueListenable: _loadingNotifier,
                    builder: (context,loading,child) {
                      return ValueListenableBuilder(
                          valueListenable: _errorNotifier,
                          builder: (context,isError,child) {
                            return Skeletonizer(
                              ignoreContainers: false,
                              enabled: loading,
                              effect: ShimmerEffect(
                                  duration: Duration(milliseconds: 1000),
                                  baseColor: Colors.grey.withOpacity(0.4),
                                  highlightColor: Colors.white54
                              ),
                              child: !isError?Column(
                                children: referrals.map((e) {
                                  ProfileDto profile = e.profile!;
                                  return ReferralItem(
                                    email: profile.email ?? "",
                                    status: 'Active',
                                    timeStamp: profile.profileCreatedAt ?? "",
                                  );
                                }).toList(),
                              ):ErrorModal(
                                callBack: () {
                                  _errorNotifier.value = false;
                                  _loadingNotifier.value = true;
                                  fetchData();
                                },
                              ),
                            );
                          }
                      );
                    },
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
