import 'package:intl/intl.dart';

class MyDateUtils{

  static String dateToSingleFormat(DateTime dateTime){
    final timeNow=DateTime.fromMillisecondsSinceEpoch(dateTime.millisecondsSinceEpoch);
    String date = DateFormat('yyyy-MM-dd').format(timeNow);
    return date;
  }
  static String dateToSingleFormatWithTime(DateTime dateTime,bool isUtc){
    final timeNow=DateTime.fromMillisecondsSinceEpoch(dateTime.millisecondsSinceEpoch,isUtc: isUtc);
    String date = DateFormat('yyyy-MM-dd h:mm a').format(timeNow);
    return date;
  }
  static String dayOnly(DateTime dateTime,bool isUtc){
    final timeNow=DateTime.fromMillisecondsSinceEpoch(dateTime.millisecondsSinceEpoch,isUtc: isUtc);
    String date = DateFormat('dd/HH/mm').format(timeNow);
    return date;
  }

  static String hourTime(DateTime dateTime){
    String date = DateFormat('h:mm a').format(dateTime);
    return date;
  }

  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} h ago';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE').format(date);
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }


  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }


  static String formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();

    if (isSameDay(date, now)) return "Today";
    if (isSameDay(date, now.subtract(Duration(days: 1)))) return "Yesterday";

    return DateFormat('E, d MMM h:mm a').format(date);
  }

  static int nowCustom(){
    return (DateTime.now().millisecondsSinceEpoch/1000).toInt();
  }

}