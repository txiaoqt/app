import 'package:flutter/material.dart';

class PartyDetailScreen extends StatelessWidget {
  final Map<String, dynamic> party;
  final String heroTag;

  const PartyDetailScreen({
    super.key,
    required this.party,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(party['name']?.toString() ?? 'Party Details'),
        backgroundColor: const Color(0xFFEF7575),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Hero(
                  tag: heroTag,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      party['image_url']?.toString() ??
                          'https://via.placeholder.com/100',
                      height: 300,
                      width: 400,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                party['code']?.toString() ?? 'N/A',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Goal:',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                party['goal']?.toString() ?? 'No goal available.',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
