import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'overlays.dart';

ThemeData createLightTheme() {
  return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.main,
        surfaceTintColor: AppColors.main,
        systemOverlayStyle: lightStatusBar,
      ),
      colorScheme: const ColorScheme.light(
        background: AppColors.main,
        primary: AppColors.primary,
      ),
      useMaterial3: true,
      fontFamily: 'Raleway');
}
