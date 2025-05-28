import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pp_flutter/blocs/logout/logout_bloc.dart';
import 'package:pp_flutter/blocs/logout/logout_event.dart';
import 'package:pp_flutter/blocs/logout/logout_state.dart';
import 'package:pp_flutter/blocs/menitBelajar/ubah_menit_bloc.dart';
import 'package:pp_flutter/blocs/ubahProfile/ubah_profile_bloc.dart';
import 'package:pp_flutter/blocs/ulasan/ulasan_bloc.dart';
import 'package:pp_flutter/blocs/ulasan/ulasan_event.dart';
import 'package:pp_flutter/blocs/ulasan/ulasan_state.dart';
import 'package:pp_flutter/models/response/profile_response.dart';
import 'package:pp_flutter/pages/component/follow.dart';
import 'package:pp_flutter/pages/signin.dart';
import 'package:pp_flutter/pages/ubah_menit.dart';
import 'package:pp_flutter/pages/ubah_profile.dart';
import 'package:pp_flutter/repositories/auth_repository.dart';
import 'package:pp_flutter/repositories/ulasan_repository.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _ulasanController = TextEditingController();
  ProfileResponse? profileData;
  bool isLoading = true;
  String selectedAvatar = 'assets/avatar/avatar.png';
  bool sudahUlasan = false;

  @override
  void initState() {
    super.initState();
    fetchProfile();
    fetchStatusUlasan();
    _ulasanController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  Future<void> fetchProfile() async {
    try {
      final authRepo = AuthRepository();
      final data = await authRepo.getProfile();
      if (!mounted) return;
      setState(() {
        profileData = data;
        selectedAvatar = 'assets/avatar/${data.image ?? 'avatar.png'}';
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data profil: $e')),
      );
    }
  }

  Future<void> fetchStatusUlasan() async {
    try {
      final repo = UlasanRepository();
      final status = await repo.cekSudahUlasan();
      if (!mounted) return;
      setState(() {
        sudahUlasan = status;
      });
    } catch (e) {
      // Optional: tampilkan error
    }
  }

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        final avatars = List.generate(
          6,
          (index) => 'assets/avatar/ava${index + 1}.png',
        );

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Pilih avatar untuk profile kamu",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: avatars.map((path) {
                  return GestureDetector(
                    onTap: () async {
                      final avatarName = path.split('/').last;
                      try {
                        await AuthRepository().updateAvatar(avatarName);
                        if (!mounted) return;
                        setState(() {
                          selectedAvatar = path;
                        });
                        _showCustomSnackBar(context, "Avatar berhasil diperbarui");
                        if (mounted) Navigator.pop(context);
                      } catch (e) {
                        if (mounted) {
                          _showCustomSnackBar(
                            context,
                            "Gagal update avatar: $e",
                            isSuccess: false,
                          );
                        }
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedAvatar == path ? Colors.deepPurple : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Image.asset(path),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCustomSnackBar(
    BuildContext context,
    String message, {
    bool isSuccess = true,
  }) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: isSuccess ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFFAAE2B),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _ulasanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAAE2B),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  color: const Color(0xFFFAAE2B),
                  child: SvgPicture.asset(
                    'assets/profile/profile.svg',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),

            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(50),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 70, 20, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Text(
                              profileData?.name ?? '',
                              style: GoogleFonts.quicksand(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${profileData?.jenjang ?? ''} ${profileData?.kelas ?? ''}',
                              style: GoogleFonts.quicksand(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                       SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildCounter("1", "Mengikuti"),
                            Container(width: 1, height: 50, color: Colors.grey),
                            buildCounter("10", "Pengikut"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFFFD77A)),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.orangeAccent,
                              offset: Offset(2, 2),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total XP : ${profileData?.xpTotal ?? 0}",
                              style: GoogleFonts.montserrat(fontSize: 15),
                            ),
                            SvgPicture.asset(
                              'assets/profile/bi_trophy.svg',
                              width: 20,
                            ),
                          ],
                        ),
                      ),
                       const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             SvgPicture.asset(
                                'assets/profile/xp200.svg',
                                width: 67,
                              ),
                             SvgPicture.asset(
                                'assets/profile/xp400.svg',
                                width: 67,
                              ),
                             SvgPicture.asset(
                                'assets/profile/xp600.svg',
                                width: 67,
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "Ubah Profile",
                        style: GoogleFonts.montserrat(color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF00D4CD),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: SvgPicture.asset(
                              'assets/profile/icon-profile.svg',
                              width: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              profileData?.name ?? '',
                              style: GoogleFonts.montserrat(fontSize: 14),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => BlocProvider<UbahProfileBloc>(
                                        create:
                                            (_) => UbahProfileBloc(
                                              AuthRepository(),
                                            ),
                                        child: const UbahProfile(),
                                      ),
                                ),
                              ).then((_) {
                                // setelah kembali, panggil ulang fetchProfile
                                fetchProfile();
                              });
                            },
                            child: SvgPicture.asset(
                              'assets/profile/icon-pencil.svg',
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 30),
                      Text(
                        "Ubah Waktu Belajar",
                        style: GoogleFonts.montserrat(color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF00D4CD),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: SvgPicture.asset(
                              'assets/profile/gala_clock.svg',
                              width: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "${profileData?.belajarMenitPerHari ?? 0} Menit",
                              style: GoogleFonts.montserrat(fontSize: 14),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => BlocProvider<UbahMenitBloc>(
                                        create:
                                            (_) =>
                                                UbahMenitBloc(AuthRepository()),
                                        child: const UbahMenit(),
                                      ),
                                ),
                              );
                              fetchProfile();
                            },

                            child: SvgPicture.asset(
                              'assets/profile/icon-pencil.svg',
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 30),
                      if (!sudahUlasan) ...[
                        Text(
                          "Ulasan",
                          style: GoogleFonts.montserrat(color: Colors.grey),
                        ),
                        const SizedBox(height: 10),
                        BlocListener<UlasanBloc, UlasanState>(
                          listener: (context, state) {
                            if (state is UlasanSuccess) {
                              _ulasanController.clear();
                              _showCustomSnackBar(context, "Ulasan berhasil dikirim!");
                              setState(() {
                                sudahUlasan = true; // Form hilang setelah sukses kirim
                              });
                            } else if (state is UlasanFailure) {
                              _showCustomSnackBar(context, "Gagal mengirim: ${state.message}", isSuccess: false);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(2, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                TextField(
                                  controller: _ulasanController,
                                  minLines: 4,
                                  maxLines: 6,
                                  decoration: InputDecoration(
                                    hintText:
                                        "Berikan pendapatmu tentang aplikasi ini...",
                                    hintStyle: GoogleFonts.montserrat(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                    contentPadding: const EdgeInsets.fromLTRB(
                                      12,
                                      12,
                                      48,
                                      12,
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap:
                                        _ulasanController.text.isNotEmpty
                                            ? () {
                                            context.read<UlasanBloc>().add(
                                              KirimUlasanEvent(
                                                _ulasanController.text,
                                              ),
                                            );
                                          }
                                          : null,
                                    child: Icon(
                                      Icons.send,
                                      size: 20,
                                      color:
                                        _ulasanController.text.isNotEmpty
                                            ? const Color(0xffFBBE55)
                                            : Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      BlocListener<LogoutBloc, LogoutState>(
                        listener: (context, state) {
                          if (state is LogoutSuccess) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SigninPages(),
                              ),
                              (route) => false,
                            );
                          } else if (state is LogoutFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Logout gagal: ${state.message}"),
                              ),
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 40, 
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.logout, color: Colors.black87, size: 16),
                              label: Text(
                                "Logout",
                                style: GoogleFonts.montserrat(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffFBBE55), 
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      title: Text(
                                        "Konfirmasi Logout",
                                        style: GoogleFonts.quicksand(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: Text(
                                        "Apakah kamu yakin ingin keluar dari akun?",
                                        style: GoogleFonts.quicksand(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: const Text("Batal"),
                                          onPressed: () => Navigator.of(context).pop(),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xffFBBE55),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            context.read<LogoutBloc>().add(
                                              LogoutRequested(),
                                            );
                                          },
                                          child: const Text("Ya"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -60,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage(selectedAvatar),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Material(
                          elevation: 2,
                          shape: const CircleBorder(),
                          child: InkWell(
                            onTap: _showAvatarPicker,
                            child: const CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.camera_alt,
                                size: 16,
                                color: Colors.orange,
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
          ],
        ),
      ),
    );
  }

  
}
