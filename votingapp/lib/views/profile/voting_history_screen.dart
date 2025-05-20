import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'voting_history_detail_screen.dart';
import 'package:intl/intl.dart';

class VotingHistoryScreen extends StatefulWidget {
  const VotingHistoryScreen({super.key});

  @override
  State<VotingHistoryScreen> createState() => _VotingHistoryScreenState();
}

class _VotingHistoryScreenState extends State<VotingHistoryScreen> {
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
            candidates!fk_candidate_voted (
              elections (
                name,
                date
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
    final election = voteHistory?['candidates']?['elections'];
    final electionName = election?['name'] ?? 'No recent election';
    final electionDateRaw = election?['date'];
    final formattedDate =
        electionDateRaw != null
            ? DateFormat(
              'M/d/yyyy, h:mm a',
            ).format(DateTime.parse(electionDateRaw))
            : 'No date available';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    const Center(
                      child: Text(
                        'Voting History',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        'Recent Votes',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      const VotingHistoryDetailScreen(),
                            ),
                          );
                        },
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
                          padding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 18,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.how_to_vote,
                                size: 32,
                                color: Color(0xFFEF7575),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    electionName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
