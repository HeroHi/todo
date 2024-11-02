import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/utils/app_colors.dart';

class ThemeProvider extends ChangeNotifier {
  late SharedPreferences userPrefs;
  bool isDark = false;

  ThemeProvider() {
    loadThemePref();
  }

  void setThemePref(bool isDark) async {
    userPrefs = await SharedPreferences.getInstance();
    await userPrefs.setBool("isDark", isDark);
  }

  void loadThemePref() async {
    userPrefs = await SharedPreferences.getInstance();
    isDark = userPrefs.getBool("isDark") ?? false;
    notifyListeners();
  }

  ThemeMode get themeMode => isDark ? ThemeMode.dark : ThemeMode.light;

  Color get bottomNavBarIconColor =>
      isDark ? AppColors.white : AppColors.bottomNavBarIconColor;

  void toggleTheme() {
    isDark = !isDark;
    setThemePref(isDark);
    notifyListeners();
  }
}
