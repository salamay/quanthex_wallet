import 'package:share_plus/share_plus.dart';

class ShareUtils{

  static void shareContent({required String title, required String subject, required String url}) {
    // Implementation for sharing content
    SharePlus.instance.share(
        ShareParams(
          title: "Echo",
          subject: "Chat made simple",
          uri: Uri.parse(url),
          // text: 'Discover the ultimate convenience with our app! Manage your profile, customize settings, and securely handle your wallet all in one place. Stay informed with our privacy policy and share the app with friends. Download now and experience seamless functionality!'
        )
    );
  }
}