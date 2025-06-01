import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pp_flutter/blocs/latMateri/latMat_bloc.dart';
import 'package:pp_flutter/blocs/latMateri/latMat_event.dart';
import 'package:pp_flutter/blocs/latMateri/latMat_state.dart';
import 'package:pp_flutter/blocs/quiz/latSoal_bloc.dart';
import 'package:pp_flutter/blocs/quiz/latSoal_event.dart';
import 'package:pp_flutter/pages/component/bottom_navbar.dart';
import 'package:pp_flutter/pages/latihan_soal.dart';
import 'package:pp_flutter/repositories/siswa_repositori.dart';

class LatihanMateriPage extends StatelessWidget {
  String getYoutubeThumbnail(String embedUrl) {
    Uri uri = Uri.parse(embedUrl);
    String videoId = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
    return 'https://img.youtube.com/vi/$videoId/0.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAFAFA),

      appBar: AppBar(
        backgroundColor: Color(0xffFAFAFA),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomNavbar(initialIndex: 0),
              ),
              (route) => false,
            );
          },
        ),
        elevation: 0,
        title: Text(
          "Latihan Materi",
          style: GoogleFonts.quicksand(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<LatihanMateriBloc, LatihanMateriState>(
        builder: (context, state) {
          if (state is LatihanMateriLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is LatihanMateriLoaded) {
            final materi = state.materi;
            final notDoneList = materi.where((item) => item.statusLatihan != 'selesai');
            final firstNotDone = notDoneList.isNotEmpty ? notDoneList.first : null;

            return ListView(
              padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10, top: 10),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xffFFF3D9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(0xffE0E0E0), width: 1),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/latMat.svg',
                        width: 90,
                        height: 90,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Latihan Materi',
                              style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: firstNotDone == null
                                  ? () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Semua latihan sudah dikerjakan!')),
                                      );
                                    }
                                  : () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BlocProvider(
                                            create: (_) => LatihanSoalBloc(SiswaRepositori())
                                              ..add(FetchLatihanSoal(firstNotDone.id)),
                                            child: QuizPage(materiId: firstNotDone.id),
                                          ),
                                        ),
                                      );
                                      // Setelah kembali dari QuizPage, refresh data
                                      context.read<LatihanMateriBloc>().add(FetchLatihanMateri());
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  side: BorderSide(color: Colors.black),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Mulai Latihan',
                                    style: GoogleFonts.quicksand(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: Color(0xffFBBE55),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: Colors.black,
                                      size: 14,
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
                SizedBox(height: 24),
                ...materi.map((item) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Transform.scale(
                              scale: 1.3,
                              child: Image.network(
                                getYoutubeThumbnail(item.youtubeUrl),
                                width: 110,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 1),
                                Text(
                                  item.judul.length > 10
                                      ? '${item.judul.substring(0, 10)}...'
                                      : item.judul,
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.subjudul.length > 20
                                      ? '${item.subjudul.substring(0, 20)}...'
                                      : item.subjudul,
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 6),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: item.statusLatihan == 'selesai'
                                        ? null
                                        : () async {
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => BlocProvider(
                                                  create: (_) => LatihanSoalBloc(SiswaRepositori())
                                                    ..add(FetchLatihanSoal(item.id)),
                                                  child: QuizPage(materiId: item.id),
                                                ),
                                              ),
                                            );
                                            // Setelah kembali dari QuizPage, refresh data
                                            context.read<LatihanMateriBloc>().add(FetchLatihanMateri());
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: item.statusLatihan == 'selesai'
                                          ? Colors.grey[300]
                                          : item.statusLatihan == 'lanjut'
                                              ? Color(0xff69D2C7)
                                              : Colors.yellow[700],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: BorderSide(
                                          color: Colors.black,
                                          width: 0.2,
                                        ),
                                      ),
                                      minimumSize: Size.fromHeight(34),
                                    ),
                                    child: Text(
                                      item.statusLatihan == 'selesai'
                                          ? 'sudah dikerjakan'
                                          : item.statusLatihan == 'lanjut'
                                          ? 'Lanjut Latihan'
                                          : 'Mulai Latihan',
                                      style: GoogleFonts.montserrat(
                                        color: Colors.black,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            );
          } else if (state is LatihanMateriError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
