import 'package:flutter/cupertino.dart';
import 'package:quanthex/data/Models/wallets/wallet_model.dart';
import 'package:quanthex/data/repository/secure_storage.dart';
import 'package:quanthex/data/utils/logger.dart';

class WalletController extends ChangeNotifier {
  List<WalletModel> wallets = [];
  WalletModel? currentWallet;
  SecureStorage _storage = SecureStorage.getInstance();

  Future<void> loadWallets() async {
    logger("Loading wallets", runtimeType.toString());
    wallets = await _storage.getWallets();
    if (wallets.isNotEmpty) {
      String currentWalletAddress = await _storage.getCurrentWallet();
      if (currentWalletAddress.isNotEmpty) {
        currentWallet = wallets.firstWhere(
          (wallet) => wallet.walletAddress == currentWalletAddress,
          orElse: () => wallets.first,
        );
      } else {
        currentWallet = wallets.first;
        await _storage.saveCurrentWallet(currentWallet!.walletAddress!);
      }
    }
    notifyListeners();
  }

  void setWallets(List<WalletModel> walletList) {
    wallets = walletList;
    notifyListeners();
  }

  void setCurrentWallet(WalletModel wallet) {
    currentWallet = wallet;
    _storage.saveCurrentWallet(wallet.walletAddress!);
    notifyListeners();
  }

  Future<void> switchWallet(WalletModel wallet) async {
    logger("Switching wallet", runtimeType.toString());
    currentWallet = wallet;
    await _storage.saveCurrentWallet(wallet.walletAddress!);
    notifyListeners();
  }

  Future<void> deleteWallet(WalletModel wallet) async {
    logger("Deleting wallet", runtimeType.toString());
    await _storage.deleteWallet(wallet.walletAddress!);
    wallets.removeWhere(
      (w) =>
          w.walletAddress == wallet.walletAddress &&
          w.chainId == wallet.chainId,
    );

    // If deleted wallet was current, switch to first available
    if (currentWallet?.walletAddress == wallet.walletAddress) {
      if (wallets.isNotEmpty) {
        currentWallet = wallets.first;
        await _storage.saveCurrentWallet(currentWallet!.walletAddress!);
      } else {
        currentWallet = null;
      }
    }
    notifyListeners();
  }

  Future<void> renameWallet(WalletModel wallet, String newName) async {
    logger("Renaming wallet", runtimeType.toString());
    WalletModel updatedWallet = WalletModel(
      mnemonic: wallet.mnemonic,
      chainId: wallet.chainId,
      walletAddress: wallet.walletAddress,
      privateKey: wallet.privateKey,
      name: newName,
    );
    await _storage.updateWallet(updatedWallet);

    int index = wallets.indexWhere(
      (w) =>
          w.walletAddress == wallet.walletAddress &&
          w.chainId == wallet.chainId,
    );
    if (index != -1) {
      wallets[index] = updatedWallet;
    }

    if (currentWallet?.walletAddress == wallet.walletAddress) {
      currentWallet = updatedWallet;
    }
    notifyListeners();
  }

  Future<void> addWallet(WalletModel wallet) async {
    logger("Adding wallet", runtimeType.toString());
    await _storage.saveWallet([wallet]);
    wallets = await _storage.getWallets();
    notifyListeners();
  }
}
