// lib/features/collections/presentation/screens/collections_screen.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:color_discovery/data/models/palette_model.dart';
// 'Keşfet' ekranında kullandığımız palet kartını burada YENİDEN KULLANACAĞIZ
import 'package:color_discovery/features/discover_quiz/presentation/widgets/palette_preview_card.dart';

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
      
      // Bu widget, Hive veritabanı kutusunu dinler
      // ve kutuda bir değişiklik olduğunda (yeni palet eklendiğinde)
      // altındaki 'builder' fonksiyonunu otomatik olarak yeniden çalıştırır.
      body: ValueListenableBuilder(
        valueListenable: Hive.box<PaletteModel>('palettes').listenable(),
        builder: (context, Box<PaletteModel> box, _) {
          
          // Kutudaki tüm paletleri bir liste olarak al
          // .values.toList() -> en sondan en başa doğru alır (en son eklenen en üstte)
          final palettes = box.values.toList().reversed.toList();

          // 1. Eğer hiç kayıtlı palet yoksa
          if (palettes.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.palette_outlined,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Koleksiyonun boş',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
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

          // 2. Eğer kayıtlı paletler varsa, onları listele
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ListView.builder(
              itemCount: palettes.length,
              itemBuilder: (context, index) {
                final palette = palettes[index];

                // 'Keşfet' ekranı için yaptığımız palet kartını burada tekrar kullanıyoruz!
                return PalettePreviewCard(
                  name: palette.name,
                  // Veritabanında 'int' olarak sakladığımız renkleri
                  // tekrar 'Color' tipine çeviriyoruz
                  colors: palette.colors.map((intValue) => Color(intValue)).toList(),
                );
              },
            ),
          );
        },
      ),
    );
  }
}