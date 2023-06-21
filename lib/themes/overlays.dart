import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

const lightStatusBar = SystemUiOverlayStyle(
  statusBarColor: AppColors.main,
  statusBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.light,
);

const blueStatusBar = SystemUiOverlayStyle(
  statusBarColor: AppColors.primary,
  statusBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.dark,
);

const darkStatusBar = SystemUiOverlayStyle(
  statusBarColor: Colors.brown,
  statusBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.dark,
);