import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'views/auth/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required before async calls in main

  await Supabase.initialize(
    url: 'https://kshbuclueelnmqtdadsw.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtzaGJ1Y2x1ZWVsbm1xdGRhZHN3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc1NDUwMjYsImV4cCI6MjA2MzEyMTAyNn0.iFutgZT3agbq118bNw92c6NI7VlWpjsBQJgCoZar9EQ',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
