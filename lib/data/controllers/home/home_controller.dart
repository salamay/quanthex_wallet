import 'package:flutter/cupertino.dart';
import 'package:quanthex/views/home/home_view.dart';
import 'package:quanthex/views/mining/subscription_package.dart';
import 'package:quanthex/views/settings_view.dart';
import 'package:quanthex/views/staking_view.dart';
import 'package:quanthex/views/swap_token_view.dart';

import '../../../views/mining/mining_view.dart';

class HomeController extends ChangeNotifier{

  int index=0;


  List<Widget> dashboards=[
    HomeView(),
    SwapTokenView(),
    SubscriptionPackage(),
    StakingView(),
    SettingsView(),
  ];

  void changeIndex(int index){
    this.index=index;
    notifyListeners();
  }
}