// lib/features/discover_quiz/presentation/screens/quiz_results_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:color_discovery/domain/providers/quiz_providers.dart';
// YENİ EKLENDİ: Artık 'Beyni' buradan çağıracağız
import 'package:color_discovery/domain/services/palette_logic_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:color_discovery/data/models/palette_model.dart';
// getPalette fonksiyonu SİLİNDİ. Artık burada değil.

class QuizResultsScreen extends ConsumerWidget {
  const QuizResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Yeni 'Beynimizi' (Servisi) provider'dan çağır
    final paletteService = ref.watch(paletteLogicServiceProvider);

    // 2. Servisten paleti al
    final paletteData = paletteService.getPalette();
    final paletteName = paletteData.keys.first;
    final colors = paletteData.values.first;

    // 3. Hafızadan seçimleri al (Sadece açıklama metni için)
    final quizState = ref.watch(quizStateProvider);
    final projectType = quizState.projectType ?? 'Bilinmeyen';
    final mood = quizState.mood ?? 'Bilinmeyen';

    return Scaffold(
      appBar: AppBar(
        title: const Text('İşte Paletin!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(quizStateProvider.notifier).reset();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            tooltip: 'Yeni Test Başlat',
          )
        ],
      ),
      body: Column(
        children: [
          // 3. Renk bloklarını gösteren bölüm (Değişiklik yok)
          Expanded(
            flex: 3,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: colors.length,
              itemBuilder: (context, index) {
                final color = colors[index];
                return Container(
                  height: 120,
                  color: color,
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '#${color.value.toRadixString(16).substring(2).toUpperCase()}',
                    style: TextStyle(
                      color: color.computeLuminance() > 0.5
                          ? Colors.black
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 4. Açıklama bölümü (Değişiklik yok)
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    paletteName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Bu palet, "$projectType" projen için seçtiğin "$mood" hissini vermek üzere tasarlandı.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
  // 1. Kaydedilecek modeli hazırla
  final newPalette = PaletteModel(
    name: paletteName,
    // Renkleri (Color) veritabanına uygun 'int' listesine çevir
    colors: colors.map((color) => color.value).toList(),
  );

  // 2. Veritabanı 'kutusunu' aç ve modeli kaydet
  final box = Hive.box<PaletteModel>('palettes');
  box.add(newPalette);

  // 3. Kullanıcıya "Kaydedildi!" mesajı göster
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('"$paletteName" koleksiyona kaydedildi!'),
      backgroundColor: Colors.green[700],
    ),
  );
},
                    icon: const Icon(Icons.save_alt),
                    label: const Text('Koleksiyona Kaydet'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}