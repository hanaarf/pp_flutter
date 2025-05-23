import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pp_flutter/blocs/quiz/latSoal_bloc.dart';
import 'package:pp_flutter/blocs/quiz/latSoal_event.dart';
import 'package:pp_flutter/blocs/quiz/latSoal_state.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pp_flutter/pages/latihan_slesai_splash.dart';
import 'package:pp_flutter/repositories/siswa_repositori.dart';

class QuizPage extends StatefulWidget {
  final int materiId;
  const QuizPage({Key? key, required this.materiId}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentIndex = 0;
  String? _selectedOptionKey; // A, B, C, D
  bool _isAnswerChecked = false;

  @override
  void initState() {
    super.initState();
    context.read<LatihanSoalBloc>().add(FetchLatihanSoal(widget.materiId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      body: SafeArea(
        child: BlocBuilder<LatihanSoalBloc, LatihanSoalState>(
          builder: (context, state) {
            if (state is LatihanSoalLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LatihanSoalLoaded) {
              // Jika soal dari database kosong
              if (state.soal.isEmpty) {
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: BackButton(color: Colors.black54),
                    title: Text(
                      "Latihan",
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                    centerTitle: true,
                  ),
                  backgroundColor: const Color(0xffFAFAFA),
                  body: Center(
                    child: Text(
                      "Latihan belum tersedia",
                      style: GoogleFonts.quicksand(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                );
              }

              // Filter soal yang belum dikerjakan
              final soal = state.soal.where((s) => s.sudahDijawab != true).toList();

              if (soal.isEmpty) {
                // Semua soal sudah dikerjakan
                Future.microtask(() {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LatihanSelesaiSplash()),
                  );
                });
                return const SizedBox();
              }

              final current = soal[_currentIndex];
              final options = [
                {'key': 'A', 'value': current.opsiA},
                {'key': 'B', 'value': current.opsiB},
                {'key': 'C', 'value': current.opsiC},
              ];

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Progress bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.black,
                                width: 1.5,
                              ),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.close, size: 15),
                              onPressed: () => Navigator.pop(context),
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                Container(
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor:
                                      (_currentIndex + 1) / soal.length,
                                  child: Container(
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffFBBE55),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            "${_currentIndex + 1}/${soal.length}",
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),

                      // Pertanyaan
                      Center(
                        child: Html(
                          data: current.pertanyaan,
                          style: {
                            "p": Style(
                              textAlign: TextAlign.center,
                              fontSize: FontSize(20),
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: GoogleFonts.quicksand().fontFamily,
                            ),
                          },
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Pilihan jawaban
                      ...options.map((option) {
                        final key = option['key']!;
                        final value = option['value']!;
                        final isSelected = _selectedOptionKey == key;
                        final isCorrectAnswer = key == current.jawaban;

                        Color borderColor = Colors.black12;
                        if (_isAnswerChecked) {
                          if (isSelected && !isCorrectAnswer) {
                            borderColor = Colors.red;
                          } else if (isCorrectAnswer) {
                            borderColor = Colors.green;
                          }
                        }

                        return GestureDetector(
                          onTap:
                              _isAnswerChecked
                                  ? null
                                  : () {
                                    setState(() {
                                      _selectedOptionKey = key;
                                    });
                                  },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? const Color(0xffFBBE55)
                                      : const Color(0xffF8FDFC),
                              border: Border.all(color: borderColor, width: 2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              value,
                              style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      }).toList(),

                      SizedBox(height: 24),

                      // Tombol Periksa
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              _selectedOptionKey == null
                                  ? null
                                  : () async {
                                    setState(() {
                                      _isAnswerChecked = true;
                                    });

                                    final isCorrect = await SiswaRepositori()
                                        .kirimJawaban(
                                          latihanVideoId: current.id,
                                          jawabanUser: _selectedOptionKey!,
                                        );

                                    if (isCorrect) {
                                      showDialog(
                                        context: context,
                                        barrierDismissible:
                                            false, // biar gak bisa ditutup manual
                                        builder:
                                            (_) => Dialog(
                                              backgroundColor:
                                                  Colors.transparent,
                                              child: Stack(
                                                alignment: Alignment.topCenter,
                                                children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                          top: 60,
                                                        ),
                                                    padding:
                                                        const EdgeInsets.fromLTRB(
                                                          24,
                                                          80,
                                                          24,
                                                          24,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            24,
                                                          ),
                                                      border: Border.all(
                                                        color: Colors.black26,
                                                      ),
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          "Jawaban Kamu Benar!",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              GoogleFonts.quicksand(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    Colors
                                                                        .black,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 0,
                                                    child: SvgPicture.asset(
                                                      'assets/star.svg',
                                                      width: 120,
                                                      height: 120,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                      );

                                      await Future.delayed(
                                        const Duration(seconds: 1),
                                      );
                                      if (mounted) {
                                        Navigator.pop(context);
                                        setState(() {
                                          _selectedOptionKey = null;
                                          _isAnswerChecked = false;
                                          _currentIndex++;
                                        });
                                      }
                                    } else {
                                      await Future.delayed(
                                        const Duration(seconds: 1),
                                      );
                                      setState(() {
                                        _selectedOptionKey = null;
                                        _isAnswerChecked = false;
                                        _currentIndex++;
                                      });
                                    }
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _selectedOptionKey == null
                                    ? Colors.grey
                                    : const Color(0xffFBBE55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: Text(
                            "Periksa",
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is LatihanSoalError) {
              return Center(child: Text("Error: ${state.message}"));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
