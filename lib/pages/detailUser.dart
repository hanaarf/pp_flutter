import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pp_flutter/blocs/follow/follow_bloc.dart';
import 'package:pp_flutter/blocs/follow/follow_event.dart';
import 'package:pp_flutter/blocs/follow/follow_state.dart';
import 'package:pp_flutter/models/response/user_model.dart';
import 'package:pp_flutter/pages/component/reward.dart';
import 'package:pp_flutter/pages/detail_reward.dart';
import 'package:pp_flutter/pages/followPage.dart';
import 'package:pp_flutter/repositories/follow_repository.dart';

class UserDetailPage extends StatefulWidget {
  final UserModel user;

  const UserDetailPage({super.key, required this.user});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  int followersCount = 0;
  int followingCount = 0;

  @override
  void initState() {
    super.initState();
    context.read<FollowBloc>().add(CheckFollowStatus(widget.user.id));
    fetchCounts();
  }

  Future<void> fetchCounts() async {
    final repo = FollowRepository();
    final followers = await repo.getFollowersCount(widget.user.id);
    final following = await repo.getFollowingCount(widget.user.id);
    if (!mounted) return;
    setState(() {
      followersCount = followers;
      followingCount = following;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAAE2B),
      body: BlocListener<FollowBloc, FollowState>(
        listener: (context, state) async {
          if (state is FollowLoaded) {
            await fetchCounts();
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 165,
                    width: double.infinity,
                    color: const Color(0xFFFAAE2B),
                    child: SvgPicture.asset(
                      'assets/profile/profile.svg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 30,
                    left: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      minHeight:
                          MediaQuery.of(context).size.height -
                          70, 
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(40),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 70, 20, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Text(
                                widget.user.nama[0].toUpperCase() +
                                    widget.user.nama.substring(1),
                                style: GoogleFonts.quicksand(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${widget.user.jenjang} : ${widget.user.kelas}',
                                style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Color(0xffFAAE2B),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/avatar/bi_trophy.svg',
                                      width: 15,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Total xp: ${widget.user.xp}',
                                      style: TextStyle(
                                        color: Color(0xffFAAE2B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 25),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildCounter(
                                followingCount.toString(),
                                "Mengikuti",
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => FollowPage(
                                            initialIndex: 0,
                                            userId: widget.user.id,
                                          ),
                                    ),
                                  );
                                },
                              ),
                              Container(
                                width: 1,
                                height: 50,
                                color: Colors.grey,
                              ),
                              _buildCounter(
                                followersCount.toString(),
                                "Pengikut",
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => FollowPage(
                                            initialIndex: 1,
                                            userId: widget.user.id,
                                          ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        BlocBuilder<FollowBloc, FollowState>(
                          builder: (context, state) {
                            bool isFollowing = false;
                            if (state is FollowLoaded)
                              isFollowing = state.isFollowing;
                            return SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      isFollowing
                                          ? Colors.grey
                                          : Colors.pinkAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                onPressed:
                                    state is FollowLoading
                                        ? null
                                        : () {
                                          if (isFollowing) {
                                            context.read<FollowBloc>().add(
                                              UnfollowUser(widget.user.id),
                                            );
                                          } else {
                                            context.read<FollowBloc>().add(
                                              FollowUser(widget.user.id),
                                            );
                                          }
                                         
                                        },
                                child: Text(
                                  isFollowing ? "Batal Ikuti" : "Ikuti",
                                  style: GoogleFonts.quicksand(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 30),
                        Text(
                          "Informasi",
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 16),
                            SizedBox(width: 8),
                            Text(
                              'Bergabung ${_formatTanggal(widget.user.createdAt)}',
                              style: GoogleFonts.quicksand(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Pencapaian",
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => DetailRewardPage(
                                          xp: int.tryParse(widget.user.xp) ?? 0,
                                        ),
                                  ),
                                );
                              },
                              child: Text(
                                "Lihat Semua",
                                style: GoogleFonts.quicksand(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: buildPencapaian(
                            int.tryParse(widget.user.xp) ?? 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -60,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(widget.user.img),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCounter(String value, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.quicksand(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.quicksand(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTanggal(String tanggal) {
    final DateTime dt = DateTime.parse(tanggal);
    const bulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${bulan[dt.month - 1]} ${dt.year}';
  }
}
