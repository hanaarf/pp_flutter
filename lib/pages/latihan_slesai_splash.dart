import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart'; 
import 'package:pp_flutter/pages/latihan_materi.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pp_flutter/blocs/latMateri/latMat_bloc.dart';
import 'package:pp_flutter/blocs/latMateri/latMat_event.dart';
import 'package:pp_flutter/pages/reward_splash.dart';
import 'package:pp_flutter/repositories/siswa_repositori.dart';
import 'package:pp_flutter/repositories/auth_repository.dart';

class LatihanSelesaiSplash extends StatefulWidget {
  final int xpSebelum;
  const LatihanSelesaiSplash({Key? key, required this.xpSebelum}) : super(key: key);

  @override
  State<LatihanSelesaiSplash> createState() => _LatihanSelesaiSplashState();
}

class _LatihanSelesaiSplashState extends State<LatihanSelesaiSplash> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      handleAfterLatihan(context);
    });
  }

  Future<void> handleAfterLatihan(BuildContext context) async {
    final profile = await AuthRepository().getProfile();
    int xpSesudah = profile.xpTotal ?? 0;
    final milestones = [200, 400, 600];
    int? streakMilestone;
    for (final m in milestones) {
      if (widget.xpSebelum < m && xpSesudah >= m) {
        streakMilestone = m;
        break;
      }
    }
    if (streakMilestone != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => RewardSplash(xp: streakMilestone!),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => LatihanMateriBloc(SiswaRepositori())..add(FetchLatihanMateri()),
            child: LatihanMateriPage(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F4F4),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie/success.json',
              width: 300,
              height: 300,
              repeat: false,
            ),
            const SizedBox(height: 24),
            Text(
              'Latihan Selesai',
              style: GoogleFonts.quicksand(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
