import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pp_flutter/models/materi_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pp_flutter/blocs/detailMateri/detail_bloc.dart';
import 'package:pp_flutter/pages/nonton_materi.dart';
import 'package:pp_flutter/repositories/materi_repository.dart';

class MateriList extends StatefulWidget {
  final List<MateriModel> materiData;
  const MateriList({super.key, required this.materiData});

  @override
  State<MateriList> createState() => _MateriListState();
}

class _MateriListState extends State<MateriList> {
  bool isExpanded = false;

  String getYoutubeThumbnail(String embedUrl) {
    final videoId = embedUrl.split('/').last;
    return 'https://img.youtube.com/vi/$videoId/0.jpg';
  }

  @override
  Widget build(BuildContext context) {
    final dataToShow =
        isExpanded
            ? widget.materiData
            : widget.materiData
                .take(2)
                .toList(); 

    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset('assets/home/PutarPintar.svg'),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Text(
                  isExpanded ? 'Lihat Sedikit' : 'Lihat Semua Rekomen',
                  style: GoogleFonts.montserrat(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // List Materi
          Column(
            children:
                dataToShow.map((materi) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => BlocProvider(
                                create:
                                    (_) => MateriDetailBloc(
                                      repository: MateriRepository(),
                                    ),
                                child: DetailMateriPage(materiId: materi.id),
                              ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Transform.scale(
                              scale:
                                  1.3,
                              child: Image.network(
                                getYoutubeThumbnail(materi.videoUrl),
                                width: 100,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                 '${materi.judul} : ${materi.subjudul}',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  materi.deskripsi.length > 40
                                      ? '${materi.deskripsi.substring(0, 40)}...'
                                      : materi.deskripsi,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
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
          ),
        ],
      ),
    );
  }
}
