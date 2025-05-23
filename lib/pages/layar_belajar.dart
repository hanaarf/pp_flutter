import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pp_flutter/blocs/detailMateri/detail_bloc.dart';
import 'package:pp_flutter/blocs/materi/materi_bloc.dart';
import 'package:pp_flutter/blocs/materi/materi_event.dart';
import 'package:pp_flutter/blocs/materi/materi_state.dart';
import 'package:pp_flutter/pages/nonton_materi.dart';
import 'package:pp_flutter/repositories/materi_repository.dart';

class LayarBelajar extends StatefulWidget {
  const LayarBelajar({super.key});

  @override
  State<LayarBelajar> createState() => _LayarBelajarState();
}

class _LayarBelajarState extends State<LayarBelajar> {
  String getYoutubeThumbnail(String embedUrl) {
    Uri uri = Uri.parse(embedUrl);
    String videoId = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
    return 'https://img.youtube.com/vi/$videoId/0.jpg';
  }

  @override
  void initState() {
    super.initState();
    context.read<MateriBloc>().add(FetchMateriVideos());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xffF5F5F5),
        centerTitle: true,
        title: Text(
          'Layar Belajar',
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<MateriBloc, MateriState>(
          builder: (context, state) {
            if (state is MateriLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MateriLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: state.videos.length,
                      itemBuilder: (context, index) {
                        final item = state.videos[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: GestureDetector(
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
                                        child: DetailMateriPage(
                                          materiId: item.id,
                                        ),
                                      ),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Transform.scale(
                                        scale: 1.3,
                                        child: Image.network(
                                          getYoutubeThumbnail(item.youtubeUrl),
                                          width: 100,
                                          height: 75,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${item.judul} : ${item.subjudul}',
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),

                                      const SizedBox(height: 4),
                                      Text(
                                        item.deskripsi.length > 40
                                            ? '${item.deskripsi.substring(0, 40)}...'
                                            : item.deskripsi,
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else if (state is MateriError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
