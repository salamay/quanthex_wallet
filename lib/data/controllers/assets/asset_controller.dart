import 'package:flutter/cupertino.dart';
import 'package:quanthex/data/Models/assets/scan_token.dart';
import 'package:quanthex/data/Models/assets/supported_assets.dart';
import 'package:coingecko_api/data/coin.dart' as coingecko_coin;
import 'package:quanthex/data/Models/transactions/erc20_transfer_dto.dart';
import 'package:quanthex/data/Models/transactions/native_tx_dto.dart';
import 'package:quanthex/data/controllers/wallet_controller.dart';
import 'package:quanthex/data/services/assets/asset_service.dart';
import 'package:quanthex/data/utils/logger.dart';

import '../../../core/network/my_api.dart';
import '../../Models/assets/network_model.dart';
import '../balance/balance_controller.dart';

class AssetController extends ChangeNotifier{

  final my_api = MyApi();
  AssetService assetService=AssetService.getInstance();
  List<SupportedCoin> assets=[];
  Map<String,ScannedToken> scannedTokens={};
  Map<String,coingecko_coin.Coin> tokenMetadatas={};
  Map<String,List<Erc20TransferDto>> erc20Transfers={};
  Map<String,List<NativeTxDto>> nativeTransfers={};

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

  Future<List<ScannedToken>> getScannedTokens({required String tokenAddress,required String chainSymbol})async{
    List<ScannedToken> scannedTokens=await assetService.getTokenInfo(addresses: [tokenAddress], chainSymbol: chainSymbol);
    if(scannedTokens.isNotEmpty){
      this.scannedTokens[tokenAddress.toLowerCase()] = scannedTokens.first;
    }
    notifyListeners();
    return scannedTokens;
  }
  Future<coingecko_coin.Coin?> getTokenMetaDatabyId({required String id,required String symbol}) async {
    coingecko_coin.Coin? tokenData=await assetService.getTokenMetaDatabyId(id: id);
    if(tokenData !=null){
      tokenMetadatas[symbol.toLowerCase()] = tokenData;
    }
    notifyListeners();
    return tokenData;
  }

    Future<Map<String,dynamic>> getErc20Transfers({required String walletAddress,required String contractAddress,required String chainSymbol,required String cursor,required int limit}) async {
        Map<String,dynamic> result=await assetService.getErc20Transfers(address: walletAddress, contractAddresses: [contractAddress], chainSymbol: chainSymbol, cursor: cursor, limit: limit);
        erc20Transfers[contractAddress.toLowerCase()] = result["transfers"];
      notifyListeners();
      return result;
    }
    Future<Map<String,dynamic>> getNativeTransfers({required String walletAddress,required String chainSymbol,required String cursor,required int limit}) async {
        Map<String,dynamic> result=await assetService.getNativeTransfers(address: walletAddress, chainSymbol: chainSymbol, cursor: cursor, limit: limit);
        nativeTransfers[walletAddress.toLowerCase()] = result["transfers"];
        notifyListeners();
        return result;
    }

}