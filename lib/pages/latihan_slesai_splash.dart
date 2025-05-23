import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pp_flutter/blocs/latMateri/latMat_bloc.dart';
import 'package:pp_flutter/blocs/latMateri/latMat_event.dart';
import 'package:pp_flutter/pages/component/bottom_navbar.dart';
import 'package:pp_flutter/pages/latihan_materi.dart';
import 'package:pp_flutter/repositories/siswa_repositori.dart';

class LatihanSelesaiSplash extends StatefulWidget {
  const LatihanSelesaiSplash({Key? key}) : super(key: key);

  @override
  State<LatihanSelesaiSplash> createState() => _LatihanSelesaiSplashState();
}

class _LatihanSelesaiSplashState extends State<LatihanSelesaiSplash> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder:
              (context) => BlocProvider(
                create:
                    (_) =>
                        LatihanMateriBloc(SiswaRepositori())
                          ..add(FetchLatihanMateri()),
                child: LatihanMateriPage(),
              ),
        ),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F4F4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Latihan splash",
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        leading: const BackButton(color: Colors.black54),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          Text(
            'Latihan Selesai',
            style: GoogleFonts.quicksand(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Auto redirecting to home in 5 Seconds',
            style: GoogleFonts.quicksand(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
