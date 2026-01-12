// Token Selector Modal for Swap
import 'package:quanthex/core/constants/network_constants.dart';
import 'package:quanthex/data/Models/assets/network_model.dart';
import 'package:quanthex/data/Models/assets/supported_assets.dart';
import 'package:quanthex/data/Models/balance/CoinBalance.dart';
import 'package:quanthex/data/controllers/balance/balance_controller.dart';
import 'package:quanthex/data/utils/my_currency_utils.dart';
import 'package:quanthex/views/home/components/coin_image.dart';
import 'package:quanthex/widgets/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SwapTokenSelectorModal extends StatefulWidget {
  final List<SupportedCoin> tokens;
  final NetworkModel? selectedChain;
  final SupportedCoin? currentFromToken;
  final SupportedCoin? currentToToken;
  final bool isFrom;
  final Function(SupportedCoin) onTokenSelected;

  const SwapTokenSelectorModal({super.key, required this.tokens, this.selectedChain, this.currentFromToken, this.currentToToken, required this.isFrom, required this.onTokenSelected});

  @override
  State<SwapTokenSelectorModal> createState() => _SwapTokenSelectorModalState();
}

class _SwapTokenSelectorModalState extends State<SwapTokenSelectorModal> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<SupportedCoin> get _filteredTokens {
    List<SupportedCoin> tokens = widget.tokens;

    // Filter by selected chain if available
    if (widget.selectedChain != null) {
      tokens = tokens.where((token) => token.networkModel?.chainId == widget.selectedChain!.chainId).toList();
    }

    // Filter out the opposite token (can't select same token for from and to)
    if (widget.isFrom && widget.currentToToken != null) {
      tokens = tokens.where((token) {
        return !(token.contractAddress?.toLowerCase() == widget.currentToToken!.contractAddress?.toLowerCase() && token.networkModel?.chainId == widget.currentToToken!.networkModel?.chainId);
      }).toList();
    } else if (!widget.isFrom && widget.currentFromToken != null) {
      tokens = tokens.where((token) {
        return !(token.contractAddress?.toLowerCase() == widget.currentFromToken!.contractAddress?.toLowerCase() && token.networkModel?.chainId == widget.currentFromToken!.networkModel?.chainId);
      }).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      tokens = tokens.where((token) {
        return token.name.toLowerCase().contains(query) || token.symbol.toLowerCase().contains(query) || (token.contractAddress?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    return tokens;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.sp),
      height: MediaQuery.of(context).size.height * 0.85,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.sp,
              height: 4.sp,
              margin: EdgeInsets.only(bottom: 20.sp),
              decoration: BoxDecoration(color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(2)),
            ),
          ),
          Center(
            child: Text(
              widget.isFrom ? 'Select Token to Swap From' : 'Select Token to Swap To',
              style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 20.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
            ),
          ),
          20.sp.verticalSpace,
          AppTextfield(
            controller: _searchController,
            hintText: 'Search token',
            prefixIcon: Icon(Icons.search, size: 20.sp, color: const Color(0xFF9E9E9E)),
            filledColor: const Color(0xFFF5F5F5),
            borderColor: const Color(0xFFF5F5F5),
            radius: 25,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          20.sp.verticalSpace,
          Expanded(
            child: Consumer<BalanceController>(
              builder: (context, balanceController, child) {
                final tokens = _filteredTokens;

                if (tokens.isEmpty) {
                  return Center(
                    child: Text(
                      _searchQuery.isNotEmpty ? 'No tokens found' : 'No tokens available',
                      style: TextStyle(color: const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi'),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: tokens.length,
                  itemBuilder: (context, index) {
                    final token = tokens[index];
                    final isSelected = widget.isFrom
                        ? widget.currentFromToken?.contractAddress?.toLowerCase() == token.contractAddress?.toLowerCase() && widget.currentFromToken?.networkModel?.chainId == token.networkModel?.chainId
                        : widget.currentToToken?.contractAddress?.toLowerCase() == token.contractAddress?.toLowerCase() && widget.currentToToken?.networkModel?.chainId == token.networkModel?.chainId;

                    CoinBalance? balance = token.coinType == CoinType.TOKEN ? balanceController.balances[token.contractAddress!] : balanceController.balances[token.symbol];

                    return GestureDetector(
                      onTap: () {
                        widget.onTokenSelected(token);
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 12.sp),
                        padding: EdgeInsets.all(16.sp),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFFAE9FF) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isSelected ? const Color(0xFF792A90) : const Color(0xFFE0E0E0), width: isSelected ? 2 : 1),
                        ),
                        child: Row(
                          children: [
                            CoinImage(imageUrl: token.image, height: 40.sp, width: 40.sp),
                            12.horizontalSpace,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    token.name,
                                    style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 16.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                                  ),
                                  4.verticalSpace,
                                  Row(
                                    children: [
                                      Text(
                                        token.symbol,
                                        style: TextStyle(color: const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                                      ),
                                      if (token.networkModel != null) ...[
                                        4.horizontalSpace,
                                        Text(
                                          "(${token.networkModel!.chainSymbol.toUpperCase()})",
                                          style: TextStyle(color: const Color(0xFF757575), fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (balance != null)
                                  Text(
                                    balance.balanceInCrypto != 0 ? MyCurrencyUtils.format(balance.balanceInCrypto, token.coinType == CoinType.TOKEN ? 2 : 6) : "0",
                                    style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                                  ),
                                if (isSelected)
                                  Padding(
                                    padding: EdgeInsets.only(top: 4.sp),
                                    child: Icon(Icons.check_circle, color: const Color(0xFF792A90), size: 20.sp),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}