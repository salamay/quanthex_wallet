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

     Future<BigInt> estimateApproveTx({required SupportedCoin from, required CoinPair pair, required double amountIn, required String privateKey}) async {
    try {
      TokenFactory _tokenFactory = TokenFactory();
      final String abi = await rootBundle.loadString("assets/token_contract.json");
      String contractAddress = from.contractAddress!;
      NetworkModel networkModel = pair.token0.networkModel!;
      final contract = await _tokenFactory.intContract(abi, contractAddress, from.name);
      final credentials = await _tokenFactory.getCredentials(privateKey);
      final function = contract.function('approve');
      List<dynamic> params = [];
      //if its not intermediary, approves the router address, otherwise approves the universal router
      if (!pair.isIntermediary) {
        params = [EthereumAddress.fromHex(getUniswapSwapRouterAddress(chainId: networkModel.chainId)), BigInt.from(amountIn)];
      } else {
        String routerAddress = getUniswapSwapRouterAddress(chainId: networkModel.chainId);
        params = [EthereumAddress.fromHex(routerAddress), BigInt.from(amountIn)];
      }

      Transaction tx = await constructTx(contract: contract, function: function, credentials: credentials, params: params);
      BigInt gas = await estimateTxGas(sender: credentials.address.with0x, to: contractAddress, rpcUrl: networkModel.rpcUrl, data: tx.data!);
      return gas;
    } catch (e) {
      logger(e.toString(),"SwapService");
      throw Exception("Could not get fee");
    }
  }
    static Future<BigInt> getPoolFee({required CoinPair pair, required String poolAddress, required String poolAbi}) async {
    logger("Swap: Getting pool fee $poolAddress","SwapService");
    try {
      NetworkModel network = pair.token0.networkModel!;
      int chainId = network.chainId;
      Web3Client web3client = await ClientResolver.resolveClient(rpcUrl: network.rpcUrl);
      SupportedCoin tokenIn = pair.token0;
      SupportedCoin tokenOut = pair.token1;
      DeployedContract poolContract = await _tokenFactory.intContract(poolAbi, poolAddress, tokenIn.symbol);
      logger("Swap: pool: Setting up contract","SwapService");
      logger("Swap: pool: Pool contract abi loaded","SwapService");
      logger("Swap: pool: Calling fee function","SwapService");
      final balanceFunction = poolContract.function('fee');
      final balance = await web3client.call(contract: poolContract, function: balanceFunction, params: []);
      BigInt amount = balance.first;
      logger('${tokenIn.symbol}/${tokenOut.symbol} Pool fee: $amount','SwapService');
      return amount;
    } catch (e) {
      logger(e.toString(),"SwapService");
      throw Exception("Unable to get pool fee");
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
     Future<String> callPermit({required String privateKey, required String tokenAddress, required String spenderAddress, required String rpcUrl, required int chainId, required String chainSymbol, required NetworkFee fee}) async {
    try {
      logger("Calling permit for $tokenAddress on $spenderAddress","SwapService");
      logger("Token Address: $tokenAddress", "SwapService");
      logger("Spender Address: $spenderAddress", "SwapService");
      logger("Amount In: $permitUnlimited", "SwapService");
      TokenFactory tokenFactory = TokenFactory();
      Web3Client web3client = await ClientResolver.resolveClient(rpcUrl: rpcUrl);
      final String permit2Abi = await rootBundle.loadString("abi/permit/permit2.json");
      final contract = await tokenFactory.intContract(permit2Abi, permit2ContractAddress, "Permit2");
      final permitFunction = contract.findFunctionsByName('approve').last;
      final credentials = await tokenFactory.getCredentials(privateKey);
      BigInt amountIn = permitUnlimited;
      final gasPrice = EtherAmount.inWei(fee.gasPrice);
      final maxGas = fee.maxGas;
      BigInt deadline = BigInt.from(DateTime.now().add(const Duration(minutes: 30)).millisecondsSinceEpoch);
      List<dynamic> param = [EthereumAddress.fromHex(tokenAddress), EthereumAddress.fromHex(spenderAddress), amountIn, deadline];
      Transaction tx = await constructTx(contract: contract, function: permitFunction, credentials: credentials, params: param, gasPrice: gasPrice, maxGas: maxGas);
      Uint8List signedTransaction = await web3client.signTransaction(credentials, tx, chainId: chainId, fetchChainIdFromNetworkId: false);
      String txId = await web3client.sendRawTransaction(signedTransaction);
      logger("Permit2 txId: $txId", "SwapService");
      return txId;
    } catch (e) {
      logger(e.toString(), "SwapService");
      throw Exception(e);
    }
  }
    static Future<bool> checkPermitAllowance({required String privateKey, required String ownerAddress, required String tokenAddress, required String spenderAddress, required String rpcUrl, required int chainId, required String chainSymbol}) async {
    try {
      logger("Checking allowance for $spenderAddress on $tokenAddress","SwapService");
      Web3Client web3client = await ClientResolver.resolveClient(rpcUrl: rpcUrl);
      TokenFactory tokenFactory = TokenFactory();
      final String permit2Abi = await rootBundle.loadString("abi/permit/permit2.json");
      final contract = await tokenFactory.intContract(permit2Abi, permit2ContractAddress, "Permit2");
      final permitFunction = contract.function('allowance');
      BigInt deadline = BigInt.from(DateTime.now().add(const Duration(minutes: 30)).millisecondsSinceEpoch);
      List<dynamic> param = [EthereumAddress.fromHex(ownerAddress), EthereumAddress.fromHex(tokenAddress), EthereumAddress.fromHex(spenderAddress)];
      final result = await web3client.call(contract: contract, function: permitFunction, params: param);
      BigInt amount = result[0];
      BigInt expiration = result[1];
      BigInt nonce = result[2];
      logger("Allowance: $amount, expiration: $expiration, nonce: $nonce","SwapService");
      return true;
    } catch (e) {
      logger(e.toString(),"SwapService");
      throw Exception("Unable to check allowance");
    }
  }

   static bool checkValidity({required BigInt amount, required BigInt expiration, required BigInt nonce}) {
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


     Future<BigInt> estimateApprove2Tx({required String privateKey, required spender, required BigInt amountIn, required String contractAddress, required String rpcUrl}) async {
    try {
      TokenFactory _tokenFactory = TokenFactory();
      Web3Client? web3client = await ClientResolver.resolveClient(rpcUrl: rpcUrl);
      final String abi = await rootBundle.loadString("abi/token/token_contract.json");
      final credentials = await _tokenFactory.getCredentials(privateKey);
      final contract = await _tokenFactory.intContract(abi, contractAddress, "TokenContract");
      final function = contract.function('approve');
      List<dynamic> params = [EthereumAddress.fromHex(spender), amountIn];
      Transaction tx = await constructTx(contract: contract, function: function, credentials: credentials, params: params);
      BigInt gas = await estimateTxGas(sender: credentials.address.with0x, to: contractAddress, rpcUrl: rpcUrl, data: tx.data!);
      return gas;
    } catch (e) {
      logger(e.toString(),"SwapService");
      throw Exception("Could not get fee");
    }
  }
     Future<BigInt> estimatePermitApproval({required String ownerAddress, required String tokenAddress, required spenderAddress, required BigInt amountIn, required String privateKey, required String rpcUrl}) async {
    try {
      logger("Estimating permit approval tx","SwapService");
      TokenFactory tokenFactory = TokenFactory();
      Web3Client web3client = await ClientResolver.resolveClient(rpcUrl: rpcUrl);
      final String permit2Abi = await rootBundle.loadString("abi/permit/permit2.json");
      final contract = await tokenFactory.intContract(permit2Abi, Permit2Factory.permit2ContractAddress, "Permit2");
      final permitFunction = contract.findFunctionsByName('approve').last;
      final credentials = await tokenFactory.getCredentials(privateKey);
      BigInt deadline = BigInt.from(DateTime.now().add(const Duration(minutes: 30)).millisecondsSinceEpoch);
      List<dynamic> params = [EthereumAddress.fromHex(tokenAddress), EthereumAddress.fromHex(spenderAddress), amountIn, deadline];
      Transaction tx = await constructTx(contract: contract, function: permitFunction, credentials: credentials, params: params);
      BigInt gas = await estimateTxGas(sender: ownerAddress, to: Permit2Factory.permit2ContractAddress, rpcUrl: rpcUrl, data: tx.data!);
      return gas;
    } catch (e) {
      logger(e.toString(),"SwapService");
      throw Exception("Could not get fee");
    }
  }



   Future<BigInt> estimateSwapTx({required String privateKey, required String fromAddress, required BigInt poolFee, required CoinPair pair, required BigInt amountIn, required String rpcUrl}) async {
    try {
      TokenFactory _tokenFactory = TokenFactory();
      NetworkModel networkModel = pair.token0.networkModel!;
      String routerAddress = getUniswapSwapRouterAddress(chainId: networkModel.chainId);
      String routerAbi = await getUniswapSwapRouterAbi();
      DeployedContract contract = await _tokenFactory.intContract(routerAbi, routerAddress, "Router");
      final exactInputSingle = contract.function("exactInputSingle");
      final credentials = await _tokenFactory.getCredentials(privateKey);
      // BigInt poolFee = await swapController.getPoolFee(pair: pair,poolAddress: pair.poolAddress, poolAbi: pair.poolAbi);
      List<dynamic> params = [
        [EthereumAddress.fromHex(pair.token0.contractAddress!), EthereumAddress.fromHex(pair.token1.contractAddress!), poolFee, EthereumAddress.fromHex(fromAddress), amountIn, BigInt.zero, BigInt.zero],
      ];
      logger(params.toString(),"SwapService");
      Transaction tx = await constructTx(contract: contract, function: exactInputSingle, credentials: credentials, params: params);
      BigInt gas = await estimateTxGas(sender: fromAddress, to: routerAddress, rpcUrl: rpcUrl, data: tx.data!);
      return gas;
    } catch (e) {
      logger(e.toString(),"SwapService");
      throw Exception("Could not get gas");
    }
  }
     Future<BigInt> estimateTokenToNativeSwapTx({ required CoinPair pair, required BigInt amountIn,required BigInt wethAmountMin, required BigInt poolFee,required bool isIntermediary}) async {
    try {
      logger("Estimating token to native swap tx","SwapService");
      logger("Amount In: $amountIn","SwapService");
      logger("Amount Out Min: $wethAmountMin","SwapService");
      logger("Is Intermediary: $isIntermediary","SwapService");
      TokenFactory _tokenFactory = TokenFactory();
      NetworkModel network = pair.token0.networkModel!;
      SupportedCoin pairOne = pair.token0;
      // SupportedCoin pairTwo = pair.token1;
      SupportedCoin weth = pair.weth!;
      String privateKey = pairOne.privateKey!;
      int chainId = network.chainId;
      String rpcUrl = network.rpcUrl;
      Web3Client web3client = await ClientResolver.resolveClient(rpcUrl: rpcUrl);
      String universalRouter = getUniversalRouterAddress(chainId: network.chainId);
      String universalRouterAbi = await getUniswapUniversalRouterAbi();
      DeployedContract contract = await _tokenFactory.intContract(universalRouterAbi, universalRouter, "universalRouter");
      //we need to call the execute function so as to run two functions together
      final execute = contract.findFunctionsByName("execute").first;
      final credentials = await _tokenFactory.getCredentials(privateKey);
      List<int> commands = [0x00, 0x0c];
      //convert the command to bytes
      var commandBytes = Uint8List.fromList(commands);
      List<String> path = [];
      if (!isIntermediary) {
        path = [EthereumAddress.fromHex(pairOne.contractAddress!).with0x, EthereumAddress.fromHex(weth.contractAddress!).with0x];
      } else {
        path = [EthereumAddress.fromHex(pairOne.contractAddress!).with0x, EthereumAddress.fromHex(pair.intermediaryContract).with0x, EthereumAddress.fromHex(weth.contractAddress!).with0x];
      }
      //Path is the list of token addresses that the swap will go through
      List<int> poolFees = [];
      if (!isIntermediary) {
        poolFees = [poolFee.toInt()];
      } else {
        poolFees = [poolFee.toInt(), pair.intermediaryPoolFee.toInt()];
      }
      //This encode the path and fees then pad it to 64
      String encodedPath = MyEncoder.encodePath(path: path, fees: poolFees).padLeft(64, "0");
      logger("Encoded Path:$encodedPath","SwapService");
      //The recipient in the case of uniswap, 2 indicate the address of the contract and 1 indicate the MSG.SENDER
      String recipientMsgSender = 1.toRadixString(16).padLeft(40, "0");
      String recipientContract = 2.toRadixString(16).padLeft(40, "0");
      logger("Recipient (msg.sender): $recipientMsgSender","SwapService");
      logger("Recipient (Contract): $recipientContract","SwapService");
      // flag for whether the input tokens should come from the msg.sender (through Permit2) or whether the funds are already in the UniversalRouter
      int flag = 1;
      final v3SwapExactInputParams = [EthereumAddress.fromHex("0x$recipientMsgSender"), amountIn, wethAmountMin, hexToBytes("0x$encodedPath"), EthereumAddress.fromHex("0x${flag.toRadixString(16).padLeft(40, "0")}")];
      // Ignore the address of the contract, we just used it so we can use the function for encoding
      final v3SwapExactInputEncoded = await encodeV3SwapExactInput(param: v3SwapExactInputParams, address: universalRouter);
      final EthereumAddress unwrapWETH9Recipient = EthereumAddress.fromHex(pairOne.walletAddress??"");
      final unwrapWETH9Params = [unwrapWETH9Recipient, wethAmountMin];
      //Ignore the address of the contract, we just used it so we can use the function for encoding
      final unwrapWETH9Encoded = await encodeUnwrapWETH(param: unwrapWETH9Params, address: universalRouter);
      List<String> inputsParams = [bytesToHex(v3SwapExactInputEncoded), bytesToHex(unwrapWETH9Encoded)];
      BigInt deadLine = BigInt.from(DateTime.now().add(const Duration(minutes: 5)).millisecondsSinceEpoch);
      List<dynamic> executeParams = [commandBytes, inputsParams.map(hexToBytes).toList()];
      Transaction tx = await constructTx(contract: contract, function: execute, credentials: credentials, params: executeParams);
      BigInt gas = await estimateTxGas(sender: pairOne.walletAddress!, to: universalRouter, rpcUrl: rpcUrl, data: tx.data!);
      return gas;
    } catch (e) {
      logger(e.toString(),"SwapService");
      throw Exception(e);
    }
  }

   Future<BigInt> estimateNativeToTokenSwapTx({required CoinPair pair, required String wethAddress,required BigInt amountIn, required BigInt amountOutMin, required BigInt wethAmountMin, required BigInt poolFee,required bool isIntermediary}) async {
    try {
      TokenFactory _tokenFactory = TokenFactory();
      NetworkModel network = pair.token0.networkModel!;
      SupportedCoin pairOne = pair.token0;
      SupportedCoin pairTwo = pair.token1;
      int chainId = network.chainId;
      String rpcUrl = network.rpcUrl;
      String privateKey = pairOne.privateKey!;
      String walletAddress = pairOne.walletAddress!;
      Web3Client web3client = await ClientResolver.resolveClient(rpcUrl: rpcUrl);
      String universalRouter = getUniversalRouterAddress(chainId: chainId);
      String universalRouterAbi = await getUniswapUniversalRouterAbi();
      DeployedContract contract = await _tokenFactory.intContract(universalRouterAbi, universalRouter, "universalRouter");
      //we need to call the execute function so as to run two functions together
      final execute = contract.findFunctionsByName("execute").first;
      final credentials = await _tokenFactory.getCredentials(privateKey);
      List<int> commands = [0x0b, 0x00, 0x04];
      //convert the command to bytes
      var commandBytes = Uint8List.fromList(commands);
      List<String> path = [EthereumAddress.fromHex(wethAddress).with0x, EthereumAddress.fromHex(pairTwo.contractAddress!).with0x];
      //Path is the list of token addresses that the swap will go through
      if (!isIntermediary) {
        path = [EthereumAddress.fromHex(wethAddress).with0x, EthereumAddress.fromHex(pairTwo.contractAddress!).with0x];
      } else {
        path = [EthereumAddress.fromHex(wethAddress).with0x, EthereumAddress.fromHex(pair.intermediaryContract).with0x, EthereumAddress.fromHex(pairTwo.contractAddress!).with0x];
      }
      List<int> poolFees = [];
      if (!isIntermediary) {
        poolFees = [poolFee.toInt()];
      } else {
        poolFees = [poolFee.toInt(), pair.intermediaryPoolFee!.toInt()];
      }
      //This encode the path and fees then pad it to 64
      String encodedPath = MyEncoder.encodePath(path: path, fees: poolFees).padLeft(64, "0");
      logger("Encoded Path:$encodedPath","SwapService");
      //The recipient in the case of uniswap, 2 indicate the address of the contract and 1 indicate the MSG.SENDER
      String ethAddress = 0.toRadixString(16).padLeft(40, "0");
      String recipientMsgSender = 1.toRadixString(16).padLeft(40, "0");
      String recipientContract = 2.toRadixString(16).padLeft(40, "0");
      logger("Recipient (msg.sender): $recipientMsgSender","SwapService");
      logger("Recipient (Contract): $recipientContract","SwapService");
      // flag for whether the input tokens should come from the msg.sender (through Permit2) or whether the funds are already in the UniversalRouter
      int flag = 0;
      final v3wrapETHInputParams = [EthereumAddress.fromHex("0x$recipientContract"), amountIn];
      final v3SwapExactInputParams = [EthereumAddress.fromHex(walletAddress), amountIn, BigInt.zero, hexToBytes("0x$encodedPath"), EthereumAddress.fromHex("0x${flag.toRadixString(16).padLeft(40, "0")}")];
      final sweepParam = [EthereumAddress.fromHex(ethAddress), EthereumAddress.fromHex(walletAddress), BigInt.zero];
      //Ignore the address of the contract, we just used it so we can use the function for encoding
      final v3wrapETHInputEncoded = await encodeWrapWETH(param: v3wrapETHInputParams, address: universalRouter);
      //Ignore the address of the contract, we just used it so we can use the function for encoding
      final v3SwapExactInputEncoded = await encodeV3SwapExactInput(param: v3SwapExactInputParams, address: universalRouter);
      final sweepParamEncoded = await encodeSweepETH(param: sweepParam, address: universalRouter);

      List<String> inputsParams = [bytesToHex(v3wrapETHInputEncoded), bytesToHex(v3SwapExactInputEncoded), bytesToHex(sweepParamEncoded)];
      BigInt deadLine = BigInt.from(DateTime.now().add(const Duration(minutes: 5)).millisecondsSinceEpoch);
      List<dynamic> executeParams = [commandBytes, inputsParams.map(hexToBytes).toList()];
      Transaction tx = await constructTx(contract: contract, function: execute, credentials: credentials, params: executeParams, value: EtherAmount.fromBigInt(EtherUnit.wei, amountIn));
      BigInt gas = await estimateTxGas(sender: walletAddress, to: universalRouter, rpcUrl: rpcUrl, data: tx.data!, value: EtherAmount.fromBigInt(EtherUnit.wei, amountIn));
      return gas;
    } catch (e) {
      logger(e.toString(),"SwapService");
      throw Exception("Could not get execute gas");
    }
  }

    Future<String> swap({required BigInt poolFee, required CoinPair pair, required BigInt amountIn, required BigInt amountOutMin, required NetworkFee fee,required String rpcUrl,required String chainSymbol,required int chainId}) async {
      SupportedCoin from = pair.token0;
    try {
      logger("Amount In: $amountIn","SwapService");
      logger("Amount Out Min: $amountOutMin","SwapService");
      logger("Pool Fee: $poolFee","SwapService");
      logger("Pair: $pair","SwapService");
      logger("RPC URL: $rpcUrl","SwapService");
      logger("Chain Symbol: $chainSymbol","SwapService");
      logger("Chain Id: $chainId","SwapService");
      TokenFactory _tokenFactory = TokenFactory();
      NetworkModel network = pair.token0.networkModel!;
      String privateKey = from.privateKey!;
      Web3Client web3client = await ClientResolver.resolveClient(rpcUrl: rpcUrl);
      String routerAddress = getUniswapSwapRouterAddress(chainId: chainId);
      String routerAbi = await getUniswapSwapRouterAbi();
      DeployedContract contract = await _tokenFactory.intContract(routerAbi, routerAddress, "Router");
      final exactInputSingle = contract.function("exactInputSingle");
      final credentials = await _tokenFactory.getCredentials(privateKey);
      // BigInt poolFee = await swapController.getPoolFee(pair: pair,poolAddress: pair.poolAddress, poolAbi: pair.poolAbi);
      List<dynamic> params = [
        [EthereumAddress.fromHex(pair.token0.contractAddress!), EthereumAddress.fromHex(pair.token1.contractAddress!), poolFee, EthereumAddress.fromHex(credentials.address.with0x), amountIn, amountOutMin, BigInt.zero],
      ];
      final gasPrice = EtherAmount.inWei(fee.gasPrice);
      final maxGas = fee.maxGas;
      Transaction tx = await constructTx(contract: contract, function: exactInputSingle, credentials: credentials, params: params, gasPrice: gasPrice, maxGas: maxGas);
      Uint8List signedTransaction = await web3client.signTransaction(credentials, tx, chainId: chainId, fetchChainIdFromNetworkId: false);
      String txId = await web3client.sendRawTransaction(signedTransaction);
      logger("TxId: $txId","SwapService");
      return txId;
    } catch (e) {
      logger(e.toString(),"SwapService");
      throw Exception("Unable to swap ${from.name} to ${pair.token1.name}");
    }
  }

    Future<String> tokenToNativeSwap({required CoinPair pair, required BigInt amountIn, required BigInt wethAmountMin,required NetworkFee fee, required BigInt poolFee}) async {
    try {
      logger("Token to Native","SwapService");
      TokenFactory _tokenFactory = TokenFactory();
      NetworkModel network = pair.token0.networkModel!;
      SupportedCoin pairOne = pair.token0;
      // SupportedCoin pairTwo = pair.token1;
      SupportedCoin weth = pair.weth!;

      String privateKey = pairOne.privateKey!;
      int chainId = network.chainId;
      String rpcUrl = network.rpcUrl;
      Web3Client web3client = await ClientResolver.resolveClient(rpcUrl: rpcUrl);
      String universalRouter = getUniversalRouterAddress(chainId: chainId);
      String universalRouterAbi = await getUniswapUniversalRouterAbi();
      DeployedContract contract = await _tokenFactory.intContract(universalRouterAbi, universalRouter, "universalRouter");
      //we need to call the execute function so as to run two functions together
      final execute = contract.findFunctionsByName("execute").first;
      final credentials = await _tokenFactory.getCredentials(privateKey);
      List<int> commands = [0x00, 0x0c];
      // List<int> commands=[0x0c];
      //convert the command to bytes
      var commandBytes = Uint8List.fromList(commands);
      List<String> path = [];
      if (!pair.isIntermediary) {
        path = [EthereumAddress.fromHex(pairOne.contractAddress!).with0x, EthereumAddress.fromHex(weth.contractAddress!).with0x];
      } else {
        path = [EthereumAddress.fromHex(pairOne.contractAddress!).with0x, EthereumAddress.fromHex(pair.intermediaryContract!).with0x, EthereumAddress.fromHex(weth.contractAddress!).with0x];
      }
      //Path is the list of token addresses that the swap will go through
      List<int> poolFees = [];
      if (!pair.isIntermediary) {
        poolFees = [poolFee.toInt()];
      } else {
        poolFees = [poolFee.toInt(), pair.intermediaryPoolFee.toInt()];
      }
      //This encode the path and fees then pad it to 64
      String encodedPath = MyEncoder.encodePath(path: path, fees: poolFees).padLeft(64, "0");
      logger("Encoded Path:$encodedPath","SwapService");
      //The recipient in the case of uniswap, 2 indicate the address of the contract and 1 indicate the MSG.SENDER
      String recipientMsgSender = 1.toRadixString(16).padLeft(40, "0");
      String recipientContract = 2.toRadixString(16).padLeft(40, "0");
      logger("Recipient (msg.sender): $recipientMsgSender","SwapService");
      logger("Recipient (Contract): $recipientContract","SwapService");
      // flag for whether the input tokens should come from the msg.sender (through Permit2) or whether the funds are already in the UniversalRouter
      int flag = 1;
      final v3SwapExactInputParams = [EthereumAddress.fromHex(recipientContract), amountIn, wethAmountMin, hexToBytes("0x$encodedPath"), EthereumAddress.fromHex("0x${flag.toRadixString(16).padLeft(40, "0")}")];
      // Ignore the address of the contract, we just used it so we can use the function for encoding
      final v3SwapExactInputEncoded = await encodeV3SwapExactInput(param: v3SwapExactInputParams, address: universalRouter);
      final EthereumAddress unwrapWETH9Recipient = EthereumAddress.fromHex(pairOne.walletAddress!);
      final unwrapWETH9Params = [unwrapWETH9Recipient, wethAmountMin];
      String ethAddress = 0.toRadixString(16).padLeft(40, "0");
      // final sweepParam=[
      //   EthereumAddress.fromHex(ethAddress),
      //   EthereumAddress.fromHex(from.wallet_address!),
      //   BigInt.zero
      // ];
      //Ignore the address of the contract, we just used it so we can use the function for encoding
      final unwrapWETH9Encoded = await encodeUnwrapWETH(param: unwrapWETH9Params, address: universalRouter);
      // final sweepParamEncoded=await SwapManager.encodeSweepETH(param: sweepParam, address: universalRouter);

      // List<String> inputsParams=[bytesToHex(unwrapWETH9Encoded)];
      List<String> inputsParams = [bytesToHex(v3SwapExactInputEncoded), bytesToHex(unwrapWETH9Encoded)];
      BigInt deadLine = BigInt.from(DateTime.now().add(const Duration(minutes: 5)).millisecondsSinceEpoch);
      List<dynamic> executeParams = [commandBytes, inputsParams.map(hexToBytes).toList()];
      // log(input);
      final gasPrice = EtherAmount.inWei(fee.gasPrice);
      final maxGas = fee.maxGas;
      Transaction tx = await constructTx(contract: contract, function: execute, credentials: credentials, params: executeParams, gasPrice: gasPrice, maxGas: maxGas);
      Uint8List signedTransaction = await web3client.signTransaction(credentials, tx, chainId: chainId, fetchChainIdFromNetworkId: false);
      String txId = await web3client.sendRawTransaction(signedTransaction);
      logger("TxId: $txId","SwapService");
      return txId;
    } catch (e) {
      logger(e.toString(),"SwapService");
      throw Exception("UniversalRouter -> Execute: Unable to swap ${pair.token0.name} to ${pair.token1.name}");
    }
  }
  Future<String> nativeToTokenSwap({required CoinPair pair, required String wethAddress, required BigInt amountIn, required BigInt amountOutMin, required BigInt wethAmountMin, required BigInt poolFee,required bool isIntermediary,required NetworkFee fee}) async {
    try {
      logger("Native to token","SwapService");
      TokenFactory _tokenFactory = TokenFactory();
      NetworkModel network = pair.token0.networkModel!;
      SupportedCoin pairOne = pair.token0;
      SupportedCoin pairTwo = pair.token1;
      int chainId = network.chainId;
      String rpcUrl = network.rpcUrl;
      String privateKey = pairOne.privateKey!;
      String walletAddress = pairOne.walletAddress!;
      Web3Client web3client = await ClientResolver.resolveClient(rpcUrl: rpcUrl);
      String universalRouter = getUniversalRouterAddress(chainId: chainId);
      String universalRouterAbi = await getUniswapUniversalRouterAbi();
      DeployedContract contract = await _tokenFactory.intContract(universalRouterAbi, universalRouter, "universalRouter");
      //we need to call the execute function so as to run two functions together
      final execute = contract.findFunctionsByName("execute").first;
      final credentials = await _tokenFactory.getCredentials(privateKey);
      List<int> commands = [0x0b, 0x00, 0x04];
      //convert the command to bytes
      var commandBytes = Uint8List.fromList(commands);
      List<String> path = [EthereumAddress.fromHex(wethAddress).with0x, EthereumAddress.fromHex(pairTwo.contractAddress!).with0x];
      //Path is the list of token addresses that the swap will go through
      if (!isIntermediary) {
        path = [EthereumAddress.fromHex(wethAddress).with0x, EthereumAddress.fromHex(pairTwo.contractAddress!).with0x];
      } else {
        path = [EthereumAddress.fromHex(wethAddress).with0x, EthereumAddress.fromHex(pair.intermediaryContract!).with0x, EthereumAddress.fromHex(pairTwo.contractAddress!).with0x];
      }
      List<int> poolFees = [];
      if (!isIntermediary) {
        poolFees = [poolFee.toInt()];
      } else {
        poolFees = [poolFee.toInt(), pair.intermediaryPoolFee.toInt()];
      }
      //This encode the path and fees then pad it to 64
      String encodedPath = MyEncoder.encodePath(path: path, fees: poolFees).padLeft(64, "0");
      logger("Encoded Path:$encodedPath","SwapService");
      //The recipient in the case of uniswap, 2 indicate the address of the contract and 1 indicate the MSG.SENDER
      String ethAddress = 0.toRadixString(16).padLeft(40, "0");
      String recipientMsgSender = 1.toRadixString(16).padLeft(40, "0");
      String recipientContract = 2.toRadixString(16).padLeft(40, "0");
      logger("Recipient (msg.sender): $recipientMsgSender","SwapService");
      logger("Recipient (Contract): $recipientContract","SwapService");
      // flag for whether the input tokens should come from the msg.sender (through Permit2) or whether the funds are already in the UniversalRouter
      int flag = 0;
      final v3wrapETHInputParams = [EthereumAddress.fromHex("0x$recipientContract"), amountIn];
      final v3SwapExactInputParams = [EthereumAddress.fromHex(walletAddress), amountIn, wethAmountMin, hexToBytes("0x$encodedPath"), EthereumAddress.fromHex("0x${flag.toRadixString(16).padLeft(40, "0")}")];
      final sweepParam = [EthereumAddress.fromHex(ethAddress), EthereumAddress.fromHex(walletAddress), BigInt.zero];
      //Ignore the address of the contract, we just used it so we can use the function for encoding
      final v3wrapETHInputEncoded = await encodeWrapWETH(param: v3wrapETHInputParams, address: universalRouter);
      //Ignore the address of the contract, we just used it so we can use the function for encoding
      final v3SwapExactInputEncoded = await encodeV3SwapExactInput(param: v3SwapExactInputParams, address: universalRouter);
      final sweepParamEncoded = await encodeSweepETH(param: sweepParam, address: universalRouter);

      List<String> inputsParams = [bytesToHex(v3wrapETHInputEncoded), bytesToHex(v3SwapExactInputEncoded), bytesToHex(sweepParamEncoded)];
      BigInt deadLine = BigInt.from(DateTime.now().add(const Duration(minutes: 5)).millisecondsSinceEpoch);
      List<dynamic> executeParams = [commandBytes, inputsParams.map(hexToBytes).toList()];
      // log(input);
      final gasPrice = EtherAmount.inWei(fee.gasPrice);
      final maxGas = fee.maxGas;
      Transaction tx = await constructTx(contract: contract, function: execute, credentials: credentials, params: executeParams, gasPrice: gasPrice, maxGas: maxGas, value: EtherAmount.fromBigInt(EtherUnit.wei, amountIn));
      Uint8List signedTransaction = await web3client.signTransaction(credentials, tx, chainId: chainId, fetchChainIdFromNetworkId: false);
      String txId = await web3client.sendRawTransaction(signedTransaction);
      logger("TxId: $txId","SwapService");
      return txId;
    } catch (e) {
      logger(e.toString(),"SwapService");
      throw Exception("UniversalRouter -> Execute: Unable to swap ${pair.token0.name} to ${pair.token1.name}");
    }
  }

  Future<Uint8List> encodeV3SwapExactInput({required List<dynamic> param, required String address}) async {
    try {
      logger("////////////////////////////////////////encodeV3SwapExactInput////////////////////////////////////////", "SwapService");
      //The encoded data for the swap, we use the v3SwapRouter json to encode the function with web3Dart
      String v3SwapRouter = await rootBundle.loadString("abi/uniswap/v3_swap_router.json");
      //Ignore the address of the contract, we just used it so we can use the function for encoding
      DeployedContract c = await _tokenFactory.intContract(v3SwapRouter, address, "v3SwapRouter");
      final v3SwapExactInputFunction = c.function("v3SwapExactInput");
      final data = v3SwapExactInputFunction.encodeCall(param);
      final d = bytesToHex(data);
      //This is to the function selected which is the first 4 bytes e.g 0x12345678
      final dd = hexToBytes(d.substring(8));
      logger(bytesToHex(dd), "SwapService");
      logger("////////////////////////////////////////encodeV3SwapExactInput////////////////////////////////////////", "SwapService");
      return dd;
    } catch (e) {
      logger(e.toString(), "SwapService");
      throw Exception("Could not encode V3SwapExactInput param");
    }
  }

   Future<Uint8List> encodeWrapWETH({required List<dynamic> param, required String address}) async {
    try {
      logger("////////////////////////////////////////encodeWrapWETH////////////////////////////////////////","SwapService");

      //The encoded data for the swap, we use the v3SwapRouter json to encode the function with web3Dart
      String paymentAbi = await getUniswapPaymentAbi();
      //Ignore the address of the contract, we just used it so we can use the function for encoding
      DeployedContract c = await _tokenFactory.intContract(paymentAbi, address, "paymentAbi");
      final v3SwapExactInputFunction = c.function("wrapETH");
      final data = v3SwapExactInputFunction.encodeCall(param);
      final d = bytesToHex(data);
      //This is to the function selected which is the first 4 bytes e.g 0x12345678
      final dd = hexToBytes(d.substring(8));
      logger(bytesToHex(dd),"SwapService");
      logger("////////////////////////////////////////encodeWrapWETH////////////////////////////////////////","SwapService");
      return dd;
    } catch (e) {
      logger(e.toString(),"SwapService");
      throw Exception("Could not encode encodeWrapWETH param");
    }
  }

   
   Future<Uint8List> encodeUnwrapWETH({required List<dynamic> param, required String address}) async {
    try {
      logger("////////////////////////////////////////encodeUnwrapWETH////////////////////////////////////////","SwapService");

      //The encoded data for the swap, we use the v3SwapRouter json to encode the function with web3Dart
      String paymentAbi = await getUniswapPaymentAbi();
      //Ignore the address of the contract, we just used it so we can use the function for encoding
      DeployedContract c = await _tokenFactory.intContract(paymentAbi, address, "paymentAbi");
      final v3SwapExactInputFunction = c.function("unwrapWETH9");
      final data = v3SwapExactInputFunction.encodeCall(param);
      final d = bytesToHex(data);
      //This is to the function selected which is the first 4 bytes e.g 0x12345678
      final dd = hexToBytes(d.substring(8));
      logger(bytesToHex(dd),"SwapService");
      logger("////////////////////////////////////////encodeUnwrapWETH////////////////////////////////////////","SwapService");
      return dd;
    } catch (e) {
      logger(e.toString(),"SwapService");
      throw Exception("Could not encode unwrapWETH9 param");
    }
  }


   Future<Uint8List> encodeSweepETH({required List<dynamic> param, required String address}) async {
    try {
      logger("////////////////////////////////////////sweepETH////////////////////////////////////////","SwapService");

      //The encoded data for the swap, we use the v3SwapRouter json to encode the function with web3Dart
      String paymentAbi = await getUniswapPaymentAbi();
      //Ignore the address of the contract, we just used it so we can use the function for encoding
      DeployedContract c = await _tokenFactory.intContract(paymentAbi, address, "paymentAbi");
      final v3SwapExactInputFunction = c.function("sweep");
      final data = v3SwapExactInputFunction.encodeCall(param);
      final d = bytesToHex(data);
      //This is to the function selected which is the first 4 bytes e.g 0x12345678
      final dd = hexToBytes(d.substring(8));
      logger(bytesToHex(dd),"SwapService");
      logger("////////////////////////////////////////sweepETH////////////////////////////////////////","SwapService");
      return dd;
    } catch (e) {
      logger(e.toString(),"SwapService");
      throw Exception("Could not encode sweepETH param");
    }
  }


    static Future<Uint8List> encodePermit2({required List<dynamic> param,required String permit2ContractAddress})async{
    try{
      logger("////////////////////////////////////////permit2////////////////////////////////////////","SwapService");
      final String permit2Abi = await rootBundle.loadString("abi/permit/universal_router_permit.json");
      final contract = await _tokenFactory.intContract(permit2Abi, permit2ContractAddress, "Permit2");
      final permitFunction = contract.findFunctionsByName('permit').last;
      final data=permitFunction.encodeCall(param);
      final d=bytesToHex(data);
      //This is to the function selected which is the first 4 bytes e.g 0x12345678
      final dd=hexToBytes(d.substring(8));
      logger(bytesToHex(dd),"SwapService");

      logger("////////////////////////////////////////permit2////////////////////////////////////////","SwapService");
      return dd;
    }catch(e){
      logger(e.toString(),"SwapService");
      throw Exception("Could not encode permit2 param");
    }
  }


}