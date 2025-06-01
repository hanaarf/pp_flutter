import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pp_flutter/pages/kelasPage.dart';
import 'package:pp_flutter/repositories/siswa_repositori.dart';

class JenjangPage extends StatefulWidget {
  @override
  _JenjangPageState createState() => _JenjangPageState();
}

class _JenjangPageState extends State<JenjangPage> {
  List jenjangList = [];
  int? _selectedJenjangId;

  final SiswaRepositori _repo = SiswaRepositori();

  @override
  void initState() {
    super.initState();
    fetchJenjang();
  }

  Future<void> fetchJenjang() async {
    try {
      final data = await _repo.getJenjangList();
      setState(() {
        jenjangList = data;
      });
    } catch (e) {
      // 
    }
  }

  void _pilihJenjang(int id) {
    setState(() {
      _selectedJenjangId = id;
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
                "Pilih Jenjang Sekolahmu!",
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
                    value: 0.3,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xffFBBE55)),
                  ),
                ),
              ),
              SizedBox(height: 70),
              ...jenjangList.map<Widget>((jenjang) => _buildOption(jenjang['id'], jenjang['nama'])).toList(),
              Spacer(),
              ElevatedButton(
                onPressed: _selectedJenjangId == null
                    ? null
                    : () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => KelasPage(jenjangId: _selectedJenjangId!),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedJenjangId == null ? Colors.grey : Color(0xffFBBE55),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text("Lanjut", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(int id, String label) {
    bool isSelected = _selectedJenjangId == id;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: OutlinedButton(
        onPressed: () => _pilihJenjang(id),
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? Colors.orange[200] : Colors.white,
          side: BorderSide(color: Colors.black),
          minimumSize: Size(double.infinity, 50),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
