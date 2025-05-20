import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'verify_pin_screen_party.dart';
import 'party_detail_screen.dart';

class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute({required super.builder, super.settings});
  @override
  Duration get transitionDuration => Duration.zero;
}

class PartyVoteScreen extends StatefulWidget {
  const PartyVoteScreen({super.key});

  @override
  State<PartyVoteScreen> createState() => _PartyVoteScreenState();
}

class _PartyVoteScreenState extends State<PartyVoteScreen> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> parties = [];
  bool isLoading = true;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    fetchParties();
    fetchUserEmail();
  }

  Future<void> fetchParties() async {
    try {
      final response = await supabase
          .from('parties')
          .select('id, name, image_url, code, goal');
      setState(() {
        parties = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching parties: \$e');
      setState(() => isLoading = false);
    }
  }

  void fetchUserEmail() {
    final email = supabase.auth.currentUser?.email;
    setState(() => userEmail = email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEF7575),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'PARTY VOTE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child:
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 24,
                          crossAxisSpacing: 24,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          children:
                              parties.map((party) {
                                final tag = 'partyVote_${party['id']}';
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => PartyDetailScreen(
                                              party: party,
                                              heroTag: tag,
                                            ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFAD2D2),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 6,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Hero(
                                          tag: tag,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child:
                                                party['image_url'] != null
                                                    ? Image.network(
                                                      party['image_url'],
                                                      height: 60,
                                                      width: 60,
                                                      fit: BoxFit.cover,
                                                    )
                                                    : Image.asset(
                                                      'assets/images/votewise.png',
                                                      height: 60,
                                                      width: 60,
                                                    ),
                                          ),
                                        ),
                                        const SizedBox(height: 7),
                                        Text(
                                          party['code'] ?? 'N/A',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 7),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(
                                              0xFFEF7575,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          onPressed: () {
                                            if (userEmail == null) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'User not logged in',
                                                  ),
                                                ),
                                              );
                                              return;
                                            }

                                            Navigator.of(context).push(
                                              NoAnimationMaterialPageRoute(
                                                builder:
                                                    (_) => VerifyPinScreenParty(
                                                      userEmail: userEmail!,
                                                      selectedParty: party,
                                                    ),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            'VOTE',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
