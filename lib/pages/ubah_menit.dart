import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pp_flutter/blocs/menitBelajar/ubah_menit_bloc.dart';
import 'package:pp_flutter/blocs/menitBelajar/ubah_menit_event.dart';
import 'package:pp_flutter/blocs/menitBelajar/ubah_menit_state.dart';
import 'package:pp_flutter/pages/component/bottom_navbar.dart';

class UbahMenit extends StatefulWidget {
  const UbahMenit({super.key});

  @override
  State<UbahMenit> createState() => _UbahMenitState();
}

class _UbahMenitState extends State<UbahMenit> {
  String? selectedMenit;

  void _showCustomSnackBar(
    BuildContext context,
    String message, {
    bool isSuccess = true,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      isSuccess
                          ? Colors.greenAccent
                          : Colors.red.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isSuccess ? Icons.check_circle : Icons.error,
                  color: isSuccess ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Color(0xFFFAAE2B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
        elevation: 4,
      ),
    );
  }

  void _pilihKelas(String kelas) {
    setState(() {
      selectedMenit = kelas;
    });
  }

  String selectedAvatar = 'assets/avatar/ava1.png';

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
                children:
                    avatars.map((path) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            selectedAvatar = path;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  selectedAvatar == path
                                      ? Colors.deepPurple
                                      : Colors.transparent,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAAE2B),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                children: [
                  // Bagian background oranye + dekorasi SVG
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 145,
                        width: double.infinity,
                        color: const Color(0xFFFAAE2B),
                        child: SvgPicture.asset(
                          'assets/profile/menit.svg',
                          fit: BoxFit.cover,
                        ),
                      ),

                      // Icon Back di atas profile.svg
                      Positioned(
                        top: 15,
                        left: 20,
                        child: SafeArea(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(
                                0.3,
                              ), // abu transparan
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Avatar dan kontainer putih
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
                        padding: const EdgeInsets.fromLTRB(20, 70, 20, 120),
                        child: BlocListener<UbahMenitBloc, UbahMenitState>(
                          listener: (context, state) {
                            if (state is UbahMenitSuccess) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BottomNavbar(initialIndex: 2),
                                ),
                              );
                              _showCustomSnackBar(
                                context,
                                "Waktu belajar berhasil diubah!",
                              );
                            } else if (state is UbahMenitFailure) {
                              _showCustomSnackBar(
                                context,
                                state.message,
                                isSuccess: false,
                              );
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 30),
                              Center(
                                child: Text(
                                  "Ubah Waktu Belajarmu!",
                                  style: GoogleFonts.quicksand(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 50),
                              _buildOption("15 Menit"),
                              _buildOption("30 Menit"),
                              _buildOption("45 Menit"),
                              const SizedBox(height: 40),
                              ElevatedButton(
                                onPressed:
                                    selectedMenit == null
                                        ? null
                                        : () {
                                          final menit = int.parse(
                                            selectedMenit!.split(" ").first,
                                          );
                                          context.read<UbahMenitBloc>().add(
                                            SubmitUbahMenit(menit),
                                          );
                                        },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      selectedMenit == null
                                          ? Colors.grey
                                          : const Color(0xffFBBE55),
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text(
                                  "Simpan",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Avatar tumpang tindih
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
        },
      ),
    );
  }

  Widget _buildOption(String label) {
    bool isSelected = selectedMenit == label;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: OutlinedButton(
        onPressed: () => _pilihKelas(label),
        style: OutlinedButton.styleFrom(
          backgroundColor:
              isSelected ? Color(0xffFBBE55).withOpacity(0.6) : Colors.white,
          side: BorderSide(color: Colors.black),
          minimumSize: Size(double.infinity, 50),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontWeight: isSelected ? FontWeight.w400 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
