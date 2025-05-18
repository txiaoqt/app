import 'package:flutter/material.dart';
import 'candidate_vote_screen.dart';
import '../screens/home_screen.dart';
import '../status/vote_status_screen.dart';
import '../profile/profile_screen.dart';

class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute({required super.builder, super.settings});

  @override
  Duration get transitionDuration => Duration.zero;
}

class OngoingElectionScreen extends StatelessWidget {
  const OngoingElectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: const Color(0xFFEF7575),
              padding: const EdgeInsets.only(left: 8, top: 8, bottom: 0, right: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pushReplacement(
                       NoAnimationMaterialPageRoute(builder: (context) => HomeScreen()),
                    )
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Ongoing Election', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black)),
            const SizedBox(height: 32),
            Center(
              child: Container(
                width: 320,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAD2D2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black26),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(0, 0, 0, 0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Provincial Election', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black)),
                    const SizedBox(height: 8),
                    const Text('Candidates: 4', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                    const SizedBox(height: 12),
                    const Text('Start Date: May 1, 2025 at 7:00:00 AM', style: TextStyle(fontSize: 14, color: Colors.black)),
                    const Text('End Date: May 1, 2025 at 7:00:00 PM', style: TextStyle(fontSize: 14, color: Colors.black)),
                    const SizedBox(height: 22),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromRGBO(0, 0, 0, 0.13),
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEF7575),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              NoAnimationMaterialPageRoute(builder: (context) => const CandidateVoteScreen()),
                            );
                          },
                          child: const Text('VOTE NOW', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: CustomPillNavBar(
        selectedIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).push(
              NoAnimationMaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (index == 2) {
            Navigator.of(context).push(
              NoAnimationMaterialPageRoute(builder: (context) => const VoteStatusScreen()),
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