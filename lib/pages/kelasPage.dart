// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pp_flutter/pages/menitPage.dart';
import '../services/variable.dart';

class KelasPage extends StatefulWidget {
  final int jenjangId;
  const KelasPage({
    Key? key,
    required this.jenjangId,
  }) : super(key: key);

  @override
  _KelasPageState createState() => _KelasPageState();
}

class _KelasPageState extends State<KelasPage> {
  List kelasList = [];
  int? selectedKelasId;

  @override
  void initState() {
    super.initState();
    fetchKelas();
  }

  Future<void> fetchKelas() async {
    final response = await http.get(Uri.parse('$baseUrl/kelas/${widget.jenjangId}'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      setState(() {
        kelasList = data;
      });
    }
  }

  void _pilihKelas(int kelasId) {
    setState(() {
      selectedKelasId = kelasId;
    });
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
                "Pilih Jenjang Kelasmu!",
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
                    value: 0.6,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xffFBBE55)),
                  ),
                ),
              ),
              SizedBox(height: 70),
              ...kelasList.map<Widget>((kelas) => _buildOption(kelas['id'], kelas['nama'])).toList(),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: selectedKelasId == null
                    ? null
                    : () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MenitPage(
                              jenjangId: widget.jenjangId,
                              kelasId: selectedKelasId!,
                            ),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      selectedKelasId == null ? Colors.grey : Color(0xffFBBE55),
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

  Widget _buildOption(int id, String label) {
    bool isSelected = selectedKelasId == id;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: OutlinedButton(
        onPressed: () => _pilihKelas(id),
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
