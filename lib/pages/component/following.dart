import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pp_flutter/models/response/profile_response.dart';
import 'package:pp_flutter/repositories/follow_repository.dart';
import 'package:pp_flutter/pages/detailUser.dart';
import 'package:pp_flutter/pages/component/bottom_navbar.dart';
import 'package:pp_flutter/models/response/user_model.dart';
import 'package:pp_flutter/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pp_flutter/blocs/follow/follow_bloc.dart';
import 'package:pp_flutter/blocs/follow/follow_event.dart';
import 'package:pp_flutter/blocs/follow/follow_state.dart';
import 'package:pp_flutter/models/response/user_follow_response.dart'; // Tambahkan ini

// Halaman Mengikuti
class MengikutiPage extends StatefulWidget {
  final int userId;
  const MengikutiPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<MengikutiPage> createState() => _MengikutiPageState();
}

class _MengikutiPageState extends State<MengikutiPage> {
  List<UserFollow> following = []; 
  bool isLoading = true;
  final FollowRepository _repo = FollowRepository();
  ProfileResponse? profile;

  @override
  void initState() {
    super.initState();
    fetchProfile();
    fetchFollowing();
  }

  Future<void> fetchProfile() async {
    final authRepo = AuthRepository();
    final data = await authRepo.getProfile();
    if (!mounted) return;
    setState(() {
      profile = data;
    });
  }

  Future<void> fetchFollowing() async {
    try {
      final response = await _repo.getFollowing(widget.userId);
      if (!mounted) return;
      setState(() {
        following = response.data; // Ambil dari .data
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      // handle error
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
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 30),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: following.length,
              itemBuilder: (context, index) {
                final user = following[index];
                return BlocProvider(
                  create: (_) => FollowBloc(FollowRepository())..add(CheckFollowStatus(user.id)),
                  child: Builder(
                    builder: (context) => GestureDetector(
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
                          final userModel = UserModel(
                            id: user.id,
                            nama: user.name,
                            xp: (user.xp ?? '0').toString(),
                            img: getAvatarPath(user.image),
                            jenjang: user.jenjang ?? '',
                            kelas: user.kelas ?? '',
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
                          border: Border.all(color: Color(0xffD9D9D9), width: 1.5),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage(getAvatarPath(user.image)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                user.name,
                                style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            // Tambahkan pengecekan ini:
                            if (profile == null || user.id != profile!.id)
                              BlocBuilder<FollowBloc, FollowState>(
                                builder: (context, state) {
                                  bool isFollowing = false;
                                  if (state is FollowLoaded) isFollowing = state.isFollowing;
                                  return ElevatedButton(
                                    onPressed: state is FollowLoading
                                        ? null
                                        : () {
                                            if (isFollowing) {
                                              context.read<FollowBloc>().add(UnfollowUser(user.id));
                                            } else {
                                              context.read<FollowBloc>().add(FollowUser(user.id));
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isFollowing ? Colors.grey : Colors.pinkAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                    ),
                                    child: Text(
                                      isFollowing ? "Batal Ikuti" : "Ikuti",
                                      style: GoogleFonts.quicksand(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
