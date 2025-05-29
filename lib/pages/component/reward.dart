 import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
 
 Widget buildPencapaian(int xp) {
    List<Widget> icons = [];

    if (xp >= 200) {
      icons.add(SvgPicture.asset(
        'assets/profile/xp200.svg',
        width: 70,
        height: 70,
      ));
    }
    if (xp >= 400) {
      icons.add(SvgPicture.asset(
        'assets/profile/xp400.svg',
        width: 70,
        height: 70,
      ));
    }
    if (xp >= 600) {
      icons.add(SvgPicture.asset(
        'assets/profile/xp600.svg',
        width: 70,
        height: 70,
      ));
    }

    if (icons.isEmpty) {
      return Column(
        children: [
          SvgPicture.asset(
            'assets/profile/belum-ada-reward.svg',
            width: 100,
            height: 100,
          ),
          const SizedBox(height: 8),
          const Text(
            "Belum Ada Reward",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ],
      );
    }

    // Tambahkan jarak antar icon, tapi tidak setelah icon terakhir
    List<Widget> spacedIcons = [];
    for (int i = 0; i < icons.length; i++) {
      spacedIcons.add(icons[i]);
      if (i != icons.length - 1) {
        spacedIcons.add(const SizedBox(width: 16));
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: spacedIcons,
    );
  }
