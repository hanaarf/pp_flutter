import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pp_flutter/blocs/detailMateri/detail_bloc.dart';
import 'package:pp_flutter/blocs/detailMateri/detail_event.dart';
import 'package:pp_flutter/blocs/detailMateri/detail_state.dart';
import 'package:pp_flutter/models/response/materi_response.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailMateriPage extends StatefulWidget {
  final int materiId;
  const DetailMateriPage({super.key, required this.materiId});

  @override
  State<DetailMateriPage> createState() => _DetailMateriPageState();
}

class _DetailMateriPageState extends State<DetailMateriPage> {
  WebViewController? _controller;
  String videoUrl = '';

  @override
  void initState() {
    super.initState();
    context.read<MateriDetailBloc>().add(FetchMateriDetail(widget.materiId));
  }

  void initializeWebView(String url) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url));

    setState(() {
      _controller = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: SafeArea(
        child: BlocBuilder<MateriDetailBloc, MateriDetailState>(
          builder: (context, state) {
            if (state is MateriDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MateriDetailLoaded) {
              final MateriVideo materi = state.materi;
              if (_controller == null) {
                Future.microtask(() => initializeWebView(materi.youtubeUrl));
              }

              return Column(
                children: [
                  Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: _controller != null
                            ? WebViewWidget(controller: _controller!)
                            : const Center(child: CircularProgressIndicator()),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.8),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.black),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade400, width: 1.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                            child: Text(
                               '${materi.judul} : ${materi.subjudul}',
                              style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Divider(thickness: 1, height: 1),
                          const SizedBox(height: 16),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.house_rounded, color: Color(0xffFBBE55)),
                                      const SizedBox(width: 4),
                                      Text(
                                        materi.jenjang ?? '-',
                                        style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.school, color: Color(0xffFBBE55)),
                                      const SizedBox(width: 4),
                                      Text(
                                        materi.kelas ?? '-',
                                        style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Divider(thickness: 1, height: 1),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                            child: Text("Deskripsi", style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 25),
                            height: 3,
                            width: 75,
                            color: const Color(0xffFBBE55),
                          ),
                          const Divider(thickness: 1, height: 1),
                          const SizedBox(height: 25),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Text(
                              materi.deskripsi,
                              style: GoogleFonts.quicksand(fontSize: 14),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            margin: const EdgeInsets.only(left: 25),
                            child: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Putar",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Pintar",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            margin: const EdgeInsets.only(left: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Akses materi belajar PutarPintar disini!",
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  materi.youtubeUrl,
                                  style: const TextStyle(
                                    color: Color(0xff0000EE),
                                    fontSize: 15,
                                    decoration: TextDecoration.underline,
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
              );
            } else if (state is MateriDetailError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}