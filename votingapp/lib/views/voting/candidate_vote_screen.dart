import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'verify_pin_screen_candidate.dart';
import 'candidate_detail_screen.dart';

class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute({required super.builder, super.settings});
  @override
  Duration get transitionDuration => Duration.zero;
}

class CandidateVoteScreen extends StatefulWidget {
  const CandidateVoteScreen({super.key});
  @override
  State<CandidateVoteScreen> createState() => _CandidateVoteScreenState();
}

class _CandidateVoteScreenState extends State<CandidateVoteScreen> {
  final supabase = Supabase.instance.client;
  List<dynamic> candidates = [];
  bool isLoading = true;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    fetchCandidates();
    fetchUserEmail();
  }

  Future<void> fetchCandidates() async {
    try {
      final response = await supabase.from('candidates').select('*');
      setState(() {
        candidates = response;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching candidates: $e');
      setState(() => isLoading = false);
    }
  }

  void fetchUserEmail() {
    final email = supabase.auth.currentUser?.email;
    setState(() {
      userEmail = email;
    });
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
                    'CANDIDATE VOTE',
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
                        : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: candidates.length,
                          separatorBuilder:
                              (_, __) => const SizedBox(height: 18),
                          itemBuilder: (context, i) {
                            final candidate = candidates[i];
                            final heroTag =
                                'candidate-image-${candidate['id']}';

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => CandidateDetailScreen(
                                          candidate: candidate,
                                          heroTag: heroTag,
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
                                child: Row(
                                  children: [
                                    Hero(
                                      tag: heroTag,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child:
                                            candidate['image_url'] != null
                                                ? Image.network(
                                                  candidate['image_url'],
                                                  height: 50,
                                                  width: 50,
                                                  fit: BoxFit.cover,
                                                )
                                                : Image.asset(
                                                  'assets/images/votewise.png',
                                                  height: 50,
                                                  width: 50,
                                                ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            candidate['name'] ?? 'No Name',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            candidate['party_code'] ?? '',
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFFEF7575,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
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
                                                (context) =>
                                                    VerifyPinScreenCandidate(
                                                      userEmail: userEmail!,
                                                      selectedCandidate:
                                                          candidate,
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
                          },
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
