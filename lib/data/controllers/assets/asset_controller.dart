import 'package:flutter/cupertino.dart';
import 'package:quanthex/core/constants/network_constants.dart';
import 'package:quanthex/data/Models/assets/scan_token.dart';
import 'package:quanthex/data/Models/assets/supported_assets.dart';
import 'package:coingecko_api/data/coin.dart' as coingecko_coin;
import 'package:quanthex/data/Models/transactions/erc20_transfer_dto.dart';
import 'package:quanthex/data/Models/transactions/native_tx_dto.dart';
import 'package:quanthex/data/controllers/swap/swap_controller.dart';
import 'package:quanthex/data/controllers/wallet_controller.dart';
import 'package:quanthex/data/repository/assets/asset_repository.dart';
import 'package:quanthex/data/services/assets/asset_service.dart';
import 'package:quanthex/data/utils/logger.dart';

import '../../../core/network/my_api.dart';
import '../../Models/assets/network_model.dart';
import '../balance/balance_controller.dart';

class AssetController extends ChangeNotifier {
  final my_api = MyApi();
  AssetService assetService = AssetService.getInstance();
  List<SupportedCoin> assets = [];
  Map<String, ScannedToken> scannedTokens = {};
  Map<String, coingecko_coin.Coin> tokenMetadatas = {};
  Map<String, List<Erc20TransferDto>> erc20Transfers = {};
  Map<String, List<NativeTxDto>> nativeTransfers = {};

  Future<void> getAssetsQuotes({required BalanceController balanceController, required List<SupportedCoin> assets}) async {
    await assetService.getQuotes(balanceController: balanceController, assets: assets);
  }

  Future<List<SupportedCoin>> getAllAssets({required bool isNew, required AssetService assetService, required WalletController walletController, required SwapController swapController}) async {
    logger("Getting default assets", runtimeType.toString());
    try {
      String walletAddress = walletController.currentWallet?.walletAddress ?? "";
      String privateKey = walletController.currentWallet?.privateKey ?? "";
      List<SupportedCoin> coins = [];
      if (isNew) {
        await Future.wait(
          defaultTokens.keys.map((key) async {
            NetworkModel network;
            logger("Default tokens for chainId $key", runtimeType.toString());
            int chainId = key;
            if (chainId == chain_id_eth) {
              List<String> addresses = defaultTokens[chainId]!;
              network = chain_eth;
              List<SupportedCoin> scT = await swapController.getTokens(network: network, address: walletAddress, privateKey: privateKey);
              logger("Eth  tokens: ${scT.length}", runtimeType.toString());
              coins.addAll(scT);
            } else if (chainId == chain_id_bsc) {
              List<String> addresses = defaultTokens[chainId]!;
              network = chain_bsc;
              List<SupportedCoin> scT = await swapController.getTokens(network: network, address: walletAddress, privateKey: privateKey);
              logger("Bsc  tokens: ${scT.length}", runtimeType.toString());
              coins.addAll(scT);
            } else if (chainId == chain_id_pol) {
              // List<String> addresses = defaultTokens[chainId]!;
              network = chain_polygon;
              List<SupportedCoin> scT = await swapController.getTokens(network: network, address: walletAddress, privateKey: privateKey);
              logger("Polygon  tokens: ${scT.length}", runtimeType.toString());
              coins.addAll(scT);
            } else {
              network = chain_eth;
              logger("Chain not supported", runtimeType.toString());
            }
            print(network.chainSymbol);
            SupportedCoin nativeToken = SupportedCoin(name: network.chainName, symbol: network.chainCurrency.toUpperCase(), image: network.imageUrl, walletAddress: walletAddress, privateKey: privateKey, networkModel: network, coinType: CoinType.NATIVE_TOKEN, decimal: 18, contractAddress: "");
            coins.insert(0, nativeToken);
          }).toList(),
        );

      } else {
        List<SupportedCoin> cachedAssets = await AssetRepo.getInstance().getScannedAssets();
        coins.addAll(cachedAssets);
      }
      assets = coins;
      // assets = await assetService.getAllAssets(isNew: isNew, walletAddress: walletAddress, privateKey: privateKey);
      notifyListeners();
      return assets;
    } catch (e) {
      logger("Error getting all assets: " + e.toString(), runtimeType.toString());
      throw Exception(e);
    }
  }

  Future<List<ScannedToken>> getScannedTokens({required String tokenAddress, required String chainSymbol}) async {
    List<ScannedToken> scannedTokens = await assetService.getTokenInfo(addresses: [tokenAddress], chainSymbol: chainSymbol);
    if (scannedTokens.isNotEmpty) {
      this.scannedTokens[tokenAddress.toLowerCase()] = scannedTokens.first;
    }
    notifyListeners();
    return scannedTokens;
  }

  Future<coingecko_coin.Coin?> getTokenMetaDatabyId({required String id, required String symbol}) async {
    coingecko_coin.Coin? tokenData = await assetService.getTokenMetaDatabyId(id: id);
    if (tokenData != null) {
      tokenMetadatas[symbol.toLowerCase()] = tokenData;
    }
    notifyListeners();
    return tokenData;
  }

  Future<Map<String, dynamic>> getErc20Transfers({required String walletAddress, required String contractAddress, required String chainSymbol, required String cursor, required int limit}) async {
    Map<String, dynamic> result = await assetService.getErc20Transfers(address: walletAddress, contractAddresses: [contractAddress], chainSymbol: chainSymbol, cursor: cursor, limit: limit);
    erc20Transfers[contractAddress.toLowerCase()] = result["transfers"];
    notifyListeners();
    return result;
  }

  Future<Map<String, dynamic>> getNativeTransfers({required String walletAddress, required String chainSymbol, required String cursor, required int limit}) async {
    Map<String, dynamic> result = await assetService.getNativeTransfers(address: walletAddress, chainSymbol: chainSymbol, cursor: cursor, limit: limit);
    nativeTransfers[walletAddress.toLowerCase()] = result["transfers"];
    notifyListeners();
    return result;
  }
  Future<void> clear() async {
    logger("Clearing assets", runtimeType.toString());
    assets = [];
    scannedTokens = {};
    tokenMetadatas = {};
    erc20Transfers = {};
    nativeTransfers = {};
    
  }
}
