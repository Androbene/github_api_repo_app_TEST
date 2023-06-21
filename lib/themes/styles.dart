import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class AppStyles {
  static const textHeader = TextStyle(
    fontSize: 16,
    fontFamily: 'Raleway',
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    decoration: TextDecoration.none,
  );
  static const textHeaderBlue = TextStyle(
    fontSize: 16,
    fontFamily: 'Raleway',
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    decoration: TextDecoration.none,
  );
  static const textBody = TextStyle(
    fontSize: 14,
    fontFamily: 'Raleway',
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    decoration: TextDecoration.none,
  );
  static const textHolder = TextStyle(
    fontSize: 14,
    fontFamily: 'Raleway',
    fontWeight: FontWeight.w400,
    color: AppColors.textPlaceholder,
    decoration: TextDecoration.none,
  );
  static const textSplash = TextStyle(
    fontSize: 16,
    fontFamily: 'Raleway',
    fontWeight: FontWeight.w600,
    color: AppColors.layer1,
    decoration: TextDecoration.none,
  );
}
