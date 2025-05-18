import 'package:flutter/material.dart';
import 'vote_status_parties_screen.dart';
import 'vote_status_candidates_screen.dart';
import '../screens/home_screen.dart';
import '../voting/ongoing_election_screen.dart';
import '../profile/profile_screen.dart';

class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute({required super.builder, super.settings});

  @override
  Duration get transitionDuration => Duration.zero;
}

class VoteStatusScreen extends StatelessWidget {
  const VoteStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                     onPressed: () => Navigator.of(context).pushReplacement(
                       NoAnimationMaterialPageRoute(builder: (context) => HomeScreen()),
                    )
                  ),
                  const Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 80.0),
                        child: Text(
                          'VOTE STATUS',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text('Ongoing Election', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
            const SizedBox(height: 24),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
              padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 18),
              decoration: BoxDecoration(
                color: const Color(0xFFFAD2D2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black26),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromRGBO(0, 0, 0, 0.10),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Provincial Election', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  const SizedBox(height: 16),
                  const Text('Start Date: May 1, 2025 at 7:00:00 AM', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const Text('End Date: May 1, 2025 at 7:00:00 PM', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 24),
                  Column(
                    children: [
                      SizedBox(
                        width: 220,
                        height: 44,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            elevation: 4,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              NoAnimationMaterialPageRoute(builder: (context) => const VoteStatusPartiesScreen()),
                            );
                          },
                          child: const Text('View Parties Status', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFEF7575), fontSize: 16)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: 240,
                        height: 44,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            elevation: 4,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              NoAnimationMaterialPageRoute(builder: (context) => const VoteStatusCandidatesScreen()),
                            );
                          },
                          child: const Text('View Candidates Status', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFEF7575), fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomPillNavBar(
        selectedIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).push(
              NoAnimationMaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (index == 1) {
            Navigator.of(context).push(
              NoAnimationMaterialPageRoute(builder: (context) => const OngoingElectionScreen()),
            );
          } else if (index == 3) {
            Navigator.of(context).push(
              NoAnimationMaterialPageRoute(builder: (context) => const ProfileScreen()),
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
                mainAxisAlignment: MainAxisAlignment.center,
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