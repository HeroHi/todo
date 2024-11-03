import 'package:flutter/material.dart';

import '../home/home.dart';

class Splash extends StatelessWidget {
  static const String routeName = "splash";

  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 3),
      () {
        Navigator.pushReplacementNamed(context, Home.routeName);
      },
    );
    return Scaffold(
      body: Center(
        child: Image.asset("assets/images/logo.png"),
      ),
    );
  }
}
