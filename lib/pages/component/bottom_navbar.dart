import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pp_flutter/pages/homePage.dart';
import 'package:pp_flutter/pages/peringkat.dart';
import 'package:pp_flutter/pages/profile.dart';

class BottomNavbar extends StatefulWidget {
  final int initialIndex;
  const BottomNavbar({super.key, this.initialIndex = 0});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  List<Widget> _buildPages() {
    return [
      HomePage(),
      Peringkat(),
      ProfilePage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = _buildPages();

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem('assets/bottomNav/icon-home.svg', 'Beranda', 0),
            _buildNavItem('assets/bottomNav/piala.svg', 'Peringkat', 1),
            _buildNavItem('assets/bottomNav/icon-profile.svg', 'Profile', 2),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String svgAsset, String label, int index) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              svgAsset,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                isSelected ? const Color(0xff00D4CD) : const Color(0xff9E9E9E),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black : const Color(0xff9E9E9E),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
