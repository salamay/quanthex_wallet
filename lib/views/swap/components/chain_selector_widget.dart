import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/data/Models/assets/network_model.dart';

/// A reusable widget for selecting a blockchain network/chain
class ChainSelectorWidget extends StatefulWidget {
  /// List of available networks to choose from
  final List<NetworkModel> networks;

  /// Currently selected network (optional)
  final NetworkModel? selectedNetwork;

  /// Callback when a network is selected
  final Function(NetworkModel) onChainSelected;

  /// Title to display (optional)
  final String? title;

  /// Whether to show a search bar
  final bool showSearch;

  /// Custom height for the widget (optional)
  final double? height;

  const ChainSelectorWidget({super.key, required this.networks, this.selectedNetwork, required this.onChainSelected, this.title, this.showSearch = false, this.height});

  @override
  State<ChainSelectorWidget> createState() => _ChainSelectorWidgetState();
}

class _ChainSelectorWidgetState extends State<ChainSelectorWidget> {
  String? _selectedChainId;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.selectedNetwork != null) {
      _selectedChainId = widget.selectedNetwork!.chainId.toString();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<NetworkModel> get _filteredNetworks {
    if (_searchQuery.isEmpty) {
      return widget.networks;
    }
    return widget.networks.where((network) {
      final query = _searchQuery.toLowerCase();
      return network.chainName.toLowerCase().contains(query) || network.chainSymbol.toLowerCase().contains(query) || network.chainCurrency.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      padding: EdgeInsets.all(16.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          if (widget.title != null) ...[
            Text(
              widget.title!,
              style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 20.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w700),
            ),
            20.sp.verticalSpace,
          ],

          // Search bar
          if (widget.showSearch) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 8.sp),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, size: 20.sp, color: const Color(0xFF757575)),
                  8.horizontalSpace,
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search chains...',
                        hintStyle: TextStyle(color: const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi'),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 14.sp, fontFamily: 'Satoshi'),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _searchQuery = '';
                          _searchController.clear();
                        });
                      },
                      child: Icon(Icons.clear, size: 18.sp, color: const Color(0xFF757575)),
                    ),
                ],
              ),
            ),
            16.sp.verticalSpace,
          ],

          // Networks list
          Expanded(
            child: _filteredNetworks.isEmpty
                ? Center(
                    child: Text(
                      'No chains found',
                      style: TextStyle(color: const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi'),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredNetworks.length,
                    itemBuilder: (context, index) {
                      final network = _filteredNetworks[index];
                      final isSelected = _selectedChainId == network.chainId.toString();

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedChainId = network.chainId.toString();
                          });
                          widget.onChainSelected(network);
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 12.sp),
                          padding: EdgeInsets.all(16.sp),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFFAE9FF) : const Color(0xFFF6F6F6),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isSelected ? const Color(0xFF792A90) : const Color(0xFFE0E0E0), width: isSelected ? 2 : 1),
                          ),
                          child: Row(
                            children: [
                              // Chain image
                              Container(
                                width: 40.sp,
                                height: 40.sp,
                                clipBehavior: Clip.hardEdge,
                                decoration: const BoxDecoration(shape: BoxShape.circle),
                                child: CachedNetworkImage(
                                  imageUrl: network.imageUrl,
                                  imageBuilder: (context, imageProvider) => Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
                                    ),
                                  ),
                                  placeholder: (context, url) => Container(
                                    color: const Color(0xFFF5F5F5),
                                    child: Center(
                                      child: SizedBox(
                                        width: 20.sp,
                                        height: 20.sp,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: const Color(0xFF792A90)),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: const Color(0xFFF5F5F5),
                                    child: Icon(Icons.error_outline, size: 20.sp, color: const Color(0xFF757575)),
                                  ),
                                ),
                              ),
                              12.horizontalSpace,

                              // Chain info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      network.chainName,
                                      style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 15.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
                                    ),
                                    4.verticalSpace,
                                    Row(
                                      children: [
                                        Text(
                                          network.chainSymbol,
                                          style: TextStyle(color: const Color(0xFF757575), fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                                        ),
                                        if (network.chainCurrency.isNotEmpty && network.chainCurrency != network.chainSymbol) ...[
                                          Text(
                                            ' • ${network.chainCurrency}',
                                            style: TextStyle(color: const Color(0xFF757575), fontSize: 12.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Selection indicator
                              if (isSelected) Icon(Icons.check_circle, color: const Color(0xFF792A90), size: 24.sp),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// A modal version of the chain selector
class ChainSelectorModal extends StatelessWidget {
  final List<NetworkModel> networks;
  final NetworkModel? selectedNetwork;
  final Function(NetworkModel) onChainSelected;
  final String? title;
  final bool showSearch;

  const ChainSelectorModal({super.key, required this.networks, this.selectedNetwork, required this.onChainSelected, this.title, this.showSearch = true});

  void _showModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        child: ChainSelectorWidget(
          networks: networks,
          selectedNetwork: selectedNetwork,
          onChainSelected: (network) {
            onChainSelected(network);
            Navigator.pop(context);
          },
          title: title ?? 'Select Chain',
          showSearch: showSearch,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showModal(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 10.sp),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selectedNetwork != null) ...[
              Container(
                width: 24.sp,
                height: 24.sp,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: CachedNetworkImage(
                  imageUrl: selectedNetwork!.imageUrl,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
                    ),
                  ),
                  placeholder: (context, url) => Container(color: const Color(0xFFF5F5F5)),
                  errorWidget: (context, url, error) => Container(
                    color: const Color(0xFFF5F5F5),
                    child: Icon(Icons.error_outline, size: 16.sp, color: const Color(0xFF757575)),
                  ),
                ),
              ),
              8.horizontalSpace,
              Text(
                selectedNetwork!.chainSymbol,
                style: TextStyle(color: const Color(0xFF2D2D2D), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
              ),
            ] else ...[
              Text(
                'Select Chain',
                style: TextStyle(color: const Color(0xFF757575), fontSize: 14.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
              ),
            ],
            8.horizontalSpace,
            Icon(Icons.keyboard_arrow_down, size: 20.sp, color: const Color(0xFF757575)),
          ],
        ),
      ),
    );
  }
}
