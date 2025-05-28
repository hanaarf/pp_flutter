import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildCounter(String value, String label) {
  return Column(
    children: [
      Text(
        value,
        style: GoogleFonts.quicksand(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      Text(
        label,
        style: GoogleFonts.quicksand(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ],
  );
}
