import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_api_repo_app/themes/styles.dart';
import '../constants/route_names.dart';
import '../themes/app_colors.dart';
import '../themes/overlays.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    launchWhenInitialized(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        elevation: 0,
        systemOverlayStyle: blueStatusBar,
      ),
      body: Container(
        color: AppColors.primary,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  "Search App",
                  style: AppStyles.textSplash,
                ),
              ),
              CupertinoActivityIndicator(
                color: AppColors.progressCupertino,
                radius: 14.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future launchWhenInitialized(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacementNamed(context, Routes.search);
  }
}
