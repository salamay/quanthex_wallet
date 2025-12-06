import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/utils/navigator.dart';
import 'package:quanthex/widgets/app_button.dart';

class EthereumDetailView extends StatefulWidget {
  const EthereumDetailView({super.key});

  @override
  State<EthereumDetailView> createState() => _EthereumDetailViewState();
}

class _EthereumDetailViewState extends State<EthereumDetailView> {
  String _selectedTimeframe = '1W';
  bool _isFavorited = false;

  final List<String> _timeframes = ['1D', '1W', '1M', '6M', '1Y', 'ALL'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.sp.verticalSpace,
                // Header
                Row(
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

                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isFavorited = !_isFavorited;
                        });
                      },
                      child: Container(
                        width: 41.sp,
                        height: 41.sp,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 9,
                        ),
                        decoration: ShapeDecoration(
                          color: const Color(0x7CDADADA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.50),
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            _isFavorited ? Icons.star : Icons.star_border,
                            size: 19.sp,
                            color: _isFavorited
                                ? Colors.amber
                                : const Color(0xFF2D2D2D),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                20.sp.verticalSpace,

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/eth_logo.png',
                      width: 20.sp,
                      height: 20.sp,
                    ),
                    8.horizontalSpace,
                    Text(
                      'Ethereum',
                      style: TextStyle(
                        color: const Color(0xFF2D2D2D),
                        fontSize: 18.sp,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                // Price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$3,088.07',
                      style: TextStyle(
                        color: const Color(0xFF2D2D2D),
                        fontSize: 32.sp,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    15.horizontalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '24h Change',
                          style: TextStyle(
                            color: const Color(0xFF757575),
                            fontSize: 12.sp,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        4.verticalSpace,
                        Row(
                          children: [
                            Icon(
                              Icons.trending_up,
                              size: 16.sp,
                              color: const Color(0xFF4CAF50),
                            ),
                            5.horizontalSpace,
                            Text(
                              '1.48% (24h)',
                              style: TextStyle(
                                color: const Color(0xFF4CAF50),
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
                30.sp.verticalSpace,
                // Chart Timeframe Selector
                Row(
                  children: [
                    Icon(
                      Icons.show_chart,
                      size: 20.sp,
                      color: const Color(0xFF757575),
                    ),
                    10.horizontalSpace,
                    ..._timeframes.map((timeframe) {
                      final isSelected = _selectedTimeframe == timeframe;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTimeframe = timeframe;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 8.sp),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.sp,
                            vertical: 6.sp,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF792A90)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            timeframe,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF757575),
                              fontSize: 12.sp,
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                15.sp.verticalSpace,
                // Chart Placeholder
                Container(
                  height: 200.sp,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9E6FF).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.show_chart,
                      size: 60.sp,
                      color: const Color(0xFF792A90).withOpacity(0.5),
                    ),
                  ),
                ),
                30.sp.verticalSpace,
                // Asset Balance Card
                Container(
                  // width: 333,
                  // height: 89,
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.sp,
                    vertical: 10.sp,
                  ),
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.00, 0.50),
                      end: Alignment(1.00, 0.50),
                      colors: [
                        const Color(0xFFFBF0FF),
                        const Color(0xFFE6B4F5),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 2,
                        color: const Color(0xFFEDE5F0),
                      ),
                      borderRadius: BorderRadius.circular(19),
                    ),
                  ),

                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Asset\'s Balance',
                              style: TextStyle(
                                color: const Color(0xFF393939),
                                fontSize: 12.sp,
                                fontFamily: 'Satoshi',
                                fontWeight: FontWeight.w700,
                                height: 1.83,
                                letterSpacing: -0.41,
                              ),
                            ),
                            5.sp.verticalSpace,
                            Text(
                              'Token Balance',
                              style: TextStyle(
                                color: const Color(0xFF959595),
                                fontSize: 10.sp,
                                fontFamily: 'Satoshi',
                                fontWeight: FontWeight.w500,
                                height: 2.20,
                              ),
                            ),
                            5.sp.verticalSpace,
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '0.245 ETH',
                                  style: TextStyle(
                                    color: const Color(0xFF333333),
                                    fontSize: 18.sp,
                                    fontFamily: 'Satoshi',
                                    fontWeight: FontWeight.w900,
                                    height: 1.22,
                                  ),
                                ),

                                Text(
                                  ' ≈ \$612.44',
                                  style: TextStyle(
                                    color: const Color(0xFF595959),
                                    fontSize: 12.sp,
                                    fontFamily: 'Satoshi',
                                    fontWeight: FontWeight.w700,
                                    height: 1.83,
                                    letterSpacing: -0.41,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 86,
                        height: 76,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              "assets/images/photoroomimage.png",
                            ),
                            colorFilter: ColorFilter.mode(
                              Color(0xFFE6B4F5),
                              BlendMode.colorBurn,
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                30.sp.verticalSpace,
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: 'Send',
                        textColor: Colors.white,
                        padding: EdgeInsets.all(5),
                        color: const Color(0xFF792A90),
                        onTap: () {
                          Navigate.toNamed(context, name: '/sendtokenview');
                        },
                      ),
                    ),
                    15.horizontalSpace,
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigate.toNamed(context, name: '/receiveview');
                        },
                        child: Container(
                          height: 50.sp,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9E6FF),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(
                              'Receive',
                              style: TextStyle(
                                color: const Color(0xFF792A90),
                                fontSize: 15.sp,
                                fontFamily: 'Satoshi',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    15.horizontalSpace,
                    Container(
                      width: 50.sp,
                      height: 50.sp,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9E6FF),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.swap_horiz,
                        color: const Color(0xFF792A90),
                        size: 24.sp,
                      ),
                    ),
                  ],
                ),
                30.sp.verticalSpace,
                // Tabs
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTab('Information', isSelected: true),
                    20.horizontalSpace,
                    _buildTab('History', isSelected: false),
                  ],
                ),
                20.sp.verticalSpace,
                // Information List
                _buildInfoItem('Market cap', '\$379.71B'),
                _buildInfoItem('Volume (24h)', '\$45.35B'),
                _buildInfoItem('FDV (Fully Diluted Valuation)', '\$379.04B'),
                _buildInfoItem('Vol/Mkt Cap (24h)', '11.88%'),
                _buildInfoItem('Total supply', '120.69M ETH'),
                _buildInfoItem('Max. supply', '∞'),
                _buildInfoItem('Circulating supply', '120.69M ETH'),
                _buildInfoItem('All Time Low (24h)', '\$2,948.33'),
                _buildInfoItem('All Time High (24h)', '\$3,167.93'),
                _buildInfoItem('All-time low (10 years ago)', '\$4,953.73'),
                _buildInfoItem('All Time High (3 months ago)', '\$0.4209'),
                _buildInfoItem('Website', 'ethereum.org', isLink: true),
                30.sp.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String label, {required bool isSelected}) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: isSelected
                ? const Color(0xFF2D2D2D)
                : const Color(0xFF757575),
            fontSize: 16.sp,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w600,
          ),
        ),
        8.verticalSpace,
        Container(
          width: 80.sp,
          height: 3.sp,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF792A90) : Colors.transparent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value, {bool isLink = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.sp),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: const Color(0xFFE0E0E0), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFF757575),
              fontSize: 14.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w400,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLink)
                Container(
                  width: 20.sp,
                  height: 20.sp,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 3,
                    vertical: 2,
                  ),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF2C7FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Icon(
                    Icons.copy,
                    size: 12.sp,
                    color: const Color(0xFF792A90),
                  ),
                ),
              5.horizontalSpace,
              Text(
                value,
                style: TextStyle(
                  color: const Color(0xFF2D2D2D),
                  fontSize: 14.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
