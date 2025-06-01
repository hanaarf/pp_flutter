import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart'; 
import 'package:pp_flutter/pages/latihan_materi.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pp_flutter/blocs/latMateri/latMat_bloc.dart';
import 'package:pp_flutter/blocs/latMateri/latMat_event.dart';
import 'package:pp_flutter/repositories/siswa_repositori.dart';

class RewardSplash extends StatefulWidget {
  final int xp;
  const RewardSplash({Key? key, required this.xp}) : super(key: key);

  @override
  State<RewardSplash> createState() => _RewardSplashState();
}

class _RewardSplashState extends State<RewardSplash> {
  String getLottieAsset() {
    switch (widget.xp) {
      case 200:
        return 'assets/lottie/reward200.json';
      case 400:
        return 'assets/lottie/reward400.json';
      case 600:
        return 'assets/lottie/reward600.json';
      default:
        return 'assets/lottie/reward.json'; 
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => LatihanMateriBloc(SiswaRepositori())..add(FetchLatihanMateri()),
            child: LatihanMateriPage(),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F4F4),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                getLottieAsset(),
                width: 250,
                height: 250,
                repeat: false,
              ),
              const SizedBox(height: 24),
              Text(
                'Horee! Kamu baru saja mendapatkan  ${widget.xp} XP!',
                style: GoogleFonts.quicksand(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
