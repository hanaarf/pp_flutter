import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pp_flutter/pages/splash_second.dart';
import 'package:pp_flutter/repositories/auth_repository.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _circleController;
  late Animation<double> _circleAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  Color _backgroundColor = Color(0xffFAAE2B);

  @override
  void initState() {
    super.initState();

    // bounce circle
    _circleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _circleAnimation = Tween<double>(begin: 1.0, end: 0.08).animate(
      CurvedAnimation(
        parent: _circleController,
        curve: Curves.bounceOut,
      ),
    );

    // fade out circle
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeOut,
      ),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      _circleController.forward();
    });

    Future.delayed(const Duration(milliseconds: 1800), () {
      setState(() {
        _backgroundColor = Colors.white;
      });
    });

    Future.delayed(const Duration(milliseconds: 2400), () {
      _fadeController.forward();
    });

    Future.delayed(const Duration(milliseconds: 3300), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SplashSecond(authRepository: AuthRepository())),
      );
    });
  }

  @override
  void dispose() {
    _circleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: AnimatedBuilder(
            animation: _circleController,
            builder: (context, child) {
              final safeSize = max(0.0, _circleAnimation.value);
              return Container(
                width: MediaQuery.of(context).size.width * safeSize,
                height: MediaQuery.of(context).size.height * safeSize,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffFAAE2B),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
