
import 'package:dio/dio.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quanthex/data/Models/assets/supported_assets.dart' show SupportedCoin;
import 'package:quanthex/data/Models/send/send_payload.dart';
import 'package:quanthex/data/controllers/balance/balance_controller.dart';
import 'package:quanthex/data/repository/secure_storage.dart';
import 'package:quanthex/utils/assets/token_factory.dart';
import 'package:quanthex/utils/logger.dart';
import 'package:wallet/wallet.dart';
import 'package:web3dart/web3dart.dart';
import 'dart:math' as math;

import '../../../core/constants/crypto_constants.dart';
import '../../../core/constants/network_constants.dart';
import '../../../core/network/Api_url.dart';
import '../../../core/network/my_api.dart';
import '../../../utils/network/chain_parse.dart';
import '../../../utils/network/network_utils.dart';
import '../../Models/assets/custom_token.dart';
import '../../Models/assets/network_model.dart';
import '../../Models/assets/scan_token.dart';
import '../../Models/balance/platform_data.dart';
import '../../Models/network/network_model.dart';
import '../../repository/assets/asset_repository.dart';


class AssetService{
  final my_api = MyApi();

  Map<int,List<String>> defaultTokens = {
    1:[
      eth_usdc_contract,
      eth_usdt_contract
    ],
    56: [
      bsc_usdc_contract,
      bsc_usdt_contract
    ],
    137: [
      polygon_usdt_contract,
      polygon_usdc_contract,
      polygon_orio_contract,
      polygon_fib_contract,
    ],
  };
  static AssetService? _instance;
  AssetService._internal();

  static AssetService getInstance() {
    if(_instance==null){
      logger("Creating AssetService instance","AssetService");
    }
    _instance ??= AssetService._internal();
    return _instance!;
  }


  Future<List<ScannedToken>> getTokenInfo({required NetworkModel network,required List<String> addresses,required String chainSymbol}) async {
    try{
      logger("Scanning token on $chainSymbol",runtimeType.toString());
      Uri uri=Uri.parse(ApiUrls.moralisTokenMetadata);
      Uri finalUri=uri.replace(
          queryParameters: {
            "chain":ChainParse.getMoralisChainName(chainSymbol),
            "addresses":addresses,
          });
      Response? response = await my_api.get(finalUri.toString(), {"Content-Type": "application/json","X-API-Key":MyApi.moralisKey});
      logger("Scanning token: Response code ${response!.statusCode}",runtimeType.toString());
      if (response.statusCode == 200) {
        List<ScannedToken> scannedTokens=List.from(response.data).map((e) => ScannedToken.fromJson(e)).toList();
        print(response.data);
        logger("Scanned token: ${scannedTokens.length}",runtimeType.toString());
        return scannedTokens;
      } else {
        return [];
      }
    }catch(e){
      logger(e.toString(),runtimeType.toString());
      return [];
    }
  }


  SupportedCoin getNativeCoin({required NetworkModel network,required String walletAddress,required String privateKey}){
    try{
      logger("Getting native coin: ${network.chainId}",runtimeType.toString());
      SupportedCoin nativeToken=SupportedCoin(
        name: network.chainName,
        symbol: network.chainCurrency.toUpperCase(),
        image: network.imageUrl,
        walletAddress: walletAddress,
        privateKey: privateKey,
        networkModel: network,
        coinType: CoinType.NATIVE_TOKEN,
        decimal: 18,
        contractAddress: "",
      );
      return nativeToken;
    }catch(e){
      logger("Error getting native token: $e",runtimeType.toString());
      throw Exception("Error getting native token: $e");
    }
  }

  //Get custom tokens that the user has added
  Future<List<SupportedCoin>> getCustomTokens({required NetworkModel selectedChain,required String walletAddress,required String privateKey})async{
    List<CustomToken> customs=await SecureStorage.getInstance().getCustomTokens(chain: selectedChain.chainSymbol);
    logger("Custom Token: ${customs.length}",runtimeType.toString());
    List<SupportedCoin> customTokens=customs.map((e) {
      return SupportedCoin(
          name: e.name!,
          symbol: e.symbol!.toUpperCase(),
          image: e.image??selectedChain.imageUrl,
          walletAddress: walletAddress,
          privateKey: privateKey,
          networkModel: selectedChain,
          coinType: CoinType.TOKEN,
          decimal: e.decimal,
          contractAddress: e.contractAddress!.toLowerCase()
      );
    }).toList();
    return customTokens;
  }


