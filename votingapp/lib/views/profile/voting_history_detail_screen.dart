import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VotingHistoryDetailScreen extends StatefulWidget {
  const VotingHistoryDetailScreen({super.key});

  @override
  State<VotingHistoryDetailScreen> createState() =>
      _VotingHistoryDetailScreenState();
}

class _VotingHistoryDetailScreenState extends State<VotingHistoryDetailScreen> {
  Map<String, dynamic>? voteHistory;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchVoteHistory();
  }

  Future<void> fetchVoteHistory() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      final response =
          await Supabase.instance.client
              .from('voters')
              .select('''
            candidate_voted,
            party_voted,
            candidates!fk_candidate_voted (
              name, position, image_url,
              elections (
                name, date
              )
            ),
            parties!fk_party_voted (
              name, code, image_url,
              elections (
                name, date
              )
            )
          ''')
              .eq('id', user.id)
              .single();

      setState(() {
        voteHistory = response;
        isLoading = false;
      });
    } catch (e) {
      print('Failed to fetch voting history: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final candidate = voteHistory?['candidates'];
    final party = voteHistory?['parties'];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        color: const Color(0xFFEF7575),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Your Voting History',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 18),

                      if (candidate != null) ...[
                        _buildVoteCard(
                          title: 'Candidate Vote',
                          subtitle:
                              '${candidate['name']} (${party?['code'] ?? 'Independent'})',
                          imageUrl: candidate['image_url'],
                        ),
                      ],

                      const SizedBox(height: 18),

                      if (party != null) ...[
                        _buildVoteCard(
                          title: 'Party Vote',
                          subtitle: '${party['name']} (${party['code']})',
                          imageUrl: party['image_url'],
                        ),
                      ],
                    ],
                  ),
                ),
      ),
    );
  }

  Widget _buildVoteCard({
    required String title,
    required String subtitle,
    String? imageUrl,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black87, width: 1),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(0, 0, 0, 0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        child: Row(
          children: [
            imageUrl != null
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                )
                : Image.asset(
                  'assets/images/votewise.png',
                  width: 60,
                  height: 60,
                ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
