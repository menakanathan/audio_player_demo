import 'package:flutter/material.dart';
import 'audio_player_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CitizenDjApp());
}

class CitizenDjApp extends StatelessWidget {
  const CitizenDjApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Citizen DJ Player',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF007A78),
          primary: const Color(0xFF007A78),
        ),
        useMaterial3: true,
      ),
      home: const AudioPlayerScreen(),
    );
  }
}