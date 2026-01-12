import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/data/Models/assets/network_model.dart';
import 'package:quanthex/data/Models/assets/supported_assets.dart';
import 'package:quanthex/data/Models/network/network_model.dart';
import 'package:quanthex/data/Models/send/send_payload.dart';
import 'package:quanthex/data/controllers/balance/balance_controller.dart';
import 'package:quanthex/data/controllers/wallet_controller.dart';
import 'package:quanthex/data/repository/secure_storage.dart';
import 'package:quanthex/data/services/transaction/transaction_service.dart';
import 'package:quanthex/data/utils/logger.dart';
import 'package:quanthex/data/utils/my_currency_utils.dart';
import 'package:quanthex/data/utils/overlay_utils.dart';
import 'package:quanthex/data/utils/security_utils.dart';
import 'package:quanthex/views/home/components/coin_image.dart';
import 'package:quanthex/widgets/snackbar/my_snackbar.dart';
import 'package:wallet/wallet.dart';
import 'package:web3dart/web3dart.dart';
import 'dart:math' as math;
import '../../../core/constants/network_constants.dart';
import '../../../data/utils/assets/token_factory.dart';
import '../../../data/utils/network/gas_fee_check.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/confirm_pin_modal.dart';
import '../../../widgets/info/row_info.dart';
import '../../swap/transfer_success_modal.dart';
class ConfirmTransactionModal extends StatelessWidget {
  ConfirmTransactionModal({super.key,required this.sendPayload});
  SendPayload sendPayload;
  late SupportedCoin token;
  late NetworkModel chain;
  late WalletController walletController;
  late BalanceController balanceController;

