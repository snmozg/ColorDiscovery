// lib/presentation/screens/discover_screen.dart
import 'package:color_discovery/features/discover_quiz/presentation/screens/quiz_start_screen.dart';
import 'package:color_discovery/features/discover_quiz/presentation/widgets/palette_preview_card.dart';
import 'package:color_discovery/features/discover_quiz/presentation/widgets/featured_palette_card.dart';
import 'package:flutter/material.dart';
import 'package:color_discovery/core/routes/fade_page_route.dart';
import 'package:color_discovery/features/collections/presentation/screens/palette_detail_screen.dart';

class DiscoveryScreen extends StatelessWidget {
  const DiscoveryScreen({super.key});

  // Örnek "Günün Paleti" verisi
  final Map<String, dynamic> featuredPalette = const {
    "name": "Derin Deniz",
    "colors": [
      Color(0xFF0F1B2D),
      Color(0xFF1B3A5E),
      Color(0xFF3A6B9C),
      Color(0xFF6A9CCF)
    ],
  };

  // Diğer popüler paletler
  final List<Map<String, dynamic>> popularPalettes = const [
    {
      "name": "Sakin Okyanus",
      "colors": [Color(0xFF2E4C6D), Color(0xFF396EB0), Color(0xFFDADDFC)],
    },
    {
      "name": "Canlı Gün Batımı",
      "colors": [Color(0xFFF94144), Color(0xFFF3722C), Color(0xFFF8961E)],
    },
    {
      "name": "Pastel Rüya",
      "colors": [Color(0xFFCDB4DB), Color(0xFFFFAFCC), Color(0xFFBDE0FE)],
    },
    {
      "name": "Kurumsal Güven",
      "colors": [Color(0xFF003049), Color(0xFFD62828), Color(0xFFF77F00)],
    },
    {
      "name": "Retro Bahar",
      "colors": [Color(0xFFE07A5F), Color(0xFF3D405B), Color(0xFF81B29A)],
    },
    {
      "name": "Modern Neon",
      "colors": [Color(0xFF70D6FF), Color(0xFFFF70A6), Color(0xFFFF9770)],
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Günün Paleti için renkleri Color nesnelerine çevir
    final List<Color> featuredColors =
        List<Color>.from(featuredPalette["colors"]);
    final String featuredName = featuredPalette["name"];

    return Scaffold(
      appBar: AppBar(
        title: Text('Keşfet',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            FadePageRoute(
              child: const QuizStartScreen(),
            ),
          );
        },
        label: const Text('Yeni Palet Oluştur'),
        icon: const Icon(Icons.add),
      ),

      // --- DÜZELTME: 'SingleChildScrollView' ve 'Column' yerine 'CustomScrollView' ---
      // Bu yapı, birden fazla kayan listeyi/gridi tek bir ekranda birleştirmek için
      // tasarlanmıştır ve layout çökmesini engeller.
      body: CustomScrollView(
        slivers: [
          // --- BÖLÜM 1: Günün Paleti ve Başlıklar ---
          // 'SliverToBoxAdapter', normal (box) widget'ları sliver listesine
          // eklememizi sağlar.
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Günün Paleti',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  const SizedBox(height: 12),
                  FeaturedPaletteCard(
                    name: featuredName,
                    colors: featuredColors,
                    onTap: () {
                      Navigator.of(context).push(
                        FadePageRoute(
                          child: PaletteDetailScreen(
                            name: featuredName,
                            colors: featuredColors,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Popüler Paletler',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // --- BÖLÜM 2: Popüler Paletler Izgarası ---
          // 'SliverGrid.builder', 'GridView.builder'ın sliver versiyonudur.
          // 'shrinkWrap' veya 'physics' gerekmez.
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 90.0), // FAB için alt boşluk
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: popularPalettes.length,
              itemBuilder: (context, index) {
                final palette = popularPalettes[index];
                final List<Color> colors =
                    List<Color>.from(palette["colors"]);
                final String name = palette["name"];

                return PalettePreviewCard(
                  name: name,
                  colors: colors,
                  onTap: () {
                    Navigator.of(context).push(
                      FadePageRoute(
                        child: PaletteDetailScreen(
                          name: name,
                          colors: colors,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      // --- DÜZELTME BİTTİ ---
    );
  }
}