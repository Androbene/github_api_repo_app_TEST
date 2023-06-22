import 'package:flutter/material.dart';
import 'package:github_api_repo_app/themes/overlays.dart';

import 'app_colors.dart';

ThemeData createDarkTheme() {
  return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.brown,
        surfaceTintColor: Colors.brown,
        systemOverlayStyle: darkStatusBar,
        titleSpacing: 0,
        elevation: 1.5,
        shadowColor: Colors.black,
      ),
      colorScheme: const ColorScheme.dark(
        background: Colors.brown,
        primary: Colors.brown,
      ),
      useMaterial3: true,
      fontFamily: 'Raleway');
}
