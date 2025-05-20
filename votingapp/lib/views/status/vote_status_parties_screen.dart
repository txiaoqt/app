import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VoteStatusPartiesScreen extends StatefulWidget {
  const VoteStatusPartiesScreen({super.key});

  @override
  State<VoteStatusPartiesScreen> createState() =>
      _VoteStatusPartiesScreenState();
}

class _VoteStatusPartiesScreenState extends State<VoteStatusPartiesScreen> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> parties = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchParties();
  }

  Future<void> fetchParties() async {
    final response = await supabase
        .from('parties')
        .select('name, vote_count, image_url')
        .order('vote_count', ascending: false);

    setState(() {
      parties = List<Map<String, dynamic>>.from(response);
      isLoading = false;
    });
  }

  String getRank(int index) {
    final ranks = ['🥇', '🥈', '🥉'];
    return index < ranks.length ? ranks[index] : '${index + 1}th';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  children: [
                    // Header
                    Container(
                      color: const Color(0xFFEF7575),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
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
                          const Expanded(
                            child: Center(
                              child: Text(
                                'VOTE STATUS',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'All Parties',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        itemCount: parties.length,
                        separatorBuilder:
                            (context, i) => const SizedBox(height: 16),
                        itemBuilder: (context, i) {
                          final p = parties[i];
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                // Party Logo
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    p['image_url'] ?? '',
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (_, __, ___) => const CircleAvatar(
                                          radius: 25,
                                          child: Icon(Icons.flag, size: 28),
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Party Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p['name'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Icon(Icons.how_to_vote, size: 18),
                                          const SizedBox(width: 6),
                                          Text(
                                            '${p['vote_count']} Votes',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  getRank(i),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
