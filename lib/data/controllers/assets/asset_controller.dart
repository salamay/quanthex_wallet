import 'package:flutter/cupertino.dart';
import 'package:quanthex/data/Models/assets/supported_assets.dart';
import 'package:quanthex/data/controllers/wallet_controller.dart';
import 'package:quanthex/data/services/assets/asset_service.dart';
import 'package:quanthex/utils/logger.dart';

import '../../../core/network/my_api.dart';
import '../../Models/assets/network_model.dart';
import '../balance/balance_controller.dart';

class AssetController extends ChangeNotifier{

  final my_api = MyApi();
  AssetService assetService=AssetService.getInstance();
  List<SupportedCoin> assets=[];

  Future<void> getAssetsQuotes({required BalanceController balanceController,required List<SupportedCoin> assets})async{
    await assetService.getQuotes(balanceController: balanceController, assets: assets);
  }

  Future<List<SupportedCoin>> getAllAssets({required bool isNew,required AssetService assetService,required WalletController walletController})async{
    logger("Getting default assets",runtimeType.toString());
    try{
      String walletAddress=walletController.currentWallet?.walletAddress??"";
      String privateKey=walletController.currentWallet?.privateKey??"";
      assets=await assetService.getAllAssets(isNew: isNew,  walletAddress: walletAddress,privateKey: privateKey);
      notifyListeners();
      return assets;
    }catch(e){
      logger(e.toString(),runtimeType.toString());
      return [];
    }
  }

}