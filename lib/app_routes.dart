import 'package:flutter/material.dart';
import 'package:yweed_counter_plus/pages/home_page.dart';
import 'package:yweed_counter_plus/pages/camera_page.dart';
import 'package:yweed_counter_plus/pages/result_page.dart';
import 'package:yweed_counter_plus/pages/summary_page.dart';
import 'package:yweed_counter_plus/pages/settings_page.dart';
import 'package:yweed_counter_plus/splash_screen.dart';
import 'package:yweed_counter_plus/utils/aggregator.dart';
import 'package:yweed_counter_plus/pages/info_page.dart'; 

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String camera = '/camera';
  static const String results = '/results';
  static const String summary = '/summary';
  static const String settings = '/settings';
  static const String info = '/info';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final routeName = settings.name ?? '';

    if (routeName == splash) {
      return MaterialPageRoute(builder: (_) => const SplashScreen());
    } else if (routeName == home) {
      return MaterialPageRoute(builder: (_) => const HomePage());
    } else if (routeName == camera) {
      return MaterialPageRoute(builder: (_) => const CameraPage());
    } else if (routeName == results) {
      final args = settings.arguments;
      return MaterialPageRoute(
        builder: (_) => ResultPage(imagePaths: (args is List<String>) ? args : []),
      );
    } else if (routeName == summary) {
      final args = settings.arguments;
      return MaterialPageRoute(
        builder: (_) => SummaryPage(aggregator: (args is DetectionAggregator) ? args : DetectionAggregator(), thresholds: {},),
      );
    } else if (routeName == settings) {
      return MaterialPageRoute(builder: (_) => const SettingsPage());
    } else if (routeName == info) {
      return MaterialPageRoute(builder: (_) => const InfoPage());
    } else {
      return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(child: Text('Page not found')),
      ),
    );
  }
}
