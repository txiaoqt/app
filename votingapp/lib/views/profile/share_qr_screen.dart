import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';

class ShareQRScreen extends StatelessWidget {
  const ShareQRScreen({super.key});

  final String appLink =
      'https://play.google.com/store/apps/details?id=com.example.votewise';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share VoteWise'),
        backgroundColor: const Color(0xFFEF7575),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QrImageView(
              data: appLink,
              version: QrVersions.auto,
              size: 240.0,
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 20),
            Text(
              'Scan to download the app',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.copy),
              label: const Text('Copy Link'),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: appLink));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Link copied to clipboard')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF7575),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
