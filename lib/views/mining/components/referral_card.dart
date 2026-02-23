import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quanthex/core/network/Api_url.dart';
import 'package:quanthex/data/utils/share/share_utils.dart';
import 'package:quanthex/views/mining/mining_view.dart';

class ReferralCard extends StatelessWidget {
  ReferralCard({super.key, required this.miningTag});
  String miningTag;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: greenColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              miningTag,
              style: TextStyle(color: Colors.white, fontSize: 13.sp, fontFamily: 'Satoshi', fontWeight: FontWeight.w500),
            ),
          ),
          10.horizontalSpace,
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: miningTag));
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Link copied')));
            },
            child: Icon(Icons.copy, size: 20.sp, color: kAccentPurple),
          ),
          10.horizontalSpace,
          GestureDetector(
            onTap: () async {
              String desc = "Invite your friends and earn mining outputs when they join and start mining. The more you refer, the more you earn!. Start sharing and grow your minigs effortlessly";
              ShareUtils.shareContent(title: miningTag, subject: desc, url: ApiUrls.quanthexWebsite);
            },
            child: Icon(Icons.share, size: 20.sp, color: kAccentPurple),
          ),
        ],
      ),
    );
  }
}