  Future<void> getQuotes({required BalanceController balanceController,required List<SupportedCoin> assets})async{
    Map<String,PlatformData>? existingPlatform=balanceController.platforms;
    if(existingPlatform.isEmpty){
      existingPlatform= await balanceController.getAssetsPlatform();
    }
    if(existingPlatform!=null){
        //This is used to get the quotes for tokens
        List<SupportedCoin> tokens=assets.where((e)=>e.coinType==CoinType.TOKEN||e.coinType==CoinType.WRAPPED_TOKEN).toList();
        await balanceController.getTokenQuotes(tokens: tokens);
        List<SupportedCoin> nativeAssets=assets.where((e)=>e.coinType==CoinType.NATIVE_TOKEN).toList();
        //This is used to get the quotes for native assets
        Map<String,String> mappedData=NetworkUtils.mapSymbolToPlatformId(assets: assets, existingPlatform: existingPlatform);
        var data=await balanceController.getQuotesByIds(payload: mappedData);

    }
  }

  Future<List<SupportedCoin>> scanTokens({required NetworkModel network,required List<String> addresses,required String chainSymbol,required String walletAddress,required String privateKey}) async {
    try{
      logger("Scanning token on $chainSymbol",runtimeType.toString());
      if(addresses.isEmpty){
        logger("No addresses to scan",runtimeType.toString());
        return [];
      }
      Uri uri=Uri.parse(ApiUrls.moralisTokenMetadata);
      Uri finalUri=uri.replace(
          queryParameters: {
            "chain":ChainParse.getMoralisChainName(chainSymbol),
            "addresses":addresses,
          });
      Response? response = await my_api.get(finalUri.toString(), {"Content-Type": "application/json","X-API-Key":MyApi.moralisKey});
      logger("Scanning token: Response code ${response!.statusCode}",runtimeType.toString());
      if (response.statusCode == 200) {
        List<ScannedToken> scannedTokens=List.from(response.data).map((e) => ScannedToken.fromJson(e)).toList();
        logger("Scanned token: ${scannedTokens.length}",runtimeType.toString());
        final filteredTokens = scannedTokens.where((token) => token.logo != null).toList();
        List<SupportedCoin> assets=filteredTokens.map((e){
          return SupportedCoin(
            name: e.name!,
            symbol: e.symbol!.toUpperCase(),
            image: e.logo??network.imageUrl,
            walletAddress: walletAddress,
            privateKey: privateKey,
            networkModel: network,
            coinType: CoinType.TOKEN,
            decimal: int.parse(e.decimals!),
            contractAddress: e.address!.toLowerCase(),
          );
        }).toList();
        return assets;
      } else {
        logger(response.data.toString(),runtimeType.toString());
        return [];
      }
    }catch(e){
      logger(e.toString(),runtimeType.toString());
      throw Exception("Error scanning tokens: $e");
    }
  }