  @override
  Widget build(BuildContext context) {
    walletController=Provider.of<WalletController>(context,listen: false);
    balanceController=Provider.of<BalanceController>(context,listen: false);
    token=sendPayload.asset!;
    chain=sendPayload.asset!.networkModel!;
    double amountInFiat=sendPayload.amountInFiat??0.0;
    String recipientAddress=sendPayload.recipient_address??"";
    String fromAddress=walletController.currentWallet!.walletAddress??"";
    int decimal=sendPayload.asset!.decimal??0;
    double amount=sendPayload.amount??0.0;
    NetworkFee? fee=sendPayload.fee;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      height: 700.sp,
      padding: EdgeInsets.all(24.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.sp,
            height: 4.sp,
            margin: EdgeInsets.only(bottom: 20.sp),
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Container(
                  width: 80.sp,
                  height: 80.sp,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9E6FF),
                    shape: BoxShape.circle,
                  ),
                  child: CoinImage(
                    imageUrl: chain.imageUrl,
                    width: 80.sp,
                    height: 80.sp,
                  )
              ),
              // if (isPolygon)
              Positioned(
                bottom: -5.sp,
                right: -5.sp,
                child: Container(
                    width: 40.sp,
                    height: 40.sp,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: CoinImage(
                      imageUrl: chain.imageUrl,
                      width: 24.sp,
                      height: 24.sp,
                    )
                ),
              ),
            ],
          ),
          20.sp.verticalSpace,
          Text(
            'Confirm Transaction',
            style: TextStyle(
              color: const Color(0xFF2D2D2D),
              fontSize: 22.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w700,
            ),
          ),
          10.sp.verticalSpace,
          Text(
            'Review and confirm your transaction\nbefore sending.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF757575),
              fontSize: 14.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w400,
            ),
          ),
          20.sp.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/swapduo.png',
                width: 39.sp,
                height: 22.sp,
              ),
              10.horizontalSpace,
              Text(
                '${MyCurrencyUtils.format(amount,token.coinType==CoinType.TOKEN?2:6)} ${token.symbol} (${chain.chainSymbol})',
                style: TextStyle(
                  color: const Color(0xFF2D2D2D),
                  fontSize: 24.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          5.sp.verticalSpace,
          Text(
            '≈ \$${MyCurrencyUtils.format(amountInFiat,token.coinType==CoinType.TOKEN?2:6)} USD',
            style: TextStyle(
              color: const Color(0xFF757575),
              fontSize: 14.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
            ),
          ),
          25.sp.verticalSpace,
          Container(
            padding: EdgeInsets.all(16.sp),
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                RowInfo(label: "From", value: "${fromAddress.substring(0, 10)}...${fromAddress.substring(fromAddress.length - 10)}"),
                15.sp.verticalSpace,
                RowInfo(label: "To", value: '${recipientAddress.substring(0, 10)}...${recipientAddress.substring(recipientAddress.length - 10)}'),

                15.sp.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Network',
                      style: TextStyle(
                        color: const Color(0xFF757575),
                        fontSize: 14.sp,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // if (isPolygon)
                       CoinImage(
                           imageUrl: sendPayload.asset!.networkModel!.imageUrl,
                           height: 20.sp,
                           width: 20.sp
                       ),
                        8.horizontalSpace,
                        Text(
                          chain.chainName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: const Color(0xFF792A90),
                            fontSize: 14.sp,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          20.sp.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Network Fee',
                style: TextStyle(
                  color: const Color(0xFF757575),
                  fontSize: 14.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w400,
                ),
              ),
              fee!=null?Text(
                '\$ ${MyCurrencyUtils.format(amountInFiat,6)} ${sendPayload.asset!.networkModel!.chainSymbol}',
                style: TextStyle(
                  color: const Color(0xFF2D2D2D),
                  fontSize: 14.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w600,
                ),
              ):const SizedBox(),
            ],
          ),
          10.sp.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  color: const Color(0xFF2D2D2D),
                  fontSize: 16.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
              fee!=null?Text(
                '${MyCurrencyUtils.format(amount+fee.feeInCrypto,token.coinType==CoinType.TOKEN?4:6)} ${sendPayload.asset!.symbol}',
                style: TextStyle(
                  color: const Color(0xFF2D2D2D),
                  fontSize: 16.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ):Text(
                '${MyCurrencyUtils.format(amount,token.coinType==CoinType.TOKEN?4:6)} ${sendPayload.asset!.symbol}',
                style: TextStyle(
                  color: const Color(0xFF2D2D2D),
                  fontSize: 16.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          30.sp.verticalSpace,
          AppButton(
            text: 'Send Token',
            color: Color(0xff792A90),
            textColor: Color(0xffffffff),
            onTap: () async{
              String userPin=await SecureStorage.getInstance().getPin();
              if(userPin.isEmpty){
                logger("User PIN is empty, redirecting to set PIN", runtimeType.toString());
                sendTx(context);
              }else {
                bool result = await SecurityUtils.showPinDialog(context: context);
                if (result) {
                  sendTx(context);
                }
              }
            },
          ),
          10.sp.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/security-safe.png',
                width: 16.sp,
                height: 16.sp,
              ),
              Text(
                'Your transaction is secured by a smart contract',
                style: TextStyle(
                  color: const Color(0xFF7E7E7E),
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
          20.sp.verticalSpace,
        ],
      ),
    );
  }


  Future<void> _showSuccessModal(BuildContext context,SendPayload sendPayload)async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TransferSuccessModal(
        token: sendPayload.asset!,
        chain: sendPayload.asset!.networkModel!,
        amount: sendPayload.amount??0.0,
        recipientAddress: sendPayload.recipient_address??"",
      ),
    );
  }

  Future<void> sendTx(BuildContext context) async {
    try{
      // Implement the logic to send the transaction
      TokenFactory _tokenFactory=TokenFactory();
      SendPayload payload = sendPayload;
      NetworkFee? fee = sendPayload.fee;
      int decimal = sendPayload.asset!.decimal!;
      NetworkModel network=sendPayload.asset!.networkModel!;
      // double percentage1=payload.percentage/100;
      double recipientAmount = sendPayload.amount??0.0;
      double totalAmount = ((recipientAmount) * math.pow(10, decimal));
      logger("Total amount: $totalAmount",runtimeType.toString());
      if(fee==null){
        logger("Fee is null", runtimeType.toString());
        return ;
      }
      bool isGas=GasFeeCheck.gasFeeCheck(bCtr: balanceController, feeInCrypto: fee.feeInCrypto, chainCurrency: network.chainCurrency);
      SupportedCoin asset=sendPayload.asset!;
      if(isGas){
        showOverlay(context);
        if(asset.coinType==CoinType.TOKEN||asset.coinType==CoinType.WRAPPED_TOKEN){
          final String abi = await rootBundle.loadString("abi/token/token_contract.json");
          String contractAddress = sendPayload.asset!.contractAddress!;
          String assetName = sendPayload.asset!.name;
          String privateKey = sendPayload.asset!.privateKey!;
          final credentials = await _tokenFactory.getCredentials(privateKey);
          final contract = await _tokenFactory.intContract(abi, contractAddress, assetName);
          final sendFunction = contract.function('transfer');
          //Recipient receive 80%  of the transaction while admin receives 20 %
          Transaction transaction0 = Transaction.callContract(
              contract: contract,
              function: sendFunction,
              from: credentials.address,
              gasPrice: EtherAmount.inWei(fee.gasPrice),
              maxGas: fee.maxGas,
              parameters: [
                EthereumAddress.fromHex(sendPayload.recipient_address!),
                BigInt.from(totalAmount)
              ]
          );
          String txId=await TransactionService().sendTx(transaction: transaction0, credentials: credentials, asset: asset);
          // SendPayload payload=widget.sendPayload.copyWith(txId: txId);
          hideOverlay(context);
          if(txId.isNotEmpty){
           await _showSuccessModal(context,sendPayload);
            context.pop(txId);
          }
        }else{
          String toAddress = sendPayload.recipient_address!;
          String privateKey = sendPayload.asset!.privateKey!;
          final credentials = await _tokenFactory.getCredentials(privateKey);
          Transaction tx=Transaction(
            to: EthereumAddress.fromHex(toAddress),
            value: EtherAmount.fromBigInt(EtherUnit.wei, BigInt.from(totalAmount)),
            from: credentials.address,
            gasPrice: EtherAmount.inWei(fee.gasPrice),
            maxGas: fee.maxGas,
          );
          NetworkModel network=asset.networkModel!;
          int chainId=network.chainId;
          String txId=await TransactionService().sendNativeCoinTx(tx: tx, to: toAddress, credentials: credentials, asset: asset, chainId: chainId);
          logger(txId,runtimeType.toString());
          hideOverlay(context);
          if(txId.isNotEmpty){
            await _showSuccessModal(context,sendPayload);
            context.pop(txId);
          }
        }
      }else{
        hideOverlay(context);
        String nativeCoin=sendPayload.asset!.networkModel!.chainCurrency;
        String message="Insufficient $nativeCoin for gas, top up your balance to proceed";
        logger(message, runtimeType.toString());
        showMySnackBar(context: context, message: message, type: SnackBarType.error);
        return ;
      }
    }catch(e){
      hideOverlay(context);
      showMySnackBar(context: context, message: "An error occurred, make sure you have enough gas fee for this transaction and try again", type: SnackBarType.error);
      logger(e.toString(), runtimeType.toString());
    }
  }
}
