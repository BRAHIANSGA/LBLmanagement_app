// main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_pages.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/home/home_page.dart';
import 'screens/login/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'LBL Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      getPages: AppPages.routes,
      home: SplashScreen(
        token: null,
        onInit: () async {
          await Future.delayed(const Duration(seconds: 10));
        },
        onAuthenticated: (context) {
          return const HomePage();
        },
        onUnauthenticated: (context) {
          return const LoginPage();
        },
      ),
    );
  }
}