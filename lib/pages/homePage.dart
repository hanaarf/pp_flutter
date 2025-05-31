// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pp_flutter/blocs/latMateri/latMat_bloc.dart';
import 'package:pp_flutter/blocs/latMateri/latMat_event.dart';
import 'package:pp_flutter/models/response/materi_model.dart';
import 'package:pp_flutter/pages/component/materi_list.dart';
import 'package:pp_flutter/pages/latihan_materi.dart';
import 'package:pp_flutter/pages/layar_belajar.dart';
import 'package:pp_flutter/pages/searchMateri.dart';
import 'package:pp_flutter/repositories/auth_repository.dart';
import 'dart:async';
import 'package:flutter/services.dart'; 

import 'package:pp_flutter/repositories/materi_repository.dart';
import 'package:pp_flutter/repositories/siswa_repositori.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? _globalStartTime;
  bool _globalSudahPopup = false;

  bool isLoadingProfile = true;
  String userName = '';
  String jenjang = 'sd';

  Timer? _timer;
  int _detikSisa = 0;
  int _belajarMenitPerHari = 15; 

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
    fetchRekomendasiMateri();
  }

  Future<void> fetchUserProfile() async {
    try {
      final profile = await AuthRepository().getProfile();
      if (!mounted) return;
      setState(() {
        userName = profile.name;
        jenjang = profile.jenjang.toLowerCase();
        isLoadingProfile = false;
        _belajarMenitPerHari = profile.belajarMenitPerHari > 0 ? profile.belajarMenitPerHari : 15;
        // Selalu reset timer setiap kali user masuk HomePage atau login
        _globalStartTime = DateTime.now();
        _globalSudahPopup = false;
      });
      _startBelajarTimer();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        isLoadingProfile = false;
      });
    }
  }

  void _startBelajarTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return; // <-- Tambahkan ini
      if (_globalStartTime == null) return;
      final now = DateTime.now();
      final elapsed = now.difference(_globalStartTime!).inSeconds;
      final total = _belajarMenitPerHari * 60;
      final sisa = total - elapsed;
      if (sisa > 0) {
        if (!mounted) return; // <-- Tambahkan ini juga sebelum setState
        setState(() {
          _detikSisa = sisa;
        });
      } else {
        timer.cancel();
        if (!_globalSudahPopup) {
          _globalSudahPopup = true;
          if (mounted) {
            _showWaktuHabisDialog();
          }
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Cek waktu habis setiap kali homepage muncul
    if (_globalStartTime != null && !_globalSudahPopup) {
      final now = DateTime.now();
      final elapsed = now.difference(_globalStartTime!).inSeconds;
      final total = _belajarMenitPerHari * 60;
      if (elapsed >= total) {
        _globalSudahPopup = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showWaktuHabisDialog();
        });
      }
    }
  }

  void _showWaktuHabisDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 60),
              padding: const EdgeInsets.only(
                top: 80,
                bottom: 24,
                left: 24,
                right: 24,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.black26),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Waktu Belajar Habis!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Yeay! Kamu sudah belajar dengan baik! Sekarang waktunya rehat sejenak  ",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff404040),
                    ),
                  ),
                  SizedBox(height: 24),
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            SystemNavigator.pop(); // keluar aplikasi
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffFAAE2B),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            "Keluar Aplikasi",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.black, width: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            "Tetap di Aplikasi",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              child: SizedBox(
                width: 130,
                height: 130,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/lamp.svg',
                    width: 120,
                    height: 120,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool isLoadingMateri = true;
  List<MateriModel> rekomendasiMateri = [];

  Future<void> fetchRekomendasiMateri() async {
    try {
      final result = await MateriRepository().getRekomendasiMateri();
      if (!mounted) return; // Tambahkan ini
      setState(() {
        rekomendasiMateri = result;
        isLoadingMateri = false;
      });
    } catch (e) {
      if (!mounted) return; // Tambahkan ini juga
      setState(() {
        isLoadingMateri = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAAE2B),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(60),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SvgPicture.asset(
                      'assets/home/bg-home.svg', 
                      fit: BoxFit.cover,
                      height: 145,
                      width: double.infinity,
                    ),
                  ),
                ),
                Positioned(
                  top: 110,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 75,
                          height: 75,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                top: -40,
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: SvgPicture.asset(
                                    'assets/home/${isLoadingProfile ? 'jenjang' : jenjang}.svg',
                                    key: ValueKey(
                                      isLoadingProfile ? 'jenjang' : jenjang,
                                    ),
                                    width: 65,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Halo $userName',
                                style: GoogleFonts.quicksand(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  side: const BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 10,
                                  ),
                                ),
                                onPressed: () {},
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => LayarBelajar(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Belajar Sekarang!',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFFFBBE55),
                                      ),
                                      child: const Icon(
                                        Icons.arrow_forward,
                                        size: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xff9E9E9E)),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, size: 20, color: Colors.black54),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchMateri(),
                          ),
                        );
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        hintText: 'Cari materi',
                        border: InputBorder.none,
                        hintStyle: GoogleFonts.montserrat(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fitur',
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Flexible(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 18,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LayarBelajar(),
                                    ),
                                  );
                                },
                                child: SvgPicture.asset(
                                  'assets/home/materi.svg',
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Layar Belajar',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 18,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => BlocProvider(
                                            create:
                                                (_) => LatihanMateriBloc(
                                                  SiswaRepositori(),
                                                )..add(FetchLatihanMateri()),
                                            child: LatihanMateriPage(),
                                          ),
                                    ),
                                  );
                                },

                                child: SvgPicture.asset(
                                  'assets/home/latihan.svg',
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Latihan Seru',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              color: Colors.white,
              margin: EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isLoadingMateri)
                    const Center(child: CircularProgressIndicator())
                  else
                    MateriList(materiData: rekomendasiMateri),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
