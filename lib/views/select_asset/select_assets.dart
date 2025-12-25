import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/data/controllers/assets/asset_controller.dart';

import '../../widgets/app_textfield.dart';
import '../home/components/asset_item.dart';

// Receiver Modal
class SelectAssets extends StatefulWidget {

  SelectAssets({super.key,});

  @override
  State<SelectAssets> createState() => _SelectAssetsState();
}

class _SelectAssetsState extends State<SelectAssets> {
  final TextEditingController _searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.sp),
      child: Consumer<AssetController>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
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
                    'Select asset',
                    style: TextStyle(
                      color: const Color(0xFF2D2D2D),
                      fontSize: 20.sp,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                20.sp.verticalSpace,
                AppTextfield(
                  controller: _searchController,
                  hintText: 'Search token',
                  prefixIcon: Icon(
                    Icons.search,
                    size: 20.sp,
                    color: const Color(0xFF9E9E9E),
                  ),
                  filledColor: const Color(0xFFF5F5F5),
                  borderColor: const Color(0xFFF5F5F5),
                  radius: 25,
                ),
                20.sp.verticalSpace,
                Consumer<AssetController>(
                  builder: (context, assetCtr, child) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: assetCtr.assets.map((e){
                          return GestureDetector(
                            onTap: (){
                              context.pop(e);
                            },
                              child: AssetItem(coin: e)
                          );
                        }).toList()
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
