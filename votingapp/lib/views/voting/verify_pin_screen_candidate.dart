import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'confirm_candidate_vote_screen.dart';

class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute({required super.builder, super.settings});
  @override
  Duration get transitionDuration => Duration.zero;
}

class VerifyPinScreenCandidate extends StatefulWidget {
  final String userEmail;
  final Map<String, dynamic> selectedCandidate;

  const VerifyPinScreenCandidate({
    super.key,
    required this.userEmail,
    required this.selectedCandidate,
  });

  @override
  State<VerifyPinScreenCandidate> createState() => _VerifyPinScreenState();
}

class _VerifyPinScreenState extends State<VerifyPinScreenCandidate> {
  final TextEditingController pinController = TextEditingController();
  bool isLoading = false;
  final supabase = Supabase.instance.client;

  void _verifyPin() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response =
          await supabase
              .from('voters')
              .select('pin')
              .eq('email', widget.userEmail)
              .single();

      final String correctPin = response['pin'].toString();
      final String enteredPin = pinController.text.trim();

      if (enteredPin == correctPin) {
        Navigator.of(context).push(
          NoAnimationMaterialPageRoute(
            builder:
                (context) => ConfirmCandidateVoteScreen(
                  candidate: widget.selectedCandidate,
                ),
          ),
        );
      } else {
        _showError('Incorrect PIN. Please try again.');
      }
    } catch (e) {
      _showError('An error occurred while verifying your PIN.');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        'Verify your PIN',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 32),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black26),
                        ),
                        child: TextField(
                          controller: pinController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter your PIN',
                          ),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.0),
                        child: Text(
                          'Your PIN (Personal Identification Number) is the code you provided during registration.',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: 240,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEF7575),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                            elevation: 0,
                          ),
                          onPressed: isLoading ? null : _verifyPin,
                          child:
                              isLoading
                                  ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                  : const Text(
                                    'Continue',
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
            ),
          ],
        ),
      ),
    );
  }
}
