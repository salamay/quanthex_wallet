import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/data/controllers/wallet_controller.dart';
import 'package:quanthex/data/repository/secure_storage.dart';
import 'package:quanthex/data/services/auth/auth_service.dart';
import 'package:quanthex/data/utils/navigator.dart';

import '../../routes/app_routes.dart';

class HomeNavResolver {
  static Future<void> resolveHomeRoute(BuildContext context) async {
    String authToken = await SecureStorage.getInstance().getAuthToken();
    if (authToken.isNotEmpty) {
      AuthService.getInstance().authToken = authToken;
      WalletController walletController = Provider.of<WalletController>(
        context,
        listen: false,
      );
      await walletController.loadWallets();
      if (walletController.wallets.isNotEmpty) {
        Navigate.go(context, name: AppRoutes.homepage);
      } else {
        Navigate.go(context, name: AppRoutes.setupwalletview);
      }
    } else {
      Navigate.go(context, name: AppRoutes.landingview);
    }
  }
}
