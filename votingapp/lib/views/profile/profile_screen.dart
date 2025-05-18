import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';
import 'voting_history_screen.dart';
import 'about_us_screen.dart';
import '../auth/splash_screen.dart';
import '../screens/home_screen.dart';
import '../voting/ongoing_election_screen.dart';
import '../status/vote_status_screen.dart';

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
  ProfileScreenState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: const Color(0xFFEF7575),
              padding: const EdgeInsets.symmetric(horizontal: 8 , vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pushReplacement(
                       NoAnimationMaterialPageRoute(builder: (context) => HomeScreen()),
                    )
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Profile Picture',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 32, height: 32, child: Align(alignment: Alignment.topRight, child: Image.asset('assets/images/votewise.png', width: 32, height: 32))),
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
                    backgroundImage: AssetImage('assets/images/hanni.jpg'),
                  ),
                  const SizedBox(height: 10),
                  const Text('Test', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white)),
                  const Text('Manila City', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white)),
                  const Text('Voter ID: 1234', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.white)),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.email, color: Colors.white, size: 18),
                      SizedBox(width: 6),
                      Text('minajjjang@gmail.com', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _profileOption(Icons.person, 'Edit Profile', onTap: () {
                    Navigator.of(context).push(
                      NoAnimationMaterialPageRoute(builder: (context) => const EditProfileScreen()),
                    );
                  }),
                  _profileOption(Icons.history, 'Voting History', onTap: () {
                    Navigator.of(context).push(
                      NoAnimationMaterialPageRoute(builder: (context) => const VotingHistoryScreen()),
                    );
                  }),
                  _profileOption(Icons.notifications, 'Notifications', onTap: () {}),
                  _profileOption(Icons.info, 'About Us', onTap: () {
                    Navigator.of(context).push(
                      NoAnimationMaterialPageRoute(builder: (context) => const AboutUsScreen()),
                    );
                  }),
                  _profileOption(Icons.qr_code, 'Share the App via QR Code', onTap: () {}),
                  _profileOption(Icons.logout, 'Log out', onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      NoAnimationMaterialPageRoute(builder: (context) => const SplashScreen()),
                      (route) => false,
                    );
                  }),
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
              NoAnimationMaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else if (index == 1) {
            Navigator.of(context).pushReplacement(
              NoAnimationMaterialPageRoute(builder: (context) => OngoingElectionScreen()),
            );
          } else if (index == 2) {
            Navigator.of(context).pushReplacement(
              NoAnimationMaterialPageRoute(builder: (context) => VoteStatusScreen()),
            );
          } else if (index == 3) {
            //already on profile
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
          border: Border(
            bottom: BorderSide(color: Colors.black12, width: 1),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black, size: 26),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.black26, size: 18),
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
        // Black bar at the very bottom, outside SafeArea
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 40, // or whatever height you want for the black bar
              color:const Color(0xFFEF7575),
            ),
          ),
        ),
        // Pills row, inside SafeArea so it doesn't touch the very bottom
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(items.length, (index) {
                  final selected = selectedIndex == index;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: () => onTap(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: selected ? const Color(0xFFEF7575) : const Color(0xFFFAD2D2),
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
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: selected ? Colors.white : Colors.black87,
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