  Future<List<SupportedCoin>> getAllAssets({required bool isNew,required  String walletAddress, required String privateKey})async{
    logger("Getting default assets",runtimeType.toString());
    try{
      List<SupportedCoin> coins=[];

      if(isNew){
        await Future.wait(defaultTokens.keys.map((key)async {
          NetworkModel network;
          logger("Default tokens for chainId $key",runtimeType.toString());
          int chainId=key;
          if(chainId==chain_id_eth){
            List<String> addresses=defaultTokens[chainId]!;
            network=chain_eth;
            List<SupportedCoin> scT= await scanTokens(addresses: addresses, chainSymbol: network.chainSymbol.toUpperCase(),network: network, walletAddress: walletAddress, privateKey: privateKey);
            logger("Eth  tokens: ${scT.length}",runtimeType.toString());
            coins.addAll(scT);
          }else if(chainId==chain_id_bsc){
            List<String> addresses=defaultTokens[chainId]!;
            network=chain_bsc;
            List<SupportedCoin> scT= await scanTokens(addresses: addresses, chainSymbol: network.chainSymbol.toUpperCase(), network: network, walletAddress: walletAddress, privateKey: privateKey);
            logger("Bsc  tokens: ${scT.length}",runtimeType.toString());
            coins.addAll(scT);
          }else if(chainId==chain_id_pol){
            List<String> addresses=defaultTokens[chainId]!;
            network=chain_polygon;
            List<SupportedCoin> scT= await scanTokens(addresses: addresses, chainSymbol: network.chainSymbol.toUpperCase(), network: network,walletAddress: walletAddress, privateKey: privateKey);
            logger("Polygon  tokens: ${scT.length}",runtimeType.toString());
            coins.addAll(scT);
          }else if(chainId==chain_id_arb){
            List<String> addresses=defaultTokens[chainId]!;
            network=chain_arbitrum;
            List<SupportedCoin> scT= await scanTokens(addresses: addresses, chainSymbol: network.chainSymbol.toUpperCase(), network: network,walletAddress: walletAddress, privateKey: privateKey);
            logger("Arbitrum  tokens: ${scT.length}",runtimeType.toString());
            coins.addAll(scT);
          }else if(chainId==chain_id_avax){
            List<String> addresses=defaultTokens[chainId]!;
            network=chain_avalanche;
            List<SupportedCoin> scT= await scanTokens(addresses: addresses, chainSymbol: network.chainSymbol.toUpperCase(), network: network,walletAddress: walletAddress, privateKey: privateKey);
            logger("Arbitrum  tokens: ${scT.length}",runtimeType.toString());
            coins.addAll(scT);
          }else{
            network=chain_eth;
            logger("Chain not supported",runtimeType.toString());
          }
          if(isNew){
            print(network.chainSymbol);
            SupportedCoin nativeToken=SupportedCoin(name: network.chainName, symbol: network.chainCurrency.toUpperCase(), image: network.imageUrl, walletAddress: walletAddress, privateKey: privateKey, networkModel: network, coinType: CoinType.NATIVE_TOKEN, decimal: 18, contractAddress: "",);
            coins.insert(0, nativeToken);
          }
          List<SupportedCoin> tokens=await getCustomTokens(selectedChain: network, walletAddress: walletAddress, privateKey: privateKey);
          tokens.map((e){
            //Check if the token is already in the supported coin list,i.e the token is not a duplicate
            if(coins.where((element) => element.contractAddress!.toLowerCase()==e.contractAddress!.toLowerCase()).isEmpty){
              coins.add(e);
            }
          }).toList();
        }));
      }else{
        await Future.wait(defaultTokens.keys.map((key)async {
          logger("Default tokens for chainId $key",runtimeType.toString());
          NetworkModel network;
          int chainId=key;
          if(chainId==chain_id_eth) {
            network = chain_eth;
            List<SupportedCoin> scT=await AssetRepo.getScannedAssets();
            logger("Cached token ($eth): ${scT.length}",runtimeType.toString());
            coins.addAll(scT);
          } else if(chainId==chain_id_bsc){
            network=chain_bsc;
            List<SupportedCoin> scT=await AssetRepo.getScannedAssets();
            logger("Cached token ($bsc): ${scT.length}",runtimeType.toString());
            coins.addAll(scT);
          }else if(chainId==chain_id_pol){
            network=chain_polygon;
            List<SupportedCoin> scT=await AssetRepo.getScannedAssets();
            logger("Cached token ($polygon): ${scT.length}",runtimeType.toString());
            coins.addAll(scT);
          }else if(chainId==chain_id_arb){
            network=chain_arbitrum;
            List<SupportedCoin> scT=await AssetRepo.getScannedAssets();
            logger("Cached token ($arb): ${scT.length}",runtimeType.toString());
            coins.addAll(scT);
          }else if(chainId==chain_id_avax){
            network=chain_avalanche;
            List<SupportedCoin> scT=await AssetRepo.getScannedAssets();
            logger("Cached token ($avax): ${scT.length}",runtimeType.toString());
            coins.addAll(scT);
          }else{
            network=chain_eth;
            logger("Chain not supported",runtimeType.toString());
          }
          List<SupportedCoin> tokens=await getCustomTokens(selectedChain: network, walletAddress: walletAddress, privateKey: privateKey);
          tokens.map((e){
            //Check if the token is already in the supported coin list,i.e the token is not a duplicate
            if(coins.where((element) => element.contractAddress!.toLowerCase()==e.contractAddress!.toLowerCase()).isEmpty){
              coins.add(e);
            }
          }).toList();
        }));
      }

      return coins;
    }catch(e){
      logger(e.toString(),runtimeType.toString());
      return [];
    }
  }




}