import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

  static go(BuildContext context, {name,args}) async {
    context.go(name,extra: args);
  }
  static toNamed(BuildContext context, {name,args}) async {
    context.push(name,extra: args);
  }
  static Future<dynamic> awaitToNamed(BuildContext context, {name,args}) async {
    return await  context.push(name,extra: args);
  }

  static void back(BuildContext context, {args}) {
    context.pop(args);
  }

  static void backAll(BuildContext context, {name}) {
    // context.popUntil((route) => route.isFirst);
    // Navigat
  }
}
