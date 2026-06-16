const String bnb = "BNB";
const String bsc = "BSC";
const String pol = "POL";
const String eth = "ETH";

// ─────────────────────────────────────────────────────────────
//  Ethereum (Chain ID 1) — Top 30 ERC-20 Tokens
// ─────────────────────────────────────────────────────────────
const String eth_usdt_contract = "0xdAC17F958D2ee523a2206206994597C13D831ec7";
const String eth_usdc_contract = "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48";
const String eth_weth_contract = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2";
const String eth_wbtc_contract = "0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599";
const String eth_dai_contract = "0x6B175474E89094C44Da98b954EedeAC495271d0F";
const String eth_link_contract = "0x514910771AF9Ca656af840dff83E8264EcF986CA";
const String eth_uni_contract = "0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984";
const String eth_shib_contract = "0x95aD61b0a150d79219dCF64E1E6Cc01f0B64C4cE";
const String eth_pepe_contract = "0x6982508145454Ce325dDbE47a25d4ec3d2311933";
const String eth_arb_contract = "0xB50721BCf8d664c30412Cfbc6cf7a15145234ad1";
const String eth_mkr_contract = "0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2";
const String eth_aave_contract = "0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9";
const String eth_ldo_contract = "0x5A98FcBEA516Cf06857215779Fd812CA3beF1B32";
const String eth_wsteth_contract = "0x7f39C581F595B53c5cb19bD0b3f8dA6c935E2Ca0";
const String eth_grt_contract = "0xc944E90C64B2c07662A292be6244BDf05Cda44a7";
const String eth_rndr_contract = "0x6De037ef9aD2725EB40118Bb1702EBb27e4Aeb24";
const String eth_imx_contract = "0xF57e7e7C23978C3cAEC3C3548E3D615c346e79fF";
const String eth_fet_contract = "0xaea46A60368A7bD060eec7DF8CBa43b7EF41Ad85";
const String eth_sand_contract = "0x3845badAde8e6dFF049820680d1F14bD3903a5d0";
const String eth_ape_contract = "0x4d224452801ACEd8B2F0aebE155379bb5D594381";
const String eth_cro_contract = "0xA0b73E1Ff0B80914AB6fe0444E65848C4C34450b";
const String eth_mana_contract = "0x0F5D2fB29fb7d3CFeE444a200298f468908cC942";
const String eth_snx_contract = "0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F";
const String eth_ens_contract = "0xC18360217D8F7Ab5e7c516566761Ea12Ce7F9D72";
const String eth_comp_contract = "0xc00e94Cb662C3520282E6f5717214004A7f26888";
const String eth_1inch_contract = "0x111111111117dC0aa78b770fA6A738034120C302";
const String eth_ftm_contract = "0x4E15361FD6b4BB609Fa63C81A2be19d873717870";
const String eth_dydx_contract = "0x92D6C1e31e14520e676a687F0a93788B716BEff5";
const String eth_floki_contract = "0xcf0C122c6b73ff809C693DB761e7BaeBe62b6a2E";
const String eth_wld_contract = "0x163f8C2467924be0ae7B5347228CABF260318753";

/// All Ethereum token addresses in one list.
const List<String> ethTokenAddresses = [
  eth_usdt_contract, eth_usdc_contract, eth_weth_contract, eth_wbtc_contract,
  eth_dai_contract, eth_link_contract, eth_uni_contract, eth_shib_contract,
  eth_pepe_contract, eth_arb_contract, eth_mkr_contract, eth_aave_contract,
  eth_ldo_contract, eth_wsteth_contract, eth_grt_contract, eth_rndr_contract,
  eth_imx_contract, eth_fet_contract, eth_sand_contract, eth_ape_contract,
  eth_cro_contract, eth_mana_contract, eth_snx_contract, eth_ens_contract,
  eth_comp_contract, eth_1inch_contract, eth_ftm_contract, eth_dydx_contract,
  eth_floki_contract, eth_wld_contract,
];

