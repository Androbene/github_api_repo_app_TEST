import 'package:flutter/material.dart';
import 'package:github_api_repo_app/screens/search_screen/serch_screen.dart';
import 'package:github_api_repo_app/screens/splash_screen.dart';
import 'package:github_api_repo_app/themes/app_colors.dart';
import 'constants/route_names.dart';

class GitHubApiApp extends StatelessWidget {
  const GitHubApiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: runtimeType.toString(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          backgroundColor: AppColors.main,
          canvasColor: AppColors.main,
          primaryColor: AppColors.main,
          fontFamily: 'Raleway'),
      initialRoute: Routes.splash,
      onGenerateRoute: _generateRoute,
    );
  }

  Route<dynamic> _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.search:
        return PageRouteBuilder(
          pageBuilder: (context, __, ___) => SearchScreen(),
          transitionsBuilder: (context, animation, __, child) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          settings: settings,
        );
      default:
        return PageRouteBuilder(
          pageBuilder: (context, __, ___) => const SplashScreen(),
          transitionsBuilder: (context, animation, __, child) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          settings: settings,
        );
    }
  }
}
