import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailRewardPage extends StatelessWidget {
  final int xp;

  const DetailRewardPage({super.key, required this.xp});

  @override
  Widget build(BuildContext context) {
    List<Widget> icons = [];

    if (xp >= 200) {
      icons.add(
        SvgPicture.asset('assets/profile/xp200.svg', width: 70, height: 70),
      );
    }
    if (xp >= 400) {
      icons.add(
        SvgPicture.asset('assets/profile/xp400.svg', width: 70, height: 70),
      );
    }
    if (xp >= 600) {
      icons.add(
        SvgPicture.asset('assets/profile/xp600.svg', width: 70, height: 70),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Pencapaian", style: GoogleFonts.quicksand(fontWeight: FontWeight.w600, color: Color.fromARGB(255, 23, 23, 23), fontSize: 18),),
        centerTitle: true,
      ),
      body: icons.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/profile/belum-ada-reward.svg',
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Belum Ada Reward",
                    style: GoogleFonts.quicksand(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: icons,
                ),
              ),
            ),
    );
  }
}
