import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CandidateDetailScreen extends StatelessWidget {
  final Map<String, dynamic> candidate;
  final String heroTag;

  const CandidateDetailScreen({
    super.key,
    required this.candidate,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEF7575),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEF7575),
        title: Text(
          candidate['name']?.toString() ?? 'Candidate Details',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(55),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: heroTag,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child:
                      candidate['image_url'] != null
                          ? Image.network(
                            candidate['image_url'],
                            height: 180,
                            width: 180,
                            fit: BoxFit.cover,
                          )
                          : Image.asset(
                            'assets/images/votewise.png',
                            height: 180,
                            width: 180,
                          ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                candidate['name']?.toString() ?? 'No Name',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                candidate['position']?.toString() ?? '',
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 24),
              _infoRow(
                icon: LucideIcons.flag,
                label: 'Party',
                value: candidate['party_code']?.toString() ?? 'N/A',
              ),
              const SizedBox(height: 12),
              _infoRow(
                icon: LucideIcons.phone,
                label: 'Phone',
                value: candidate['phone']?.toString() ?? 'N/A',
              ),
              const SizedBox(height: 12),
              _infoRow(
                icon: LucideIcons.mail,
                label: 'Email',
                value: candidate['email']?.toString() ?? 'N/A',
              ),
              const SizedBox(height: 24),
              const Text(
                'Biography',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 12),
              Text(
                candidate['bio']?.toString() ?? 'No biography available.',
                style: const TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.black54),
        const SizedBox(width: 12),
        Text(value, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
