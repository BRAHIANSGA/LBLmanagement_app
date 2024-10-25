import 'package:flutter/material.dart';
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
    
    return FutureBuilder(
      future: onInit?.call() ?? Future.delayed(const Duration(seconds: 3)),
      builder: (context, snapshot) {

        print("SplashScreen state: ${snapshot.connectionState}");
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const RocketLoading(
            backgroundColor: Colors.white, 
          );
        } else if (snapshot.hasError) {
          print("Error in SplashScreen: ${snapshot.error}");
          return onUnauthenticated(context);
        }

        if (token == null) {
          return onUnauthenticated(context);
        }

        return onAuthenticated(context);
      },
    );
  }
}