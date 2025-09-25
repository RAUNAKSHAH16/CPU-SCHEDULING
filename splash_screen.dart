import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return const RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.0,
                  colors: <Color>[
                    Colors.greenAccent,
                    Colors.cyanAccent,
                    Colors.transparent
                  ],
                  stops: [0.1, 0.8, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcATop,
              child: Lottie.asset(
                'assets/animations/AI_animation.json',
                height: 220,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'CPU Scheduling Visualizer',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                foreground: Paint()
                  ..shader = const LinearGradient(
                    colors: [
                      Colors.greenAccent,
                      Colors.cyanAccent,
                      Colors.lightBlueAccent,
                    ],
                  ).createShader(const Rect.fromLTWH(0.0, 0.0, 300.0, 70.0)),
                shadows: const [
                  Shadow(
                    blurRadius: 12.0,
                    color: Colors.greenAccent,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Simulating Algorithms...',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
