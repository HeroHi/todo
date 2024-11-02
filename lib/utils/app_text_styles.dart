import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract class AppTextStyles {
  static TextStyle bold = TextStyle(
      color: AppColors.black, fontWeight: FontWeight.w700, fontSize: 18);
  static TextStyle intermediate = TextStyle(
      color: AppColors.black, fontWeight: FontWeight.w400, fontSize: 20);
}