// ─────────────────────────────────────────────────────────────
//  BSC / BNB Smart Chain (Chain ID 56) — Top 30 BEP-20 Tokens
// ─────────────────────────────────────────────────────────────
const String bsc_usdt_contract = "0x55d398326f99059fF775485246999027B3197955";
const String bsc_usdc_contract = "0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d";
const String bsc_wbnb_contract = "0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c";
const String bsc_btcb_contract = "0x7130d2A12B9BCbFAe4f2634d864A1Ee1Ce3Ead9c";
const String bsc_eth_contract = "0x2170Ed0880ac9A755fd29B2688956BD959F933F8";
const String bsc_busd_contract = "0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56";
const String bsc_dai_contract = "0x1AF3F329e8BE154074D8769D1FFa4eE058B1DBc3";
const String bsc_cake_contract = "0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82";
const String bsc_dot_contract = "0x7083609fCE4d1d8Dc0C979AAb8c869Ea2C873402";
const String bsc_link_contract = "0xF8A0BF9cF54Bb92F17374d9e9A321E6a111a51bD";
const String bsc_xrp_contract = "0x1D2F0da169ceB9fC7B3144628dB156f3F6c60dBE";
const String bsc_ada_contract = "0x3EE2200Efb3400fAbB9AacF31297cBdD1d435D47";
const String bsc_doge_contract = "0xbA2aE424d960c26247Dd6c32edC70B295c744C43";
const String bsc_trx_contract = "0xCE7de646e7208a4Ef112cb6ed5038FA6cC6b12e3";
const String bsc_uni_contract = "0xBf5140A22578168FD562DCcF235E5D43A02ce9B1";
const String bsc_avax_contract = "0x1CE0c2827e2eF14D5C4f29a091d735A204794041";
const String bsc_matic_contract = "0xCC42724C6683B7E57334c4E856f4c9965ED682bD";
const String bsc_aave_contract = "0xfb6115445Bff7b52FeB98650C87f44907E58f802";
const String bsc_shib_contract = "0x2859e4544C4bB03966803b044A93563Bd2D0DD4D";
const String bsc_floki_contract = "0xfb5B838b6cfEEdC2873aB27866079AC55363D37E";
const String bsc_pepe_contract = "0x25d887Ce7a35172C62FeBFD67a1856F20FaEbB00";
const String bsc_fil_contract = "0x0D8Ce2A99Bb6e3B7Db580eD848240e4a0F9aE153";
const String bsc_ltc_contract = "0x4338665CBB7B2485A8855A139b75D5e34AB0DB94";
const String bsc_atom_contract = "0x0Eb3a705fc54725037CC9e008bDede697f62F335";
const String bsc_etc_contract = "0x3d6545b08693daE087E957cb1180ee38B9e3c25E";
const String bsc_xvs_contract = "0xcF6BB5389c92Bdda8a3747Ddb454cB7a64626C63";
const String bsc_bake_contract = "0xE02dF9e3e622DeBdD69fb838bB799E3F168902c5";
const String bsc_alpaca_contract = "0x8F0528cE5eF7B51152A59745bEfDD91D97091d2F";
const String bsc_inj_contract = "0xa2B726B1145A4773F68CBA5Cd2c5981b1f5d84Fa";
const String bsc_woo_contract = "0x4691937a7508860F876c9c0a2a617E7d9E945D4B";

/// All BSC token addresses in one list.
const List<String> bscTokenAddresses = [
  bsc_usdt_contract, bsc_usdc_contract, bsc_wbnb_contract, bsc_btcb_contract,
  bsc_eth_contract, bsc_busd_contract, bsc_dai_contract, bsc_cake_contract,
  bsc_dot_contract, bsc_link_contract, bsc_xrp_contract, bsc_ada_contract,
  bsc_doge_contract, bsc_trx_contract, bsc_uni_contract, bsc_avax_contract,
  bsc_matic_contract, bsc_aave_contract, bsc_shib_contract, bsc_floki_contract,
  bsc_pepe_contract, bsc_fil_contract, bsc_ltc_contract, bsc_atom_contract,
  bsc_etc_contract, bsc_xvs_contract, bsc_bake_contract, bsc_alpaca_contract,
  bsc_inj_contract, bsc_woo_contract,
];

