import 'package:flutter/material.dart';
import 'login_screen.dart';

class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute({required super.builder, super.settings});

  @override
  Duration get transitionDuration => Duration.zero;
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEF7575), // Pink background
      body: GestureDetector(
        onTap: () async {
          await Navigator.of(context).pushReplacement(
            NoAnimationMaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        },
        child: Center(
          child: Transform.rotate(
            angle: -0.12, // Slight rotation in radians
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.white, width: 3),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Roboto',
                    ),
                    children: [
                      const TextSpan(text: 'Phil'),
                      TextSpan(
                        text: 'V',
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const TextSpan(text: 'te'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 