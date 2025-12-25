import 'package:flutter/material.dart';
import 'package:quanthex/data/Models/assets/supported_assets.dart';
import 'package:quanthex/views/select_asset/select_assets.dart';

class AssetUtils{

  static Future<SupportedCoin?> selectAssets({required BuildContext context})async{
    SupportedCoin? coin=await  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      builder: (context) => SelectAssets(),
    );
    return coin;
  }
}