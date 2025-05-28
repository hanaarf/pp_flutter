import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pp_flutter/pages/component/followers.dart';
import 'package:pp_flutter/pages/component/following.dart';

class FollowPage extends StatefulWidget {
  final int initialIndex;
  final int userId;

  const FollowPage({Key? key, this.initialIndex = 0, required this.userId}) : super(key: key);

  @override
  _FollowPageState createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.initialIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Teman",
          style: GoogleFonts.quicksand(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          indicatorWeight: 2,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(text: "Mengikuti"),
            Tab(text: "Pengikut"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MengikutiPage(userId: widget.userId), // Kirim userId
          PengikutPage(userId: widget.userId),  // Kirim userId
        ],
      ),
    );
  }
}



