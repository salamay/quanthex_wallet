import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/utils/navigator.dart';

class WalletsView extends StatefulWidget {
  const WalletsView({super.key});

  @override
  State<WalletsView> createState() => _WalletsViewState();
}

class _WalletsViewState extends State<WalletsView> {
  final List<Map<String, dynamic>> _wallets = [
    {
      'id': '1',
      'name': 'Combactful',
      'gradient': [Colors.yellow, Colors.orange, Colors.green],
      'isSelected': true,
    },
    {
      'id': '2',
      'name': 'Wallet 2',
      'gradient': [Colors.purple, Colors.pink],
      'isSelected': false,
    },
    {
      'id': '3',
      'name': 'Multi-Coin Wallet',
      'gradient': [Colors.red, Colors.pink],
      'isSelected': false,
    },
  ];

  void _showRenameModal(String walletId, String currentName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      builder: (context) => RenameWalletModal(
        currentName: currentName,
        onRename: (newName) {
          setState(() {
            final wallet = _wallets.firstWhere((w) => w['id'] == walletId);
            wallet['name'] = newName;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showWalletMenu(String walletId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => WalletMenuModal(
        onRename: () {
          Navigator.pop(context);
          final wallet = _wallets.firstWhere((w) => w['id'] == walletId);
          _showRenameModal(walletId, wallet['name']);
        },
        onShowSecretPhrase: () {
          Navigator.pop(context);
          // Navigate to secret phrase view
        },
        onDelete: () {
          Navigator.pop(context);
          // Show delete confirmation
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
                          style: TextStyle(
                            color: const Color(0xFF2D2D2D),
                            fontSize: 16.sp,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Wallets',
                    style: TextStyle(
                      color: const Color(0xFF2D2D2D),
                      fontSize: 18.sp,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.add, size: 24.sp),
                    onPressed: () {
                      // Add new wallet
                    },
                  ),
                ],
              ),
            ),
            20.sp.verticalSpace,
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20),
                itemCount: _wallets.length,
                itemBuilder: (context, index) {
                  final wallet = _wallets[index];
                  return _buildWalletItem(wallet);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletItem(Map<String, dynamic> wallet) {
    final gradient = wallet['gradient'] as List<Color>;
    final isSelected = wallet['isSelected'] as bool;

    return Container(
      margin: EdgeInsets.only(bottom: 12.sp),
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Wallet Icon
          Container(
            width: 48.sp,
            height: 48.sp,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
          ),
          15.horizontalSpace,
          Expanded(
            child: Text(
              wallet['name'],
              style: TextStyle(
                color: const Color(0xFF2D2D2D),
                fontSize: 16.sp,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (isSelected)
            Container(
              width: 24.sp,
              height: 24.sp,
              margin: EdgeInsets.only(right: 10.sp),
              decoration: BoxDecoration(
                // color: const Color(0xFF792A90),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline,
                size: 20.sp,
                color: Color(0xFF792A90),
              ),
            ),
          GestureDetector(
            onTap: () => _showWalletMenu(wallet['id']),
            child: Icon(
              Icons.more_vert_rounded,
              size: 24.sp,
              color: const Color(0xFF757575),
            ),
          ),
        ],
      ),
    );
  }
}

// Rename Wallet Modal
class RenameWalletModal extends StatefulWidget {
  final String currentName;
  final Function(String) onRename;

  const RenameWalletModal({
    super.key,
    required this.currentName,
    required this.onRename,
  });

  @override
  State<RenameWalletModal> createState() => _RenameWalletModalState();
}

class _RenameWalletModalState extends State<RenameWalletModal> {
  late TextEditingController _nameController;
  final int _maxLength = 15;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.sp,
              height: 4.sp,
              margin: EdgeInsets.only(bottom: 20.sp),
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Center(
            child: Text(
              'Rename Wallet?',
              style: TextStyle(
                color: const Color(0xFF2D2D2D),
                fontSize: 20.sp,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          20.sp.verticalSpace,
          Text(
            'New Wallet Name',
            style: TextStyle(
              color: const Color(0xFF757575),
              fontSize: 14.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
            ),
          ),
          10.sp.verticalSpace,
          TextField(
            controller: _nameController,
            maxLength: _maxLength,
            decoration: InputDecoration(
              hintText: 'Enter the new wallet name',
              hintStyle: TextStyle(
                color: const Color(0xFF9E9E9E),
                fontSize: 14.sp,
                fontFamily: 'Satoshi',
              ),
              counterText: '${_nameController.text.length}/$_maxLength',
              counter: SizedBox(),
              counterStyle: TextStyle(
                color: const Color(0xFF757575),
                fontSize: 12.sp,
              ),
              suffix: Text(
                '${_nameController.text.length}/$_maxLength',
                style: TextStyle(
                  color: const Color(0xFF757575),
                  fontSize: 12.sp,
                ),
              ),
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(65),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.all(16.sp),
            ),
            onChanged: (value) {
              setState(() {}); // Update counter
            },
          ),
          30.sp.verticalSpace,
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigate.back(context);
                  },
                  child: Container(
                    height: 50.sp,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9E6FF),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: const Color(0xFF792A90),
                          fontSize: 16.sp,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              15.horizontalSpace,
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (_nameController.text.isNotEmpty) {
                      widget.onRename(_nameController.text);
                    }
                  },
                  child: Container(
                    height: 50.sp,
                    decoration: BoxDecoration(
                      color: const Color(0xFF792A90),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Center(
                      child: Text(
                        'Yes, Rename',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          20.sp.verticalSpace,
        ],
      ),
    );
  }
}

// Wallet Menu Modal
class WalletMenuModal extends StatelessWidget {
  final VoidCallback onRename;
  final VoidCallback onShowSecretPhrase;
  final VoidCallback onDelete;

  const WalletMenuModal({
    super.key,
    required this.onRename,
    required this.onShowSecretPhrase,
    required this.onDelete,
  });

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
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          _buildMenuItem(icon: Icons.edit, title: 'Rename', onTap: onRename),
          _buildMenuItem(
            icon: Icons.visibility,
            title: 'Show Secret Phrase',
            onTap: onShowSecretPhrase,
          ),
          _buildMenuItem(
            icon: Icons.delete,
            title: 'Delete',
            titleColor: Colors.red,
            onTap: onDelete,
          ),
          20.sp.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? titleColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 16.sp),
        child: Row(
          children: [
            Icon(
              icon,
              color: titleColor ?? const Color(0xFF2D2D2D),
              size: 24.sp,
            ),
            15.horizontalSpace,
            Text(
              title,
              style: TextStyle(
                color: titleColor ?? const Color(0xFF2D2D2D),
                fontSize: 16.sp,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