// ─────────────────────────────────────────────────────────────
//  Polygon (Chain ID 137) — Top 30 Tokens
// ─────────────────────────────────────────────────────────────
const String polygon_usdt_contract = "0xc2132D05D31c914a87C6611C10748AEb04B58e8F";
const String polygon_usdc_contract = "0x3c499c542cEF5E3811e1192ce70d8cC03d5c3359";
const String polygon_usdce_contract = "0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174";
const String polygon_weth_contract = "0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619";
const String polygon_wbtc_contract = "0x1BFD67037B42Cf73acF2047067bd4F2C47D9BfD6";
const String polygon_dai_contract = "0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063";
const String polygon_wpol_contract = "0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270";
const String polygon_link_contract = "0x53E0bca35eC356BD5ddDFebbD1Fc0fD03FaBad39";
const String polygon_aave_contract = "0xD6DF932A45C0f255f85145f286eA0b292B21C90B";
const String polygon_uni_contract = "0xb33EaAd8d922B1083446DC23f610c2567fB5180f";
const String polygon_sand_contract = "0xBbba073C31bF03b8ACf7c28EF0738DeCF3695683";
const String polygon_mana_contract = "0xA1c57f48F0Deb89f569dFbE6E2B7f46D33606fD4";
const String polygon_grt_contract = "0x5fe2B58c013d7601147DcDD68C143A77499f5531";
const String polygon_crv_contract = "0x172370d5Cd63279eFa6d502DAB29171933a610AF";
const String polygon_bal_contract = "0x9a71012B13CA4d3D0Cdc72A177DF3ef03b0E76A3";
const String polygon_comp_contract = "0x8505b9d2254A7Ae468c0E9dd10Ccea3A837aef5c";
const String polygon_snx_contract = "0x50B728D8D964fd00C2d0AAD81718b71311feF68a";
const String polygon_sushi_contract = "0x0b3F868E0BE5597D5DB7fEB59E1CADBb0fdDa50a";
const String polygon_1inch_contract = "0x9c2C5fd7b07E95EE044DDeba0E97a665F142394f";
const String polygon_bnb_contract = "0x3BA4c387f786bFEE076A58914F5Bd38d668B42c3";
const String polygon_doge_contract = "0x12E96C2BFEA6E835CF8Dd38a5834fa61Cf723736";
const String polygon_orio_contract = "0xAC1Cd197931810b6f115D690c72a3438990D3Ba3";
const String polygon_fib_contract = "0x2b3b16826719bf0b494c8ddebaa5e882093ee37e";
const String polygon_ghst_contract = "0x385Eeac5cB85A38A9a07A70c73e0a3271CfB54A7";
const String polygon_quick_contract = "0xB5C064F955D8e7F38fE0460C556a72987494eE17";
const String polygon_stg_contract = "0x2F6F07CDcf3588944Bf4C42aC74ff24bF56e7590";
const String polygon_tel_contract = "0xdF7837DE1F2Fa4631D716CF2502f8b230F1dcc32";
const String polygon_frax_contract = "0x45c32fA6DF82ead1e2EF74d17b76547EDdFaFF89";
const String polygon_ldo_contract = "0xC3C7d422809852031b44ab29EEC9F1EfF2A58756";
const String polygon_woo_contract = "0x1B815d120B3eF02039Ee11dC2d33DE7aA4a8C603";

/// All Polygon token addresses in one list.
const List<String> polygonTokenAddresses = [
  polygon_usdt_contract, polygon_usdc_contract, polygon_usdce_contract,
  polygon_weth_contract, polygon_wbtc_contract, polygon_dai_contract,
  polygon_wpol_contract, polygon_link_contract, polygon_aave_contract,
  polygon_uni_contract, polygon_sand_contract, polygon_mana_contract,
  polygon_grt_contract, polygon_crv_contract, polygon_bal_contract,
  polygon_comp_contract, polygon_snx_contract, polygon_sushi_contract,
  polygon_1inch_contract, polygon_bnb_contract, polygon_doge_contract,
  polygon_orio_contract, polygon_fib_contract, polygon_ghst_contract,
  polygon_quick_contract, polygon_stg_contract, polygon_tel_contract,
  polygon_frax_contract, polygon_ldo_contract, polygon_woo_contract,
];
