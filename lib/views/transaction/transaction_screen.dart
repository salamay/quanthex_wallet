import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/core/constants/network_constants.dart';
import 'package:quanthex/data/Models/assets/supported_assets.dart';
import 'package:quanthex/data/Models/transactions/erc20_transfer_dto.dart';
import 'package:quanthex/data/Models/transactions/native_tx_dto.dart';
import 'package:quanthex/data/controllers/assets/asset_controller.dart';
import 'package:quanthex/data/utils/logger.dart';
import 'package:quanthex/data/utils/navigator.dart';
import 'package:quanthex/views/transaction/components/native_tx_item.dart';
import 'package:quanthex/views/transaction/components/transaction_tab_bar.dart';
import 'package:quanthex/views/transaction/components/erc20_transaction_item.dart';
import 'package:quanthex/views/transaction/components/transaction_status_badge.dart';
import 'package:quanthex/widgets/global/empty_view.dart';
import 'package:quanthex/widgets/global/error_modal.dart';
import 'package:quanthex/widgets/loading_overlay/loading.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';

class TransactionScreen extends StatefulWidget {
   TransactionScreen({super.key, required this.coin});
  SupportedCoin coin;

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  String _selectedTab = 'All';
  int offset = 0;
  bool _hasError = false;
  bool _isMax = false;
  var _isLoading = false;
  late AssetController assetController;
  String contractAddress = '';
  String cursor = '';

  

 void _fetchData() async {
    try {
      _hasError=false;
      _isLoading = true;
      setState(() { });
      if (!mounted) {
        return;
      }

      // List<UserMessage> results=await getChats(context, offset);
      offset=assetController.erc20Transfers[contractAddress]?.length??0;
      logger("Offset: $offset", 'TransactionScreen');
      
      Map<String,dynamic> results=widget.coin.coinType == CoinType.NATIVE_TOKEN ? await assetController.getNativeTransfers(walletAddress: widget.coin.walletAddress??'', chainSymbol: widget.coin.networkModel!.chainSymbol, cursor: cursor, limit: 25)
       : await assetController.getErc20Transfers(walletAddress: widget.coin.walletAddress??'', contractAddress: contractAddress, chainSymbol: widget.coin.networkModel!.chainSymbol, cursor: cursor, limit: 25);
      if(results["cursor"]==null || results["cursor"]==""){
        _isMax=true;
      }
      cursor = results["cursor"]??'';
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
      });

    } catch (error) {
      logger("Error fetching data: $error", 'MyFriends');
      logger("Error fetching data: $error", 'MyFriends');
      _hasError=true;
      _isLoading=false;
      setState(() {

      });
    }
  }



@override
  void initState() {
    // TODO: implement initState
    assetController = Provider.of<AssetController>(context, listen: false);
    contractAddress = widget.coin.contractAddress?.toLowerCase()??'';
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Tab Bar
          10.sp.verticalSpace,
          TransactionTabBar(
            selectedTab: _selectedTab,
            onTabSelected: (tab) {
              setState(() {
                _selectedTab = tab;
              });
            },
          ),
          // Transaction List
          widget.coin.coinType == CoinType.NATIVE_TOKEN ? Consumer<AssetController>(
            builder: (context, assetController, child) {
              List<NativeTxDto> allTransfers = List.from(assetController.nativeTransfers[widget.coin.walletAddress?.toLowerCase() ?? ''] ?? []);
              List<NativeTxDto> transfers = [];
              String walletAddress = widget.coin.walletAddress?.toLowerCase()??'';
              if (_selectedTab == 'All') {
                transfers = allTransfers;
              } else if (_selectedTab == 'In') {
                 transfers = allTransfers.where((tx) => tx.toAddress == walletAddress).toList();
              } else {
                transfers = allTransfers.where((tx) => tx.toAddress != walletAddress).toList();
              }
              return Expanded(
                      child: InfiniteList(
                        physics: AlwaysScrollableScrollPhysics(),
                                  itemCount: transfers.length,
                                  isLoading: _isLoading,
                                  hasReachedMax: _isMax, // 👈 prevents extra calls
                                  hasError: _hasError,
                                  centerEmpty: true,
                                  onFetchData: _fetchData,
                                  separatorBuilder: (context, index) => const SizedBox(),
                                  emptyBuilder: (context) => _isLoading
                                      ? const SizedBox()
                                      : EmptyView(
                                        message: 'No transactions found',
                                      ),
                                  loadingBuilder: (context) => Loading(),
                                  centerError: true,
                                  centerLoading: true,
                                  errorBuilder: (context){
                                    return ErrorModal(
                                      callBack: (){
                                        _hasError=false;
                                        _isLoading = true;
                                        setState(() {});
                                        _fetchData();
                                  
                                      },
                                    );
                                  },
                                  itemBuilder: (BuildContext context, int index) {
                                    NativeTxDto nativeTx = transfers[index];
                                    TransactionType type = nativeTx.toAddress == widget.coin.walletAddress?.toLowerCase() ? TransactionType.receive : TransactionType.send;
                                    return NativeTxItem(nativeTx: nativeTx,type: type,tokenSymbol: widget.coin.symbol,);
                                  }
                              ),
                    );
            }
          ):Consumer<AssetController>(
            builder: (context, assetController, child) {
              List<Erc20TransferDto> allTransfers = List.from(assetController.erc20Transfers[contractAddress.toLowerCase()] ?? []);
              List<Erc20TransferDto> transfers = [];
              String walletAddress = widget.coin.walletAddress?.toLowerCase()??'';
              if (_selectedTab == 'All') {
                transfers = allTransfers;
              } else if (_selectedTab == 'In') {
                 transfers = allTransfers.where((tx) => tx.toAddress == walletAddress).toList();
              } else {
                transfers = allTransfers.where((tx) => tx.toAddress != walletAddress).toList();
              }
              return Expanded(
                      child: InfiniteList(
                        physics: AlwaysScrollableScrollPhysics(),
                                  itemCount: transfers.length,
                                  isLoading: _isLoading,
                                  hasReachedMax: _isMax, // 👈 prevents extra calls
                                  hasError: _hasError,
                                  centerEmpty: true,
                                  onFetchData: _fetchData,
                                  separatorBuilder: (context, index) => const SizedBox(),
                                  emptyBuilder: (context) => _isLoading
                                      ? const SizedBox()
                                      : EmptyView(
                                        message: 'No transactions found',
                                      ),
                                  loadingBuilder: (context) => Loading(),
                                  centerError: true,
                                  centerLoading: true,
                                  errorBuilder: (context){
                                    return ErrorModal(
                                      callBack: (){
                                        _hasError=false;
                                        _isLoading = true;
                                        setState(() {});
                                        _fetchData();
                                  
                                      },
                                    );
                                  },
                                  itemBuilder: (BuildContext context, int index) {
                                    Erc20TransferDto erc20Tx = transfers[index];
                                    TransactionType type = erc20Tx.toAddress == widget.coin.walletAddress?.toLowerCase() ? TransactionType.receive : TransactionType.send;
                                    String networkName = widget.coin.networkModel!.chainName;
                                    String networkSymbol = widget.coin.networkModel!.chainSymbol; 
                                    return Erc20TransactionItem(erc20Tx: erc20Tx,type: type,networkName: networkName,networkSymbol: networkSymbol,);
                                  }
                              ),
                    );
            }
          ),
        ],
      ),
    );
  }
}
