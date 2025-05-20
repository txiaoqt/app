import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'vote_confirmed_screen.dart';

class ConfirmPartyVoteScreen extends StatefulWidget {
  final Map<String, dynamic> selectedParty;

  const ConfirmPartyVoteScreen({super.key, required this.selectedParty});

  @override
  State<ConfirmPartyVoteScreen> createState() => _ConfirmPartyVoteScreenState();
}

class _ConfirmPartyVoteScreenState extends State<ConfirmPartyVoteScreen> {
  final supabase = Supabase.instance.client;
  bool isLoading = true;
  bool hasAlreadyVoted = false;

  @override
  void initState() {
    super.initState();
    checkIfAlreadyVoted();
  }

  Future<void> checkIfAlreadyVoted() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      setState(() => isLoading = false);
      return;
    }

    final voter =
        await supabase
            .from('voters')
            .select('party_voted')
            .eq('id', userId)
            .maybeSingle();

    setState(() {
      hasAlreadyVoted = voter?['party_voted'] != null;
      isLoading = false;
    });
  }

  Future<void> confirmPartyVote() async {
    final userId = supabase.auth.currentUser?.id;

    if (userId == null || widget.selectedParty['id'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unable to confirm your vote.")),
      );
      return;
    }

    await supabase
        .from('voters')
        .update({'party_voted': widget.selectedParty['id']})
        .eq('id', userId);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const VoteConfirmedScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final party = widget.selectedParty;

    return Scaffold(
      backgroundColor: const Color(0xFFEF7575),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
              : SafeArea(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      const Text(
                        'Confirm your Party Vote',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Image.network(
                        party['image_url'] ?? '',
                        height: 120,
                        width: 120,
                        errorBuilder:
                            (context, _, __) =>
                                const Icon(Icons.error_outline, size: 120),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        party['code'] ?? 'N/A',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(party['goal'] ?? '', textAlign: TextAlign.center),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: hasAlreadyVoted ? null : confirmPartyVote,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                hasAlreadyVoted
                                    ? Colors.grey
                                    : const Color(0xFFEF7575),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                          child: const Text(
                            'Confirm Vote',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
