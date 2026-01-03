import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/data/controllers/mining/mining_controller.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/views/staking/components/earning_item.dart';

class WithdrawalsView extends StatefulWidget {
  const WithdrawalsView({super.key});

  @override
  State<WithdrawalsView> createState() => _WithdrawalsViewState();
}

class _WithdrawalsViewState extends State<WithdrawalsView> {
  @override
  void initState() {
    super.initState();
    // Fetch withdrawals when the view is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MiningController>(context, listen: false).fetchWithdrawals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
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
                    'Withdrawals',
                    style: TextStyle(
                      color: const Color(0xFF2D2D2D),
                      fontSize: 22.sp,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Spacer(),
                  SizedBox(width: 60.sp),
                ],
              ),
            ),
            30.sp.verticalSpace,
            Expanded(
              child: Consumer<MiningController>(
                builder: (context, miningController, child) {
                  if (miningController.withdrawals.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 64.sp,
                            color: const Color(0xFF757575),
                          ),
                          20.sp.verticalSpace,
                          Text(
                            'No Withdrawals',
                            style: TextStyle(
                              color: const Color(0xFF2D2D2D),
                              fontSize: 18.sp,
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          8.sp.verticalSpace,
                          Text(
                            'You haven\'t made any withdrawals yet',
                            style: TextStyle(
                              color: const Color(0xFF757575),
                              fontSize: 14.sp,
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      await miningController.fetchWithdrawals();
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'All Withdrawals',
                            style: TextStyle(
                              color: const Color(0xFF2D2D2D),
                              fontSize: 18.sp,
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          15.sp.verticalSpace,
                          ...miningController.withdrawals
                              .map(
                                (withdrawal) =>
                                    EarningItem(withdrawal: withdrawal),
                              )
                              .toList(),
                          40.sp.verticalSpace,
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
