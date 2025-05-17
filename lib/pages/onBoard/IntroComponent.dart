import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroComponent extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final String imageLogo;
  final double sizeTop;
  final double width;

  const IntroComponent({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.imageLogo,
    required this.sizeTop,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          imagePath,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        SizedBox(height: 100),
        Center(
          child: SvgPicture.asset(imageLogo, width: 100, fit: BoxFit.cover),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
