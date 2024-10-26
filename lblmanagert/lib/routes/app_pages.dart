import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../screens/home/home_page.dart';
import '../screens/monitoring/monitoring_page.dart';
// Importa otras páginas según necesites

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomePage(),
    ),
    GetPage(
      name: Routes.MONITORING,
      page: () => const MonitoringPage(),
    ),
    // Agrega más páginas según necesites
  ];
}