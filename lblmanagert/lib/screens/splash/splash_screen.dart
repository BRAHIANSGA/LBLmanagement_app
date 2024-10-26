// splash_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'rocket_loading.dart';

class SplashScreen extends StatelessWidget {
  final String? token;
  final Future<void> Function()? onInit;
  final Widget Function(BuildContext) onAuthenticated;
  final Widget Function(BuildContext) onUnauthenticated;

  const SplashScreen({
    super.key,
    this.token,
    this.onInit,
    required this.onAuthenticated,
    required this.onUnauthenticated,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: onInit?.call() ?? Future.delayed(const Duration(seconds: 3)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const RocketLoading(
              backgroundColor: Colors.white,
            );
          }

          // Usando Future.microtask para la navegación
          Future.microtask(() {
            if (snapshot.hasError) {
              Get.off(() => onUnauthenticated(context));
            } else if (token == null) {
              Get.off(() => onUnauthenticated(context));
            } else {
              Get.off(() => onAuthenticated(context));
            }
          });

          // Mientras tanto, seguimos mostrando la pantalla de carga
          return const RocketLoading(
            backgroundColor: Colors.white,
          );
        },
      ),
    );
  }
}