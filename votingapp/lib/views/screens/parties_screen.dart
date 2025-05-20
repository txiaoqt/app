import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../voting/party_detail_screen.dart';

class PartiesScreen extends StatefulWidget {
  const PartiesScreen({super.key});

  @override
  State<PartiesScreen> createState() => _PartiesScreenState();
}

class _PartiesScreenState extends State<PartiesScreen> {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchParties() async {
    final response = await supabase
        .from('parties')
        .select('code, image_url, name, goal, id')
        .order('created_at');
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEF7575),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'All Parties',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: fetchParties(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: \${snapshot.error}'),
                            );
                          } else if (snapshot.data == null ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                              child: Text('No parties found.'),
                            );
                          }

                          final parties = snapshot.data!;
                          return GridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 24,
                            crossAxisSpacing: 24,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 8,
                            ),
                            children:
                                parties.map((party) {
                                  final tag = 'partyImage_${party['id']}';
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
                                        borderRadius: BorderRadius.circular(24),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromRGBO(
                                              0,
                                              0,
                                              0,
                                              0.08,
                                            ),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Hero(
                                            tag: tag,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Image.network(
                                                party['image_url'] ?? '',
                                                height: 70,
                                                width: 100,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (_, __, ___) =>
                                                        const Icon(Icons.image),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            party['code'] ?? '',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
