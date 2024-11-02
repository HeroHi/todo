import 'dart:ui';

import 'package:fluttertoast/fluttertoast.dart';

import '../utils/app_colors.dart';

void showToast({required String msg, required Color color}) {
  Fluttertoast.showToast(
      msg: msg,
      backgroundColor: AppColors.doneColor,
      gravity: ToastGravity.CENTER,
      toastLength: Toast.LENGTH_SHORT);
}
