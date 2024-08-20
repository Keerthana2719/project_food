import 'dart:async';
import 'package:flutter/material.dart';
import 'intro.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Intro()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(alignment: Alignment.center, children: [
        Container(
          child: Image.asset(
            height: double.maxFinite,
            width: double.maxFinite,
            "assets/group.png",
            fit: BoxFit.cover,
          ),
        ),
        Image.asset(
          "assets/Logo.png",
          width: double.maxFinite,
          height: 120,
        ),
      ]),
    );
  }
}
