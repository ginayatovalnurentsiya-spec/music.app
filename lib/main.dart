import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MusicApp());
}

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Space Beats',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.deepPurple.shade900,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple.shade700,
          centerTitle: true,
        ),
      ),
      home: const HomeScreen(), // Теперь сразу открываем HomeScreen
    );
  }
}
