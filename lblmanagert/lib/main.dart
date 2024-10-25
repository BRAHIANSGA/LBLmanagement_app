import 'package:flutter/material.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/home/home_page.dart';
import 'screens/login/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Añadimos esto para asegurar la inicialización
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: true, // Mantenemos esto para debug
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
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