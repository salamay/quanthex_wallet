import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/data/Models/staking/staking_dto.dart';
import 'package:quanthex/data/Models/staking/withdrawal.dart';
import 'package:quanthex/data/controllers/mining/mining_controller.dart';
import 'package:quanthex/data/controllers/wallet_controller.dart';
import 'package:quanthex/data/utils/logger.dart';
import 'package:quanthex/views/staking/components/earning_item.dart';
import 'package:quanthex/widgets/arrow_back.dart';
import 'package:quanthex/widgets/global/empty_view.dart';

class StakingEarningPage extends StatefulWidget {
  StakingEarningPage({super.key,required this.stakingId});
  String stakingId;
  @override
  State<StakingEarningPage> createState() => _StakingEarningPageState();
}

class _StakingEarningPageState extends State<StakingEarningPage> {
  late WalletController walletController;
  late MiningController miningController;

  @override
  void initState() {
    // TODO: implement initState
    walletController = Provider.of<WalletController>(context, listen: false);
    miningController = Provider.of<MiningController>(context, listen: false);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      fetchData();
    });
    super.initState();
  }

  void fetchData() async {
    try {
      String walletAddress = walletController.currentWallet!.walletAddress ?? "";
      await miningController.fetchWithdrawals(widget.stakingId);
    } catch (e) {
      logger("Error fetching data: $e", runtimeType.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: ArrowBack(iconColor: Colors.white),
        centerTitle: true,
        title: Text(
          'Yields',
          style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(8.sp),
        decoration: BoxDecoration(
          image: DecorationImage(colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken), image: AssetImage('assets/images/green_astro_bg.jpg'), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Consumer<MiningController>(
                  builder: (context, mCtr, child) {
                    List<WithdrawalDto> withdrawals = mCtr.withdrawals;
                    return Column(
                      children: withdrawals.isNotEmpty ? withdrawals.map((e) => EarningItem(withdrawal: e)).toList() : [EmptyView(message: 'No withdrawals yet')],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
