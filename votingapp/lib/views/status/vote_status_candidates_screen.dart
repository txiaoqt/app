import 'package:flutter/material.dart';

class VoteStatusCandidatesScreen extends StatelessWidget {
  const VoteStatusCandidatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> candidates = [
      {'rank': '1st', 'name': 'Taylor Swift (PRM)', 'votes': '9,999,999'},
      {'rank': '2nd', 'name': 'Ariana Grande (TVP)', 'votes': '9,999,999'},
      {'rank': '3rd', 'name': 'Olivia Rodrigo (PLU)', 'votes': '9,999,999'},
      {'rank': '4th', 'name': 'Sabrina Carp (UGF)', 'votes': '9,999,999'},
    ];
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
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'VOTE STATUS',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('All Candidates', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                itemCount: candidates.length,
                separatorBuilder: (context, i) => const SizedBox(height: 18),
                itemBuilder: (context, i) {
                  final candidate = candidates[i];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black87, width: 1),
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
                        Text(
                          candidate['rank']!,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                candidate['name']!,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(
                                    candidate['votes']!,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text('Votes', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                                ],
                              ),
                            ],
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