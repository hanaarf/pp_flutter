import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pp_flutter/blocs/ubahProfile/ubah_profile_bloc.dart';
import 'package:pp_flutter/blocs/ubahProfile/ubah_profile_event.dart';
import 'package:pp_flutter/blocs/ubahProfile/ubah_profile_state.dart';

import 'package:pp_flutter/repositories/auth_repository.dart';

class UbahProfile extends StatefulWidget {
  const UbahProfile({super.key});

  @override
  State<UbahProfile> createState() => _UbahProfileState();
}

class _UbahProfileState extends State<UbahProfile> {
  final TextEditingController _namaController = TextEditingController();

  List<String> _jenjangOptions = ['SD', 'SMP', 'SMA'];
  String? _selectedJenjang;

  final Map<String, List<String>> _kelasByJenjang = {
    'SD': ['1', '2', '3', '4', '5', '6'],
    'SMP': ['7', '8', '9'],
    'SMA': ['10', '11', '12'],
  };
  String? _selectedKelas;

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

  void _showSnackBar(String message, {bool isSuccess = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: isSuccess ? Colors.green : Colors.red,
            ),
            SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Color(0xFFFAAE2B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  bool isLoading = true;
  final AuthRepository _authRepo = AuthRepository();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await _authRepo.getProfile();
      setState(() {
        _namaController.text = profile.name;
        _selectedJenjang = profile.jenjang.toUpperCase();
        _selectedKelas =
            _selectedKelas = RegExp(r'\d+').firstMatch(profile.kelas)?.group(0);
        ;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat profil: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UbahProfileBloc, UbahProfileState>(
      listener: (context, state) {
        if (state is UbahProfileSuccess) {
          _showSnackBar("Profil berhasil diubah!");
          Navigator.pop(context);
        } else if (state is UbahProfileFailure) {
          _showSnackBar(state.message, isSuccess: false);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFAAE2B),
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
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
                          padding: const EdgeInsets.fromLTRB(20, 70, 20, 60),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  "Ubah Profile",
                                  style: GoogleFonts.quicksand(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 50),
                              Text(
                                'Nama Lengkap',
                                style: GoogleFonts.montserrat(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 5),
                              TextField(
                                controller: _namaController,
                                decoration: InputDecoration(
                                  hintText: 'hana aulia',
                                  hintStyle: TextStyle(
                                    color: Color(0xff6A6A6A),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                  filled: true,
                                  fillColor: Color(0xFFFDE4B8),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Jenjang',
                                style: GoogleFonts.montserrat(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 5),
                              DropdownButtonFormField<String>(
                                value: _selectedJenjang,
                                decoration: InputDecoration(
                                  labelText:
                                      _selectedJenjang == null
                                          ? 'Pilih Jenjang Anda'
                                          : null,
                                  labelStyle: TextStyle(
                                    color: Color(0xff6A6A6A),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                  filled: true,
                                  fillColor: Color(0xFFFDE4B8),

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                ),
                                isExpanded: true,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedJenjang = newValue;
                                    _selectedKelas =
                                        null; 
                                  });
                                },

                                items:
                                    _jenjangOptions
                                        .map<DropdownMenuItem<String>>((
                                          String value,
                                        ) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                              ),
                                            ),
                                          );
                                        })
                                        .toList(),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Kelas',
                                style: GoogleFonts.montserrat(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 5),
                              DropdownButtonFormField<String>(
                                value: _selectedKelas,
                                decoration: InputDecoration(
                                  labelText:
                                      _selectedKelas == null
                                          ? 'Pilih Kelas Anda'
                                          : null,
                                  labelStyle: TextStyle(
                                    color: Color(0xff6A6A6A),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                  filled: true,
                                  fillColor: Color(0xFFFDE4B8),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                ),
                                isExpanded: true,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedKelas = newValue;
                                  });
                                },
                                items:
                                    _selectedJenjang != null
                                        ? _kelasByJenjang[_selectedJenjang]!
                                            .map<DropdownMenuItem<String>>((
                                              String value,
                                            ) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                  value,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              );
                                            })
                                            .toList()
                                        : [],
                              ),
                              SizedBox(height: 40),
                              ElevatedButton(
                                onPressed:
                                    (_namaController.text.isNotEmpty &&
                                            _selectedJenjang != null &&
                                            _selectedKelas != null)
                                        ? () {
                                          final jenjangId =
                                              _jenjangOptions.indexOf(
                                                _selectedJenjang!,
                                              ) +
                                              1;
                                          final kelasId =
                                              int.tryParse(_selectedKelas!) ??
                                              1;

                                          context.read<UbahProfileBloc>().add(
                                            SubmitUbahProfile(
                                              _namaController.text,
                                              jenjangId,
                                              kelasId,
                                            ),
                                          );
                                        }
                                        : null,

                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      (_namaController.text.isNotEmpty &&
                                              _selectedJenjang != null &&
                                              _selectedKelas != null)
                                          ? Color(0xffFBBE55) // Oren saat aktif
                                          : Colors.grey, // Abu saat disable
                                  minimumSize: Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  "Simpan",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}
