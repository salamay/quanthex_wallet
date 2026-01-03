import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/data/Models/assets/supported_assets.dart';
import 'package:quanthex/routes/app_routes.dart';
import 'package:quanthex/data/utils/navigator.dart';

import 'asset_item.dart';

class TokenSearchDelegate extends SearchDelegate<SupportedCoin?> {
  final List<SupportedCoin> assets;

  TokenSearchDelegate(this.assets);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(40.sp),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search, size: 64.sp, color: const Color(0xFF757575)),
                20.sp.verticalSpace,
                Text(
                  'Search tokens',
                  style: TextStyle(
                    color: const Color(0xFF2D2D2D),
                    fontSize: 18.sp,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                8.sp.verticalSpace,
                Text(
                  'Type to search for tokens by name or symbol',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF757575),
                    fontSize: 14.sp,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final filteredAssets = _filterAssets(assets);

    if (filteredAssets.isEmpty) {
      return Container(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(40.sp),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64.sp,
                  color: const Color(0xFF757575),
                ),
                20.sp.verticalSpace,
                Text(
                  'No tokens found',
                  style: TextStyle(
                    color: const Color(0xFF2D2D2D),
                    fontSize: 18.sp,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                8.sp.verticalSpace,
                Text(
                  'Try searching with a different term',
                  style: TextStyle(
                    color: const Color(0xFF757575),
                    fontSize: 14.sp,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
      itemCount: filteredAssets.length,
      itemBuilder: (context, index) {
        final asset = filteredAssets[index];
        return GestureDetector(
          onTap: () {
            close(context, asset);
            Navigate.toNamed(
              context,
              name: AppRoutes.ethereumdetailview,
              args: asset,
            );
          },
          child: AssetItem(coin: asset),
        );
      },
    );
  }

  List<SupportedCoin> _filterAssets(List<SupportedCoin> assets) {
    if (query.isEmpty) {
      return assets;
    }
    final searchQuery = query.toLowerCase().trim();
    return assets.where((asset) {
      final name = asset.name.toLowerCase();
      final symbol = asset.symbol.toLowerCase();
      return name.contains(searchQuery) || symbol.contains(searchQuery);
    }).toList();
  }

  @override
  String get searchFieldLabel => 'Search token';

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: const Color(0xFF2D2D2D)),
        titleTextStyle: TextStyle(
          color: const Color(0xFF2D2D2D),
          fontSize: 18.sp,
          fontFamily: 'Satoshi',
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: const Color(0xFF9E9E9E),
          fontSize: 16.sp,
          fontFamily: 'Satoshi',
        ),
        border: InputBorder.none,
      ),
    );
  }
}
