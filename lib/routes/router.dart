import 'dart:developer';

import 'package:flutter/material.dart';

import '../constants/common_no_data_error.dart';
import '../pages/history_page.dart';
import '../pages/home_page.dart';

import 'routes_path.dart';

Route<dynamic> generateRoutes(RouteSettings settings) {
  log('xxxx ROUTE : ${settings.name}');

  switch (settings.name) {
    case Routes.HISTORY:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const HistoryPage(),
      );

    case Routes.HOME:
      final String argument = settings.arguments as String;
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => HomePage(
          selectedType: argument,
        ),
      );

    default:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => CommonNoDataError(text: 'Page Not Found'),
      );
  }
}
