// lib/features/collections/presentation/screens/collections_screen.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:color_discovery/data/models/palette_model.dart';
import 'package:color_discovery/features/discover_quiz/presentation/widgets/palette_preview_card.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
          
          // .values.toList() -> en sondan en başa doğru alır
          final palettes = box.values.toList().reversed.toList();

          // 1. Boş ekran (Değişiklik yok)
          if (palettes.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.palette_outlined, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text('Koleksiyonun boş', style: Theme.of(context).textTheme.titleLarge),
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

          // 2. Liste
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ListView.builder(
              itemCount: palettes.length,
              itemBuilder: (context, index) {
                final palette = palettes[index];

                // YENİ: 'PalettePreviewCard'ı 'Dismissible' ile sarmaladık
                return Dismissible(
                  // 'key' -> Flutter'ın bu widget'ı tanıması için ŞART
                  // 'palette.key' -> Hive'ın veritabanı anahtarıdır (benzersiz)
                  key: ValueKey(palette.key), 
                  
                  direction: DismissDirection.endToStart, // Sadece sağdan sola kaydır

                  // --- YENİ: SİLME ONAYI (En Profesyonel Adım) ---
                  confirmDismiss: (direction) async {
                    return await showDialog<bool>(
                      context: context,
                      builder: (dialogContext) {
                        return AlertDialog(
                          title: const Text('Silmeyi Onayla'),
                          content: Text('"${palette.name}" paletini koleksiyondan kalıcı olarak silmek istediğine emin misin?'),
                          actions: [
                            TextButton(
                              child: const Text('İptal'),
                              onPressed: () {
                                Navigator.of(dialogContext).pop(false); // Hayır, silme
                              },
                            ),
                            FilledButton( // 'ElevatedButton' yerine daha modern
                              child: const Text('Sil'),
                              style: FilledButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.error,
                              ),
                              onPressed: () {
                                Navigator.of(dialogContext).pop(true); // Evet, sil
                              },
                            ),
                          ],
                        );
                      },
                    ) ?? false; // Diyalog bir şekilde kapanırsa 'false' döndür
                  },

                  // --- YENİ: SİLME İŞLEMİ (Veritabanı) ---
                  // Bu, 'confirmDismiss' true dönerse çalışır
                  onDismissed: (direction) {
                    // Hive veritabanından sil
                    palette.delete();

                    // Onay mesajı göster
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('"${palette.name}" silindi.'),
                        backgroundColor: Theme.of(context).colorScheme.error,
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },

                  // --- YENİ: KAYDIRIRKEN GÖRÜNEN ARKA PLAN ---
                  background: Container(
                    color: Theme.of(context).colorScheme.errorContainer,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    margin: const EdgeInsets.symmetric(vertical: 8), // Kartın margin'i ile aynı
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.delete_sweep_outlined,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                        size: 32,
                      ),
                    ),
                  ),
                  
                  // --- ESKİ KODUMUZ ---
                  child: PalettePreviewCard(
                    name: palette.name,
                    colors: palette.colors.map((intValue) => Color(intValue)).toList(),
                  )
                  .animate() // Animasyonlar hala çalışır
                  .fadeIn(duration: 400.ms, delay: (100 * index).ms)
                  .slideY(begin: 0.2, end: 0),
                );
              },
            ),
          );
        },
      ),
    );
  }
}