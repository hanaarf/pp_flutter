import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pp_flutter/pages/component/bottom_navbar.dart';
import 'package:pp_flutter/pages/onBoard/IntroductionScreen.dart';
import 'package:pp_flutter/repositories/auth_repository.dart';

class SplashSecond extends StatefulWidget {
  final AuthRepository authRepository;
  const SplashSecond({super.key, required this.authRepository});

  @override
  State<SplashSecond> createState() => _SplashSecondState();
}

class _SplashSecondState extends State<SplashSecond> with TickerProviderStateMixin {
  late AnimationController _utubeController;
  late Animation<Offset> _utubeAnimation;

  late AnimationController _periwinkleController;
  late Animation<Offset> _periwinkleAnimation;

  late AnimationController _logoController;
  late Animation<double> _logoAnimation;

  late AnimationController _pillController;
  late Animation<Offset> _pillAnimation;

  late AnimationController _stairController;
  late Animation<Offset> _stairAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimationsAndNavigate();
  }

  void _initAnimations() {
    _utubeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _utubeAnimation = Tween<Offset>(
      begin: const Offset(1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _utubeController, curve: Curves.bounceOut));

    _periwinkleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _periwinkleAnimation = Tween<Offset>(
      begin: const Offset(-1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _periwinkleController, curve: Curves.bounceOut));

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _logoAnimation = CurvedAnimation(parent: _logoController, curve: Curves.bounceOut);

    _pillController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _pillAnimation = Tween<Offset>(
      begin: const Offset(3.0, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _pillController, curve: Curves.bounceOut));

    _stairController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _stairAnimation = Tween<Offset>(
      begin: const Offset(-1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _stairController, curve: Curves.bounceOut));
  }

  void _startAnimationsAndNavigate() async {
    // Mulai semua animasi
    _utubeController.forward();
    _periwinkleController.forward();
    _logoController.forward();
    _pillController.forward();
    _stairController.forward();

    // Tunggu total durasi animasi + loading token
    await Future.delayed(const Duration(milliseconds: 2500));

    final token = await widget.authRepository.getToken();

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => token != null ? BottomNavbar() : IntroductionScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _utubeController.dispose();
    _periwinkleController.dispose();
    _logoController.dispose();
    _pillController.dispose();
    _stairController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SlideTransition(
                  position: _utubeAnimation,
                  child: SvgPicture.asset('assets/splash/UTube.svg'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SlideTransition(
                  position: _periwinkleAnimation,
                  child: SvgPicture.asset('assets/splash/Periwinkle.svg'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _logoAnimation,
                  child: SvgPicture.asset('assets/splash/logo.svg'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SlideTransition(
                  position: _pillAnimation,
                  child: SvgPicture.asset('assets/splash/Pill.svg'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SlideTransition(
                  position: _stairAnimation,
                  child: SvgPicture.asset('assets/splash/stair.svg'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
