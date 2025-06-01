import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pp_flutter/pages/signup.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _pages = [
    {
      "title": "Selamat Datang",
      "description": "di PutarPintar!",
      "imagePath": "assets/onb/onb1.svg",
      "imageLogo": "assets/onb/on3.svg",
      "sizeTop": "0",
      "width": "220",
    },
    {
      "title": "Putar, Main,",
      "description": "Pintar Cepat",
      "imagePath": "assets/onb/onb2.svg",
      "imageLogo": "assets/onb/on2.svg",
      "sizeTop": "70",
      "width": "230",
    },
    {
      "title": "Main Pintar,",
      "description": "Bareng Kita",
      "imagePath": "assets/onb/onb3.svg",
      "imageLogo": "assets/onb/on1.svg",
      "sizeTop": "70",
      "width": "220",
    },
  ];

  void _skip() {
    _pageController.animateToPage(
      _pages.length - 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _onNext() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      _onFinish();
    }
  }

  void _onFinish() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignupPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return Column(
                      children: [
                        SvgPicture.asset(
                          page["imagePath"]!,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          height: int.parse(page["sizeTop"]!).toDouble(),
                        ),
                        Center(
                          child: SvgPicture.asset(
                            page["imageLogo"]!,
                            width:
                                double.tryParse(page["width"] ?? '') ?? 100.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    );
                  },
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),

                Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: _pages.length,
                      effect: const WormEffect(
                        spacing: 12,
                        dotHeight: 10,
                        dotWidth: 78,
                        dotColor: Colors.white,
                        activeDotColor: Color(0xffFE9365B),
                      ),
                      onDotClicked: (index) {
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 100,
                  left: 28,
                  right: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _pages[_currentIndex]["title"]!,
                        style: GoogleFonts.montserrat(
                          fontSize: 27,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        _pages[_currentIndex]["description"]!,
                        style: GoogleFonts.montserrat(
                          fontSize: 27,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: _skip,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Color(0xFFFAAE2B),
                    side: const BorderSide(color: Color(0xFFFAAE2B)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    "Lewati",
                    style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: _onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFAAE2B),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    _currentIndex == _pages.length - 1 ? "Selesai" : "Lanjut",
                    style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
