import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'vote_confirmed_screen.dart';
import 'confirm_screen_helper.dart';

class ConfirmCandidateVoteScreen extends StatefulWidget {
  final Map<String, dynamic> candidate;

  const ConfirmCandidateVoteScreen({super.key, required this.candidate});

  @override
  State<ConfirmCandidateVoteScreen> createState() =>
      _ConfirmCandidateVoteScreenState();
}

class _ConfirmCandidateVoteScreenState
    extends State<ConfirmCandidateVoteScreen> {
  final supabase = Supabase.instance.client;
  late Map<String, dynamic> candidate;
  bool isLoading = true;
  bool hasAlreadyVoted = false;

  @override
  void initState() {
    super.initState();
    candidate = widget.candidate;
    checkIfAlreadyVoted();
  }

  Future<void> checkIfAlreadyVoted() async {
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      setState(() => isLoading = false);
      return;
    }

    final voterResponse =
        await supabase
            .from('voters')
            .select('candidate_voted')
            .eq('id', userId)
            .maybeSingle();

    setState(() {
      hasAlreadyVoted = voterResponse?['candidate_voted'] != null;
      isLoading = false;
    });
  }

  Future<void> confirmCandidateVote() async {
    if (hasAlreadyVoted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You have already voted for a candidate."),
        ),
      );
      return;
    }

    final userId = supabase.auth.currentUser?.id;
    final candidateId = candidate['id'];

    if (userId == null || candidateId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unable to confirm vote. Please try again."),
        ),
      );
      return;
    }

    await supabase
        .from('voters')
        .update({'candidate_voted': candidateId})
        .eq('id', userId);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const VoteConfirmedScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return buildConfirmScreen(
      context: context,
      title: hasAlreadyVoted ? "Already Voted" : "Confirm Candidate Vote",
      name: candidate['name'] ?? "No candidate selected",
      subtitle: candidate['party_code'] ?? '',
      imageUrl: candidate['image_url'],
      onConfirm: hasAlreadyVoted ? null : () => confirmCandidateVote(),
    );
  }
}
