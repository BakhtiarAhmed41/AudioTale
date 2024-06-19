import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

void toastMessage(String message, Color color){
  Fluttertoast.showToast(
  msg: message,
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.BOTTOM,
  timeInSecForIosWeb: 1,
  backgroundColor: color,
  textColor: Colors.white,
  fontSize: 16.0
  );
}