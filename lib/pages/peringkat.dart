import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:pp_flutter/blocs/follow/follow_bloc.dart';
import 'package:pp_flutter/models/response/leaderboardUser';
import 'package:pp_flutter/models/response/profile_response.dart';
import 'package:pp_flutter/models/response/user_model.dart';
import 'package:pp_flutter/pages/component/bottom_navbar.dart';
import 'package:pp_flutter/pages/detailUser.dart';
import 'package:pp_flutter/pages/searchUser.dart';
import 'package:pp_flutter/repositories/auth_repository.dart';
import 'package:pp_flutter/repositories/follow_repository.dart';
import 'package:pp_flutter/repositories/siswa_repositori.dart';

class Peringkat extends StatefulWidget {
  const Peringkat({super.key});

  @override
  State<Peringkat> createState() => _PeringkatState();
}

class _PeringkatState extends State<Peringkat> {
  ProfileResponse? profile;
  List<LeaderboardUser> leaderboardUsers = [];
  final AuthRepository _authRepository = AuthRepository();
  final SiswaRepositori _siswaRepositori = SiswaRepositori();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final fetchedProfile = await _authRepository.getProfile();
      final fetchedLeaderboard = await _siswaRepositori.getLeaderboard();

      if (!mounted) return;
      setState(() {
        profile = fetchedProfile;
        leaderboardUsers = fetchedLeaderboard;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat data: $e')));
    }
  }

  String getAvatarPath(String? avatar) {
    final filename = avatar ?? '';
    if (filename.isEmpty || filename == 'null') {
      return 'assets/avatar/avatar.png';
    }
    return 'assets/avatar/$filename';
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 23, right: 23, top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 15,
                ),
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
                              builder: (context) => const SearchUser(),
                            ),
                          );
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Cari teman',
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
              const SizedBox(height: 40),

              // Profil Login
              profile == null
                  ? Container(height: 80)
                  : Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: const Color(0xffE0E0E0),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(
                            getAvatarPath(profile!.image),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile!.name,
                              style: GoogleFonts.quicksand(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: const Color(0xffFAAE2B),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    'assets/avatar/bi_trophy.svg',
                                    width: 15,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Total xp: ${profile!.xpTotal}',
                                    style: const TextStyle(
                                      color: Color(0xffFAAE2B),
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
              const SizedBox(height: 30),

              // Leaderboard
              Expanded(
                child:
                    isLoading
                        ? const SizedBox()
                        : ListView.builder(
                          itemCount: leaderboardUsers.length,
                          itemBuilder: (context, index) {
                            final user = leaderboardUsers[index];
                            return GestureDetector(
                              onTap: () {
                                if (profile != null && user.id == profile!.id) {
                                  Navigator.of(context).popUntil((route) => route.isFirst); 
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BottomNavbar(initialIndex: 2),
                                    ),
                                  );
                                } else {
                                  // Buka detail user lain
                                  final userModel = UserModel(
                                    id: user.id,
                                    nama: user.name,
                                    xp: user.xp.toString(),
                                    img: getAvatarPath(user.avatar),
                                    jenjang: user.jenjang,
                                    kelas: user.kelas,
                                    createdAt: DateTime.now().toIso8601String(),
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                        create: (_) => FollowBloc(FollowRepository()),
                                        child: UserDetailPage(user: userModel),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 18),
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: const Color(0xffD9D9D9),
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '${user.rank}',
                                      style: GoogleFonts.quicksand(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    CircleAvatar(
                                      backgroundImage: AssetImage(
                                        getAvatarPath(user.avatar),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        user.name[0].toUpperCase() +
                                            user.name.substring(1),
                                        style: GoogleFonts.quicksand(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${user.xp} xp',
                                      style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
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
          ),
        ),
      ),
    );
  }
}
