import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/data/Models/wallets/wallet_model.dart';
import 'package:quanthex/data/controllers/wallet_controller.dart';
import 'package:quanthex/data/repository/secure_storage.dart';
import 'package:quanthex/data/services/auth/auth_service.dart';
import 'package:quanthex/utils/navigator.dart';

import '../routes/app_routes.dart';

class HomeNavResolver{

  static Future<void> resolveHomeRoute(BuildContext context)async{
    String authToken=await SecureStorage.getInstance().getAuthToken();
    if(authToken.isNotEmpty){
      AuthService.getInstance().authToken=authToken;
      List<WalletModel> wallets=await SecureStorage.getInstance().getWallets();
      if(wallets.isNotEmpty){
        List<WalletModel> wallets=await SecureStorage.getInstance().getWallets();
        Provider.of<WalletController>(context,listen: false).setWallets(wallets);
        Provider.of<WalletController>(context,listen: false).setCurrentWallet(wallets.first);
        Navigate.go(context,name: AppRoutes.homepage);

      }else{
        Navigate.go(context,name: AppRoutes.setupwalletview);
      }
    }else{
      Navigate.go(context,name: AppRoutes.landingview);
    }

  }
}