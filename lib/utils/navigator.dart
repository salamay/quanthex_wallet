import 'package:flutter/material.dart';

class Navigate {
  // static void push(BuildContext context, String routeName) {
  //   Navigator.of(context).pushNamed(routeName);
  // }

  // static void pushReplacement(BuildContext context, String routeName) {
  //   Navigator.of(context).pushReplacementNamed(routeName);
  // }

  // static void pop(BuildContext context) {
  //   Navigator.of(context).pop();
  // }

  static toNamed(BuildContext context, {name}) async {
    return await Navigator.of(context).pushNamed(name);
  }

  static void back(BuildContext context, {name}) {
    Navigator.pop(context);
  }
}
