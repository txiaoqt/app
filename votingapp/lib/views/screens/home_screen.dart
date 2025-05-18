import 'package:flutter/material.dart';
import '../profile/profile_screen.dart';
import 'parties_screen.dart';
import 'candidates_screen.dart';
import '../voting/ongoing_election_screen.dart' show OngoingElectionScreen;
import '../status/vote_status_screen.dart' show VoteStatusScreen;
import 'package:flutter/services.dart';

class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute({required super.builder, super.settings});

  @override
  Duration get transitionDuration => Duration.zero;
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: const Color(0xFFEF7575),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/hanni.jpg'),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Test',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                    ),
                  ),
                  const Text(
                    'Manila City',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
            ),
            // Welcome and News
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Welcome!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                  const SizedBox(height: 19),
                  Center(
                    child: Text(
                      'News & Updates',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ),
                ],
              ),
            ),
            // News banners
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 30),
              child: Column(
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.asset('assets/images/votewise.png', height: 120, width: 320, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.asset('assets/images/votewise.png', height: 120, width: 320, fit: BoxFit.cover),
                    ),
                  ),
                ],
              ),
            ),
            // View All buttons
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 18, right: 6, top: 30, bottom: 8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFAD2D2),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          NoAnimationMaterialPageRoute(builder: (context) => PartiesScreen()),
                        );
                      },
                      child: const Text('View All Parties', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 6, right: 18, top: 30, bottom: 8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFAD2D2),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          NoAnimationMaterialPageRoute(builder: (context) => CandidatesScreen()),
                        );
                      },
                      child: const Text('View All Candidates', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
            // Mini banners
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.asset('assets/images/votewise.png', height: 80, width: 150, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.asset('assets/images/votewise.png', height: 80, width: 150, fit: BoxFit.cover),
                    ),
                  ),
                ],
              ),
            ),
            // Spacer
            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: CustomPillNavBar(
        selectedIndex: 0,
        onTap: (index) {
          if (index == 0) {
            // Already on home
          } else if (index == 1) {
            Navigator.of(context).pushReplacement(
              NoAnimationMaterialPageRoute(builder: (context) => OngoingElectionScreen()),
            );
          } else if (index == 2) {
            Navigator.of(context).pushReplacement(
              NoAnimationMaterialPageRoute(builder: (context) => VoteStatusScreen()),
            );
          } else if (index == 3) {
            Navigator.of(context).pushReplacement(
              NoAnimationMaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          }
        },
      ),
    );
  }
}

class CustomPillNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomPillNavBar({super.key, required this.selectedIndex, required this.onTap});

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
                              blurRadius: 4,
                              offset: const Offset(0, 2),
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