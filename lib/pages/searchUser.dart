import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pp_flutter/blocs/follow/follow_bloc.dart';
import 'package:pp_flutter/models/user_model.dart';
import 'package:pp_flutter/pages/detailUser.dart';
import 'package:pp_flutter/repositories/follow_repository.dart';
import 'package:pp_flutter/repositories/siswa_repositori.dart';

class SearchUser extends StatefulWidget {
  const SearchUser({super.key});

  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  String _searchText = '';
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  List<UserModel> searchResults = [];
  bool isLoading = false;

  void _performSearch(String keyword) async {
    setState(() {
      isLoading = true;
    });

    try {
      final results = await SiswaRepositori().searchUsers(keyword);
      setState(() {
        searchResults = results;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mencari user: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F9F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 27),
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
                  const SizedBox(width: 5),
                  Expanded(
                    child: Container(
                      height: 50,
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
                            _performSearch(value);
                          }
                        },
                        decoration: const InputDecoration(
                          icon: Icon(Icons.search, color: Colors.grey),
                          hintText: 'Cari teman',
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
              if (_searchText.isEmpty) ...[
                Container(
                  margin: const EdgeInsets.only(right: 30, top: 100),
                  child: SizedBox(
                    height: 180,
                    child: SvgPicture.asset('assets/search.svg'),
                  ),
                ),
                const SizedBox(height: 45),
                Text(
                  'Belum ada pencarian. Yuk, cari\nsesuatu sekarang!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ] else if (isLoading) ...[
                const Center(child: CircularProgressIndicator()),
              ] else if (searchResults.isEmpty) ...[
                const SizedBox(height: 40),
                Text(
                  'Tidak ada yang sesuai dengan hasil pencarian',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ] else ...[
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children:
                        searchResults
                            .map(
                              (user) => GestureDetector(
                                onTap: () {
                                   Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                        create: (_) => FollowBloc(FollowRepository()),
                                        child: UserDetailPage(user: user),
                                      ),
                                    ),
                                  );
                                },

                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color(0xFFEEEEEE),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.transparent,
                                        child: Image.asset(user.img),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          capitalize(user.nama),
                                          style: GoogleFonts.quicksand(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${user.xp} xp',
                                        style: GoogleFonts.quicksand(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
