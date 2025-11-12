// lib/features/collections/presentation/screens/collections_screen.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:color_discovery/data/models/palette_model.dart';
import 'package:color_discovery/features/discover_quiz/presentation/widgets/palette_preview_card.dart';
import 'package:flutter_animate/flutter_animate.dart';
// Detay sayfasına gitmek için
import 'package:color_discovery/features/collections/presentation/screens/palette_detail_screen.dart';
import 'package:color_discovery/core/routes/fade_page_route.dart';

class CollectionsScreen extends StatelessWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Koleksiyonum',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<PaletteModel>('palettes').listenable(),
        builder: (context, Box<PaletteModel> box, _) {
          final palettes = box.values.toList().reversed.toList();

          if (palettes.isEmpty) {
            // Boş ekran tasarımı (Değişiklik yok)
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.palette_outlined,
                        size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text('Koleksiyonun boş',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      '"Keşfet" sekmesindeki testi tamamlayarak veya "Araçlar"ı kullanarak yeni paletler kaydedebilirsin.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          // --- DÜZELTME: ListView -> GridView ---
          // 'Keşfet' sayfasıyla aynı 2x2 ızgara düzenine geçiyoruz.
          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 90.0), // FAB için alt boşluk
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Her satırda 2 kart
              crossAxisSpacing: 12, // Yatay boşluk
              mainAxisSpacing: 12, // Dikey boşluk
              childAspectRatio: 0.8, // Kart en-boy oranı
            ),
            itemCount: palettes.length,
            itemBuilder: (context, index) {
              final palette = palettes[index];
              // Renkleri 'int' listesinden 'Color' listesine çevir
              final List<Color> colors =
                  palette.colors.map((intValue) => Color(intValue)).toList();

              // Geri kalan tüm 'Dismissible' ve 'GestureDetector' mantığı
              // ızgara düzeniyle uyumlu çalışır.
              return Dismissible(
                key: ValueKey(palette.key),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  return await showDialog<bool>(
                    context: context,
                    builder: (dialogContext) {
                      return AlertDialog(
                        title: const Text('Silmeyi Onayla'),
                        content: Text(
                            '"${palette.name}" paletini koleksiyondan kalıcı olarak silmek istediğine emin misin?'),
                        actions: [
                          TextButton(
                            child: const Text('İptal'),
                            onPressed: () {
                              Navigator.of(dialogContext).pop(false);
                            },
                          ),
                          FilledButton(
                            child: const Text('Sil'),
                            style: FilledButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                            ),
                            onPressed: () {
                              Navigator.of(dialogContext).pop(true);
                            },
                          ),
                        ],
                      );
                    },
                  ) ??
                  false;
                },
                onDismissed: (direction) {
                  palette.delete();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('"${palette.name}" silindi.'),
                      backgroundColor: Theme.of(context).colorScheme.error,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                background: Container(
                  // Arka planı kart gibi yuvarlatıyoruz
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.delete_sweep_outlined,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                      size: 32,
                    ),
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      FadePageRoute(
                        child: PaletteDetailScreen(
                          name: palette.name,
                          colors: colors,
                        ),
                      ),
                    );
                  },
                  child: PalettePreviewCard(
                    name: palette.name,
                    colors: colors,
                  ),
                ).animate()
                 .fadeIn(duration: 400.ms, delay: (100 * index).ms)
                 .slideY(begin: 0.2, end: 0),
              );
            },
          );
          // --- DÜZELTME BİTTİ ---
        },
      ),
    );
  }
}