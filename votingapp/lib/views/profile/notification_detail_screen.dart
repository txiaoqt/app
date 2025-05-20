import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationDetailScreen extends StatefulWidget {
  const NotificationDetailScreen({super.key});

  @override
  State<NotificationDetailScreen> createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchVoteHistory();
  }

  Future<void> fetchVoteHistory() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    try {
      print('Logged-in user email: ${user.email}');

      final response = await Supabase.instance.client
          .from('voters')
          .select('''
            first_name,
            last_name,
            candidates!fk_candidate_voted(name),
            parties!fk_party_voted(name),
            created_at
          ''')
          .eq('email', user.email!)
          .order('created_at', ascending: false);

      print('Fetched vote data: $response');

      // Split into separate notifications
      final List<Map<String, dynamic>> processed = [];
      for (final vote in response) {
        final fullName = '${vote['first_name']} ${vote['last_name']}';
        final createdAt = DateTime.tryParse(vote['created_at'])?.toLocal();

        if (vote['candidates'] != null) {
          processed.add({
            'type': 'candidate',
            'name': vote['candidates']['name'],
            'voter': fullName,
            'date': createdAt,
          });
        }

        if (vote['parties'] != null) {
          processed.add({
            'type': 'party',
            'name': vote['parties']['name'],
            'voter': fullName,
            'date': createdAt,
          });
        }
      }

      if (mounted) {
        setState(() {
          notifications = processed;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching vote history: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Vote Notification'),
        backgroundColor: const Color(0xFFEF7575),
        foregroundColor: Colors.white,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : notifications.isEmpty
              ? const Center(child: Text('You haven\'t voted yet.'))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notif = notifications[index];
                  final voteType =
                      notif['type'] == 'candidate' ? 'Candidate' : 'Party';
                  final name = notif['name'];
                  final voter = notif['voter'];
                  final date = notif['date']?.toString().split('.')[0];

                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$voter voted for $voteType: $name',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (date != null)
                            Text(
                              'Date: $date',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
