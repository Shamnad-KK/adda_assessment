import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppPopups {
  static void showToast({required String msg, Color color = Colors.red}) async {
    await Fluttertoast.showToast(msg: msg, backgroundColor: color);
  }
}
