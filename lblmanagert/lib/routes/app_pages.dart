import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:lblmanagert/screens/monitoring/machine_details_page.dart';
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
    GetPage(
      name: Routes.MACHINEDETAILS,
      page: () => MachineDetailsPage(),
      transition: Transition.cupertino,
    ),
    // Agrega más páginas según necesites
  ];
}