import 'package:flutter/material.dart';
import 'package:todo_app/utils/app_colors.dart';
import 'package:todo_app/utils/app_text_styles.dart';

abstract class AppThemes {
  static ThemeData lightTheme = ThemeData(
      primaryColor: AppColors.white,
      primaryColorLight: AppColors.scaffoldBgColor,
      primaryColorDark: AppColors.black,
      scaffoldBackgroundColor: AppColors.scaffoldBgColor,
      appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          titleTextStyle:
              AppTextStyles.bold.copyWith(color: AppColors.white, fontSize: 22),
          titleSpacing: 51),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        shape: CircleBorder(side: BorderSide(color: AppColors.white, width: 4)),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: AppTextStyles.intermediate
            .copyWith(color: AppColors.primary, fontSize: 14),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: AppColors.white,
          filled: true,
        ),
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(AppColors.white),
        ),
      ),
      textTheme: TextTheme(
        titleLarge: AppTextStyles.bold.copyWith(color: AppColors.black),
        titleMedium: AppTextStyles.intermediate,
        labelMedium: AppTextStyles.intermediate
            .copyWith(color: AppColors.hintColor, fontSize: 20),
      ));
  static ThemeData darkTheme = ThemeData(
      primaryColor: AppColors.darkAccent,
      primaryColorLight: AppColors.richBlack,
      primaryColorDark: AppColors.white,
      scaffoldBackgroundColor: AppColors.richBlack,
      appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          titleTextStyle: AppTextStyles.bold
              .copyWith(color: AppColors.richBlack, fontSize: 22),
          titleSpacing: 51),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        shape: CircleBorder(
            side: BorderSide(color: AppColors.transparent, width: 4)),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: AppTextStyles.intermediate
            .copyWith(color: AppColors.primary, fontSize: 14),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: AppColors.white,
          filled: true,
        ),
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(AppColors.white),
        ),
      ),
      textTheme: TextTheme(
        displayMedium: AppTextStyles.bold.copyWith(color: AppColors.primary),
        titleLarge: AppTextStyles.bold.copyWith(color: AppColors.white),
        titleMedium:
            AppTextStyles.intermediate.copyWith(color: AppColors.white),
        labelMedium: AppTextStyles.intermediate
            .copyWith(color: AppColors.darkHintColor, fontSize: 20),
      ));
}
