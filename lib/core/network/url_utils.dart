class UrlUtils{

  static bool isNetworkUrl(String imageUrl) {
    final networkUrlPattern = RegExp(r'^(http|https)://');
    return networkUrlPattern.hasMatch(imageUrl);
  }
}