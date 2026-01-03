import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/data/controllers/wallet_controller.dart';
import 'package:quanthex/data/Models/wallets/wallet_model.dart';
import 'package:quanthex/routes/app_routes.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/data/utils/security_utils.dart';
import 'package:quanthex/widgets/snackbar/my_snackbar.dart';

class WalletsView extends StatefulWidget {
  const WalletsView({super.key});

  @override
  State<WalletsView> createState() => _WalletsViewState();
}

class _WalletsViewState extends State<WalletsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WalletController>(context, listen: false).loadWallets();
    });
  }

  List<Color> _generateGradientFromAddress(String address) {
    // Generate consistent gradient colors from wallet address
    final colors = [
      [Colors.blue, Colors.purple],
      [Colors.purple, Colors.pink],
      [Colors.red, Colors.orange],
      [Colors.orange, Colors.yellow],
      [Colors.green, Colors.teal],
      [Colors.teal, Colors.blue],
      [Colors.pink, Colors.red],
      [Colors.yellow, Colors.green],
    ];

    // Use address hash to pick a color
    int hash = address.hashCode;
    int index = hash.abs() % colors.length;
    return colors[index];
  }

  String _getWalletDisplayName(WalletModel wallet) {
    return wallet.name ?? 'Wallet ${wallet.walletAddress?.substring(0, 6) ?? 'Unknown'}';
  }

  String _getShortAddress(WalletModel wallet) {
    if (wallet.walletAddress == null || wallet.walletAddress!.isEmpty) {
      return 'Unknown';
    }
    String address = wallet.walletAddress!;
    if (address.length > 10) {
      return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
    }
    return address;
  }

  void _showWalletMenu(WalletModel wallet) {
    final walletController = Provider.of<WalletController>(context, listen: false);
    final isLastWallet = walletController.wallets.length == 1;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => WalletMenuModal(
        wallet: wallet,
        onShowSecretPhrase: () async {
          Navigator.pop(modalContext);
          // Wait for modal to fully close
          await Future.delayed(Duration(milliseconds: 100));
          // Verify PIN before showing secret phrase
          if (!mounted) return;
          bool pinResult = await SecurityUtils.showPinDialog(context: context);
          if (pinResult && mounted) {
            Navigate.toNamed(context, name: AppRoutes.backupseedphraseview, args: wallet);
          } else if (mounted) {
            showMySnackBar(context: context, message: 'Incorrect PIN', type: SnackBarType.error);
          }
        },
        onDeleteWallet: () async {
          Navigator.pop(modalContext);
          // Wait for modal to fully close
          await Future.delayed(Duration(milliseconds: 100));
          if (!mounted) return;

          // Prevent deleting the last wallet
          if (isLastWallet) {
            showMySnackBar(context: context, message: 'Cannot delete your last wallet', type: SnackBarType.error);
            return;
          }

          // Show confirmation dialog
          bool? confirmDelete = await showDialog<bool>(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: Text(
                'Delete Wallet',
                style: TextStyle(fontFamily: 'Satoshi', fontWeight: FontWeight.w700, fontSize: 18.sp),
              ),
              content: Text(
                'Are you sure you want to delete this wallet? This action cannot be undone. Make sure you have backed up your secret phrase.',
                style: TextStyle(fontFamily: 'Satoshi', fontSize: 14.sp),
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontFamily: 'Satoshi', color: const Color(0xFF757575)),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, true),
                  child: Text(
                    'Delete',
                    style: TextStyle(fontFamily: 'Satoshi', color: Colors.red, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          );

          if (confirmDelete == true && mounted) {
            // Verify PIN before deletion
            bool pinResult = await SecurityUtils.showPinDialog(context: context);
            if (pinResult && mounted) {
              try {
                await walletController.deleteWallet(wallet);
                if (mounted) {
                  showMySnackBar(context: context, message: 'Wallet deleted successfully', type: SnackBarType.success);
                }
              } catch (e) {
                if (mounted) {
                  showMySnackBar(context: context, message: 'Failed to delete wallet', type: SnackBarType.error);
                }
              }
            } else if (mounted) {
              showMySnackBar(context: context, message: 'Incorrect PIN', type: SnackBarType.error);
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigate.back(context);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back, size: 20.sp),
                        5.horizontalSpace,
                        Text(
                          'Back',
                          style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Wallets',
                    style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 18.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
                  ),
                  Spacer(),
                  SizedBox(width: 60.sp),
                ],
              ),
            ),
            20.sp.verticalSpace,
            Expanded(
              child: Consumer<WalletController>(
                builder: (context, walletController, child) {
                  if (walletController.wallets.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.account_balance_wallet_outlined, size: 64.sp, color: const Color(0xFF757575)),
                          20.sp.verticalSpace,
                          Text(
                            'No Wallets',
                            style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 18.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                          ),
                          8.sp.verticalSpace,
                          Text(
                            'Create or import a wallet to get started',
                            style: TextStyle(color: const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    itemCount: walletController.wallets.length,
                    itemBuilder: (context, index) {
                      final wallet = walletController.wallets[index];
                      final isSelected = walletController.currentWallet?.walletAddress == wallet.walletAddress;
                      return _buildWalletItem(wallet, isSelected);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletItem(WalletModel wallet, bool isSelected) {
    final gradient = _generateGradientFromAddress(wallet.walletAddress ?? '');

    return Container(
      padding: EdgeInsets.only(left: 16.sp, right: 16.sp, top: 12.sp, bottom: 12.sp),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Row(
            children: [
              // Wallet Icon
              Container(
                width: 48.sp,
                height: 48.sp,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
                  shape: BoxShape.circle,
                ),
              ),
              15.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getWalletDisplayName(wallet),
                      style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                    ),
                    4.sp.verticalSpace,
                    Text(
                      _getShortAddress(wallet),
                      style: TextStyle(color: const Color(0xFF757575), fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Container(
                  width: 24.sp,
                  height: 24.sp,
                  margin: EdgeInsets.only(right: 10.sp),
                  child: Icon(Icons.check_circle, size: 20.sp, color: Color(0xFF792A90)),
                ),
              GestureDetector(
                onTap: () => _showWalletMenu(wallet),
                child: Icon(Icons.more_vert, size: 24.sp, color: const Color(0xFF757575)),
              ),
            ],
          ),
          12.sp.verticalSpace,
          Container(height: 1, width: MediaQuery.sizeOf(context).width, color: Color(0xffEEEEEE)),
        ],
      ),
    );
  }
}

// Wallet Menu Modal
class WalletMenuModal extends StatelessWidget {
  final WalletModel wallet;
  final VoidCallback onShowSecretPhrase;
  final VoidCallback onDeleteWallet;

  const WalletMenuModal({super.key, required this.wallet, required this.onShowSecretPhrase, required this.onDeleteWallet});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.sp,
            height: 4.sp,
            margin: EdgeInsets.only(top: 10.sp, bottom: 20.sp),
            decoration: BoxDecoration(color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(2)),
          ),
          _buildMenuItem(icon: Icons.visibility, title: 'Show Secret Phrase', onTap: onShowSecretPhrase),
          12.sp.verticalSpace,
          Container(
            height: 1,
            margin: EdgeInsets.symmetric(horizontal: 20.sp),
            color: const Color(0xFFEEEEEE),
          ),
          12.sp.verticalSpace,
          _buildMenuItem(icon: Icons.delete_outline, title: 'Delete Wallet', onTap: onDeleteWallet, titleColor: Colors.red),
          20.sp.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildMenuItem({required IconData icon, required String title, required VoidCallback onTap, Color? titleColor}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 16.sp),
        child: Row(
          children: [
            Icon(icon, color: titleColor ?? const Color(0xFF2D2D2D), size: 24.sp),
            15.horizontalSpace,
            Expanded(
              child: Text(
                title,
                style: TextStyle(color: titleColor ?? const Color(0xFF2D2D2D), fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
