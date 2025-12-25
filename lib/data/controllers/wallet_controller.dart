import 'package:flutter/cupertino.dart';
import 'package:quanthex/data/Models/wallets/wallet_model.dart';

class WalletController extends ChangeNotifier{
  List<WalletModel> wallets=[];
  WalletModel? currentWallet;

  void setWallets(List<WalletModel> walletList){
    wallets=walletList;
    notifyListeners();
  }
  void setCurrentWallet(WalletModel wallet){
    currentWallet=wallet;
    notifyListeners();
  }
}