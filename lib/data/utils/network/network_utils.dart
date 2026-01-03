import 'package:quanthex/data/Models/assets/network_model.dart';
import 'package:quanthex/data/Models/assets/supported_assets.dart';
import 'package:quanthex/data/Models/balance/platform_data.dart';
import 'package:quanthex/data/utils/logger.dart';

class NetworkUtils{

  static List<String > filterNetworksFromAssets({required List<SupportedCoin> assets}){
    Map<String,String> networks={};
    for(var asset in assets){
      NetworkModel? network=asset.networkModel;
      if(network!=null){
        networks[network.chainId.toString()]=network.chainName;
      }
    }
    return networks.keys.toList();
  }

  static Map<String,String> mapSymbolToPlatformId({required List<SupportedCoin> assets,required Map<String,PlatformData>? existingPlatform}){
    Map<String,int> chainSymbols={};
    for(var asset in assets){
      NetworkModel? network=asset.networkModel;
      if(network!=null){
        chainSymbols[network.chainSymbol]=network.chainId;
      }
    }
    Map<String,String> newData={};
    chainSymbols.forEach((key, value) {
      //Since value is the chainId
      //id is the platform id
      //key is the chain symbol
      String id=existingPlatform?[value.toString()]?.nativeCoinId??"";
      if(id.isNotEmpty){
        //symbol:platformId
        newData[key]=id;
      }
    });
    logger(newData.toString(), "NetworkUtils");
    return newData;
  }
}