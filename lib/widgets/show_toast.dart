import 'dart:ui';

import 'package:fluttertoast/fluttertoast.dart';


void showToast({
  required String msg,
  required Color color,
}) {
  Fluttertoast.showToast(
      msg: msg,
      backgroundColor: color,
      gravity: ToastGravity.SNACKBAR,
      toastLength: Toast.LENGTH_SHORT);
}
