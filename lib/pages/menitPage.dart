import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pp_flutter/models/request/profile_request.dart';
import 'package:pp_flutter/pages/component/bottom_navbar.dart';
import 'package:pp_flutter/repositories/auth_repository.dart';

class MenitPage extends StatefulWidget {
  final int jenjangId;
  final int kelasId;

  const MenitPage({super.key, required this.jenjangId, required this.kelasId});

  @override
  State<MenitPage> createState() => _MenitPageState();
}

class _MenitPageState extends State<MenitPage> {
  String? selectedMenit;

  void _pilihMenit(String menit) {
    setState(() {
      selectedMenit = menit;
    });
  }

  Future<void> _simpanData() async {
    try {
      final authRepo = AuthRepository();
     await authRepo.saveProfileData(
  ProfileRequest(
    jenjangId: widget.jenjangId,
    kelasId: widget.kelasId,
    menitPerHari: int.parse(selectedMenit!.split(" ")[0]),
  ),
);


      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BottomNavbar(showDialogOnHome: true),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal simpan data: \$e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Pilih Menit Belajarmu!",
                style: GoogleFonts.quicksand(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 16,
                  child: LinearProgressIndicator(
                    value: 0.9,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xffFBBE55)),
                  ),
                ),
              ),
              SizedBox(height: 70),
              _buildOption("15 Menit"),
              _buildOption("30 Menit"),
              _buildOption("45 Menit"),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: selectedMenit == null ? null : _simpanData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedMenit == null ? Colors.grey : Color(0xffFBBE55),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "Lanjut",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(String label) {
    bool isSelected = selectedMenit == label;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: OutlinedButton(
        onPressed: () => _pilihMenit(label),
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? Color(0xffFBBE55).withOpacity(0.6) : Colors.white,
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