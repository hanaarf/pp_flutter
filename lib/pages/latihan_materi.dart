import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pp_flutter/pages/latihan_soal.dart';

class LatihanMateriPage extends StatelessWidget {
  final List<Map<String, String>> materi = [
    {
      'judul': 'Lesson 1',
      'deskripsi': 'Greeting',
      'gambar': 'https://www.youtube.com/embed/FrwfbVEwqZg',
    },
    {
      'judul': 'Lesson 2',
      'deskripsi': 'Classroom',
      'gambar': 'https://www.youtube.com/embed/FrwfbVEwqZg',
    },
    {
      'judul': 'Lesson 3',
      'deskripsi': 'My Face',
      'gambar': 'https://www.youtube.com/embed/FrwfbVEwqZg',
    },
  ];

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
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Latihan Materi',
          style: GoogleFonts.quicksand(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 22,vertical: 10),
        children: [
          // Kartu utama dengan SVG
          Container(
            margin: EdgeInsets.only(bottom: 10,top: 10),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xffFFF3D9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Color(0xffE0E0E0), // warna border abu-abu
                width: 1, // ketebalan border
              ),
            ),
            child: Row(
              children: [
                SvgPicture.asset('assets/latMat.svg', width: 90, height: 90),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Latihan Materi',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                            side: BorderSide(color: Colors.black),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Mulai Latihan',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 5),
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
          // List Kartu Materi
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
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      getYoutubeThumbnail(item['gambar'] ?? ''),
                      width: 115,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 1,),
                        Text(
                          item['judul'] ?? '',
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black, // pastikan warnanya hitam
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          item['deskripsi'] ?? '',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black, // pastikan juga hitam
                          ),
                        ),
                        SizedBox(height: 6),
                        SizedBox(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                               minimumSize: Size(double.infinity, 34),
                              backgroundColor: Color(0xff69D2C7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => QuizPage(),
                                      ),
                                    );
                                  },
                              child: Text(
                                'Mulai Latihan',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
