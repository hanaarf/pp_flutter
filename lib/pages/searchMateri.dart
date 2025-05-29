import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pp_flutter/blocs/detailMateri/detail_bloc.dart';
import 'package:pp_flutter/models/response/materi_model.dart';
import 'package:pp_flutter/pages/nonton_materi.dart';
import 'package:pp_flutter/repositories/materi_repository.dart';

class SearchMateri extends StatefulWidget {
  const SearchMateri({super.key});

  @override
  State<SearchMateri> createState() => _SearchMateriState();
}

class _SearchMateriState extends State<SearchMateri> {
  String _searchText = '';
  bool _isLoading = false;
  List<MateriModel> _hasilPencarian = [];

  final MateriRepository _materiRepo = MateriRepository();

  String getYoutubeThumbnail(String embedUrl) {
    final videoId = embedUrl.split('/').last;
    return 'https://img.youtube.com/vi/$videoId/0.jpg';
  }

  Future<void> _cariMateri(String keyword) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final hasil = await _materiRepo.searchMateri(keyword);
      setState(() {
        _hasilPencarian = hasil;
      });
    } catch (e) {
      setState(() {
        _hasilPencarian = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F9F9),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 27),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xff9E9E9E)),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      alignment: Alignment.center,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _searchText = value;
                          });
                          if (value.isNotEmpty) {
                            _cariMateri(value);
                          }
                        },
                        decoration: const InputDecoration(
                          icon: Icon(Icons.search, color: Colors.grey),
                          hintText: 'Cari materi',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                  ),
                  child: Column(
                    children: [
                      if (_searchText.isEmpty) ...[
                        const SizedBox(height: 100),
                        SizedBox(
                          height: 180,
                          child: SvgPicture.asset('assets/search.svg'),
                        ),
                        const SizedBox(height: 45),
                        Text(
                          'Belum ada pencarian. Yuk, cari\n sesuatu sekarang!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.quicksand(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ] else if (_isLoading) ...[
                        const SizedBox(height: 60),
                        const CircularProgressIndicator(),
                      ] else if (_hasilPencarian.isEmpty) ...[
                        const SizedBox(height: 60),
                        const Text('Tidak ada hasil ditemukan.'),
                      ] else ...[
                        const SizedBox(height: 10),
                        Column(
                          children:
                              _hasilPencarian.map((materi) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => BlocProvider(
                                              create:
                                                  (_) => MateriDetailBloc(
                                                    repository:
                                                        MateriRepository(),
                                                  ),
                                              child: DetailMateriPage(
                                                materiId: materi.id,
                                              ),
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
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: Stack(
                                            children: [
                                              Image.network(
                                                getYoutubeThumbnail(
                                                  materi.videoUrl,
                                                ),
                                                width: 100,
                                                height: 70,
                                                fit: BoxFit.cover,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                materi.judul.length > 15
                                                    ? '${materi.judul.substring(0, 15)}...'
                                                    : materi.judul,
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 14,
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
