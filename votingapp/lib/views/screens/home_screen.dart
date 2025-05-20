// Add this import at the top if not already included
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../profile/profile_screen.dart';
import 'parties_screen.dart';
import 'candidates_screen.dart';
import '../voting/ongoing_election_screen.dart' show OngoingElectionScreen;
import '../status/vote_status_screen.dart' show VoteStatusScreen;
import 'window_screen.dart';

class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute({required super.builder, super.settings});
  @override
  Duration get transitionDuration => Duration.zero;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String firstName = '';
  String city = '';
  String imageUrl = ''; // <-- New variable to store profile image URL
  final _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;

  List<Map<String, dynamic>> carouselItems = [];

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchCarouselItems();

    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() => _currentPage = next);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> fetchUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final response =
          await Supabase.instance.client
              .from('voters')
              .select('first_name, city, image_url') // <-- Include image_url
              .eq('id', user.id)
              .single();

      if (mounted) {
        setState(() {
          firstName = response['first_name'] ?? 'Voter';
          city = response['city'] ?? 'Unknown City';
          imageUrl = response['image_url'] ?? '';
        });
      }
    }
  }

  Future<void> fetchCarouselItems() async {
    try {
      final response = await Supabase.instance.client
          .from('external_links')
          .select('image_url, url, type')
          .order('id');

      if (mounted) {
        setState(() {
          carouselItems = List<Map<String, dynamic>>.from(response);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch carousel items: $e')),
      );
    }
  }

  void _handleImageTap(int index) async {
    final item = carouselItems[index];
    final url = item['url'];

    final shouldOpen = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Open Link"),
            content: const Text("Do you want to view this content?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text("Open"),
              ),
            ],
          ),
    );

    if (shouldOpen == true && url != null && context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WebViewScreen(url: url, title: 'Details'),
        ),
      );
    }
  }

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
      backgroundColor: Colors.white,
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
                    backgroundImage:
                        imageUrl.isNotEmpty
                            ? NetworkImage(imageUrl)
                            : const AssetImage('assets/images/hanni.jpg')
                                as ImageProvider,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      firstName.isEmpty ? 'Loading...' : firstName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    city.isEmpty ? '' : city,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(18, 18, 18, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  SizedBox(height: 19),
                  Center(
                    child: Text(
                      'News & Updates',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: carouselItems.length,
                      itemBuilder: (context, index) {
                        final item = carouselItems[index];
                        return GestureDetector(
                          onTap: () => _handleImageTap(index),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image.network(
                                item['image_url'] ?? '',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: Text('Image load failed'),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: carouselItems.length,
                    effect: WormEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: Colors.redAccent,
                      dotColor: Colors.grey.shade300,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 18,
                      right: 6,
                      top: 15,
                      bottom: 8,
                    ),
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
                          NoAnimationMaterialPageRoute(
                            builder: (context) => PartiesScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'View All Parties',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 6,
                      right: 18,
                      top: 15,
                      bottom: 8,
                    ),
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
                          NoAnimationMaterialPageRoute(
                            builder: (context) => CandidatesScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'View All Candidates',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      'assets/images/votewise.png',
                      height: 80,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 18),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      'assets/images/votewise.png',
                      height: 80,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: CustomPillNavBar(
        selectedIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.of(context).pushReplacement(
              NoAnimationMaterialPageRoute(
                builder: (context) => OngoingElectionScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.of(context).pushReplacement(
              NoAnimationMaterialPageRoute(
                builder: (context) => VoteStatusScreen(),
              ),
            );
          } else if (index == 3) {
            Navigator.of(context).pushReplacement(
              NoAnimationMaterialPageRoute(
                builder: (context) => ProfileScreen(),
              ),
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
                              blurRadius: 4,
                              offset: const Offset(0, 2),
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
                            Text(
                              items[index]['label'] as String,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: selected ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
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
