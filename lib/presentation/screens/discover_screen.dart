// lib/features/discover_quiz/presentation/screens/discover_screen.dart
import 'package:color_discovery/features/discover_quiz/presentation/screens/quiz_start_screen.dart';
import 'package:color_discovery/features/discover_quiz/presentation/widgets/palette_preview_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:color_discovery/core/routes/fade_page_route.dart'; // Artık bu dosya var!

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  final List<Map<String, dynamic>> popularPalettes = const [
    { "name": "Sakin Okyanus", "colors": [Color(0xFF2E4C6D), Color(0xFF396EB0), Color(0xFFDADDFC), Color(0xFFFC997C)], },
    { "name": "Gün Batımı", "colors": [Color(0xFFF94144), Color(0xFFF3722C), Color(0xFFF8961E), Color(0xFFF9C74F), Color(0xFF90BE6D)], },
    { "name": "Pastel Rüya", "colors": [Color(0xFFCDB4DB), Color(0xFFFFAFCC), Color(0xFFBDE0FE), Color(0xFFA2D2FF)], },
    { "name": "Kurumsal Güven", "colors": [Color(0xFF003049), Color(0xFFD62828), Color(0xFFF77F00), Color(0xFFFCBF49), Color(0xFFEAE2B7)], },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keşfet', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            FadePageRoute( // Yumuşak geçiş
              child: const QuizStartScreen(),
            ),
          );
        },
        label: const Text('Yeni Palet Oluştur'),
        icon: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: ListView.builder(
          itemCount: popularPalettes.length,
          itemBuilder: (context, index) {
            final palette = popularPalettes[index];
            return PalettePreviewCard(
              name: palette["name"],
              colors: List<Color>.from(palette["colors"]), 
            )
            .animate()
            .fadeIn(duration: 400.ms, delay: (100 * index).ms) 
            .slideY(begin: 0.2, end: 0); 
          },
        ),
      ),
    );
  }
}