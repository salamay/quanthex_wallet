import 'package:flutter/services.dart';
import 'package:quanthex/core/constants/crypto_constants.dart';
import 'package:quanthex/core/constants/network_constants.dart';
import 'package:quanthex/data/Models/assets/network_model.dart';
import 'package:quanthex/data/Models/assets/supported_assets.dart';
import 'package:quanthex/data/Models/network/network_model.dart';
import 'package:quanthex/data/Models/swap/model/coin_pair.dart';
import 'package:quanthex/data/services/transaction/transaction_service.dart';
import 'package:quanthex/data/utils/assets/client_resolver.dart' show ClientResolver;
import 'package:quanthex/data/utils/assets/token_factory.dart';
import 'package:quanthex/data/utils/logger.dart';
import 'package:quanthex/data/utils/swap/my_encoder.dart';
import 'package:quanthex/data/utils/swap/permit2Factory.dart';
import 'package:wallet/wallet.dart';
import 'package:web3dart/web3dart.dart';

class SwapService{
    static String permit2ContractAddress = "0x000000000022D473030F116dDEE9F6B43aC78BA3";

  static String bsc_swapRouter02 = "0xB971eF87ede563556b2ED4b1C0b0019111Dd85d2";
  static String eth_swapRouter02 = "0xE592427A0AEce92De3Edee1F18E0157C05861564";
  static String pol_swapRouter02 = "0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45";

  static String bsc_uniswap_universal_router_contract = "0x4Dae2f939ACf50408e13d58534Ff8c2776d45265";
  static String pol_uniswap_universal_router_contract = "0xec7BE89e9d109e7e3Fec59c222CF297125FEFda2";
  static String eth_uniswap_universal_router_contract = "0x66a9893cc07d91d95644aedd05d03f95e1dba8af";

  static final _tokenFactory = TokenFactory();
  static BigInt unlimited = BigInt.parse("115792089237316195423570985008687907853269984665640564039457584007913129639935");
  static BigInt permitUnlimited = BigInt.parse("1461501637330902918203684832716283019655932542975");

  SwapService._internal();
  static SwapService? _instance;

  static SwapService getInstance() {
    if (_instance == null) {
      logger("Creating new instance of SwapService", "SwapService");
    }
    _instance ??= SwapService._internal();
    return _instance!;
  }


   Future<String> getUniswapSwapRouterAbi() async {
    return await rootBundle.loadString("abi/uniswap/uniswap_router_abi.json");
  }

   Future<String> getUniswapUniversalRouterAbi() async {
    return await rootBundle.loadString("abi/uniswap/uniswap_universal_router_abi.json");
  }

   Future<String> getUniswapPaymentAbi() async {
    return await rootBundle.loadString("abi/uniswap/uniswap_payment_abi.json");
  }

   String getUniversalRouterAddress({required int chainId}) {
    switch (chainId) {
      case chain_id_bsc:
        return bsc_uniswap_universal_router_contract;
      case chain_id_pol:
        return pol_uniswap_universal_router_contract;
      case chain_id_eth:
        return eth_uniswap_universal_router_contract;
      default:
        return bsc_uniswap_universal_router_contract;
    }
  }

   String getUniswapSwapRouterAddress({required int chainId}) {
    switch (chainId) {
      case chain_id_bsc:
        return bsc_swapRouter02;
      case chain_id_pol:
        return pol_swapRouter02;
      case chain_id_eth:
        return eth_swapRouter02;
      default:
        return bsc_swapRouter02;
    }
  }
  String getWETHContractAddress({required int chainId}) {
    switch (chainId) {
      case chain_id_bsc:
        return bsc_wbnb_contract;
      case chain_id_pol:
        return polygon_wpol_contract;
      case chain_id_eth:
        return eth_weth_contract;
      default:
        return eth_weth_contract;
    }
  }
    String getWETHName({required int chainId}) {
      switch (chainId) {
        case chain_id_bsc:
          return "WBNB";
        case chain_id_pol:
          return "WMATIC";
        case chain_id_eth:
          return "WETH";
        default:
          return "WETH";
      }
    }
   Future<Transaction> constructTx({required DeployedContract contract, required ContractFunction function, required Credentials credentials, required List<dynamic> params, EtherAmount? gasPrice, int? maxGas, EtherAmount? value}) async {
    if (value == null) {
      Transaction transaction = Transaction.callContract(contract: contract, function: function, gasPrice: gasPrice, maxGas: maxGas, from: credentials.address, parameters: params);
      return transaction;
    } else {
      Transaction transaction = Transaction.callContract(contract: contract, function: function, gasPrice: gasPrice, maxGas: maxGas, value: value, from: credentials.address, parameters: params);
      return transaction;
    }
  }



   Future<BigInt> estimateTxGas({required String sender, required String to, required String rpcUrl, required Uint8List data, EtherAmount? value}) async {
    try {
      logger("Getting Tx fee","SwapService");
      Web3Client? webClient = await ClientResolver.resolveClient(rpcUrl: rpcUrl);
      BigInt gasPrice = await webClient.estimateGas(sender: EthereumAddress.fromHex(sender), to: EthereumAddress.fromHex(to), data: data, value: value);
      logger("Gas : ${gasPrice.toString()}","SwapService");
      BigInt totalGas = BigInt.from(gasPrice.toInt() * 2);
      return totalGas;
    } catch (e) {
      logger(e.toString(),"SwapService");
      throw Exception(e.toString());
    }
  }


  Future<String> approve({required String walletAddress, required String privateKey, required String spender,required String spender2, required  token0, required BigInt amountIn, required NetworkFee fee,required bool isIntermediary}) async {
    try {
      NetworkModel network = token0.networkModel!;
      logger("Approving $spender to spend ${token0.symbol} $amountIn","SwapService");
      TokenFactory _tokenFactory = TokenFactory();
      Web3Client web3client = await ClientResolver.resolveClient(rpcUrl: network.rpcUrl);
      int chainId = network.chainId;
      final String abi = await rootBundle.loadString("abi/token/token_contract.json");
      String contractAddress = token0.contractAddress!;
      final credentials = await _tokenFactory.getCredentials(privateKey);
      final contract = await _tokenFactory.intContract(abi, contractAddress, token0.name);
      final function = contract.function('approve');
      List<dynamic> params = [];
      //if its not intermediary, approves the router address, otherwise approves the universal router
      if (!isIntermediary) {
        params = [EthereumAddress.fromHex(spender), amountIn];
      } else {
        params = [EthereumAddress.fromHex(spender2), amountIn];
      }
      int maxGas = fee.maxGas;
      EtherAmount gasPrice = EtherAmount.fromBigInt(EtherUnit.wei, fee.gasPrice);
      Transaction transaction = await TransactionService().constructTx(contract: contract, function: function, credentials: credentials, params: params, gasPrice: gasPrice, maxGas: maxGas);
      Uint8List signedTransaction = await web3client.signTransaction(credentials, transaction, chainId: chainId, fetchChainIdFromNetworkId: false);
      String txId = await web3client.sendRawTransaction(signedTransaction);
      logger("TxId: $txId","SwapService");
      return txId;
    } catch (e) {
      logger(e.toString(),"SwapService");
      throw Exception(e);
    }
  }

   static bool checkValidity({required BigInt expiration}) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(expiration.toInt());
    DateTime now = DateTime.now();
    if (now.isBefore(dateTime)) {
      logger("Address has a valid permit","SwapService");
      return true;
    } else {
      logger("Address does not has a valid permit","SwapService");
      return false;
    }
  }



}