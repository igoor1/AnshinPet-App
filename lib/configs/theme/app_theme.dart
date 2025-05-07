import 'package:anshinpet/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {

  static final lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary
    ),
    scaffoldBackgroundColor: AppColors.background,
    brightness: Brightness.light,
    fontFamily: 'Poppins',
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      iconTheme: IconThemeData(color: AppColors.primary)
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.background,
      selectedItemColor: AppColors.primary,
    ),
    listTileTheme: ListTileThemeData(
      textColor: AppColors.primary,
      iconColor: AppColors.primary,
    )
  );
}
