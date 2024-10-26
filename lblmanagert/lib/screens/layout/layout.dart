import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lblmanagert/widgets/custom_drawer.dart';


class BaseLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final List<Widget>? actions;
  final FloatingActionButton? floatingActionButton;

  const BaseLayout({
    super.key,
    required this.child,
    required this.title,
    this.actions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue.shade900,
        elevation: 0,
        actions: actions,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const CustomDrawer(),
      body: child,
      floatingActionButton: floatingActionButton,
    );
  }
}