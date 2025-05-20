import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'edit_profile_screen.dart';
import 'voting_history_screen.dart';
import 'about_us_screen.dart';
import '../auth/splash_screen.dart';
import '../screens/home_screen.dart';
import '../voting/ongoing_election_screen.dart';
import '../status/vote_status_screen.dart';
import 'notification_detail_screen.dart';
import 'share_qr_screen.dart'; // Added import

class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute({required super.builder, super.settings});
  @override
  Duration get transitionDuration => Duration.zero;
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? voterData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchVoterData();
  }

  Future<void> fetchVoterData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      setState(() {
        voterData = null;
        isLoading = false;
      });
      return;
    }

    final response =
        await Supabase.instance.client
            .from('voters')
            .select()
            .eq('email', user.email!)
            .maybeSingle();

    if (mounted) {
      setState(() {
        voterData = response;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (voterData == null) {
      return const Scaffold(body: Center(child: Text('Voter not found.')));
    }

    final imageUrl = voterData?['image_url'] as String?;
    final hasImage = imageUrl != null && imageUrl.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: const Color(0xFFEF7575),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed:
                        () => Navigator.of(context).pushReplacement(
                          NoAnimationMaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Profile Picture',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Image.asset(
                        'assets/images/votewise.png',
                        width: 32,
                        height: 32,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: const Color(0xFFEF7575),
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  CircleAvatar(
                    radius: 44,
                    backgroundImage:
                        hasImage
                            ? NetworkImage(imageUrl!)
                            : const AssetImage(
                                  'assets/images/default_avatar.png',
                                )
                                as ImageProvider,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${voterData?['first_name'] ?? ''} ${voterData?['last_name'] ?? ''}"
                        .trim(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    voterData?['city'] ?? 'N/A',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.email, color: Colors.white, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        voterData?['email'] ?? 'N/A',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _profileOption(
                    Icons.person,
                    'Edit Profile',
                    onTap: () {
                      Navigator.of(context).push(
                        NoAnimationMaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );
                    },
                  ),
                  _profileOption(
                    Icons.history,
                    'Voting History',
                    onTap: () {
                      Navigator.of(context).push(
                        NoAnimationMaterialPageRoute(
                          builder: (context) => const VotingHistoryScreen(),
                        ),
                      );
                    },
                  ),
                  _profileOption(
                    Icons.notifications,
                    'Notifications',
                    onTap: () {
                      Navigator.of(context).push(
                        NoAnimationMaterialPageRoute(
                          builder:
                              (context) => const NotificationDetailScreen(),
                        ),
                      );
                    },
                  ),
                  _profileOption(
                    Icons.info,
                    'About Us',
                    onTap: () {
                      Navigator.of(context).push(
                        NoAnimationMaterialPageRoute(
                          builder: (context) => const AboutUsScreen(),
                        ),
                      );
                    },
                  ),
                  _profileOption(
                    Icons.qr_code,
                    'Share the App via QR Code',
                    onTap: () {
                      Navigator.of(context).push(
                        NoAnimationMaterialPageRoute(
                          builder: (context) => const ShareQRScreen(),
                        ),
                      );
                    },
                  ),
                  _profileOption(
                    Icons.logout,
                    'Log out',
                    onTap: () {
                      Supabase.instance.client.auth.signOut();
                      Navigator.of(context).pushAndRemoveUntil(
                        NoAnimationMaterialPageRoute(
                          builder: (context) => const SplashScreen(),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomPillNavBar(
        selectedIndex: 3,
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pushReplacement(
              NoAnimationMaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          } else if (index == 1) {
            Navigator.of(context).pushReplacement(
              NoAnimationMaterialPageRoute(
                builder: (context) => const OngoingElectionScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.of(context).pushReplacement(
              NoAnimationMaterialPageRoute(
                builder: (context) => const VoteStatusScreen(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _profileOption(IconData icon, String label, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12, width: 1)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black, size: 26),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black26,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomPillNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomPillNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.home, 'label': 'Home'},
      {'icon': Icons.check_box, 'label': 'Vote'},
      {'icon': Icons.info, 'label': 'Vote Status'},
      {'icon': Icons.person, 'label': 'Profile'},
    ];

    return Stack(
      children: [
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 40,
              color: const Color(0xFFEF7575),
            ),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(items.length, (index) {
                  final selected = selectedIndex == index;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: () => onTap(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color:
                              selected
                                  ? const Color(0xFFEF7575)
                                  : const Color(0xFFFAD2D2),
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromRGBO(0, 0, 0, 0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              items[index]['icon'] as IconData,
                              color: selected ? Colors.white : Colors.black54,
                              size: 20,
                            ),
                            const SizedBox(width: 1),
                            Flexible(
                              child: Text(
                                items[index]['label'] as String,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color:
                                      selected ? Colors.white : Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
