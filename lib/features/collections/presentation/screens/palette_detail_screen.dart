// lib/features/collections/presentation/screens/palette_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:color_discovery/data/models/palette_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PaletteDetailScreen extends ConsumerWidget {
  const PaletteDetailScreen({
    super.key,
    required this.name,
    required this.colors,
  });

  final String name;
  final List<Color> colors;

  // Rengi HEX koduna çevirir
  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  // Tıklandığında panoya kopyalar
  void _copyToClipboard(BuildContext context, String hexCode) {
    Clipboard.setData(ClipboardData(text: hexCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$hexCode panoya kopyalandı!'),
        backgroundColor: Colors.grey[800],
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // Paleti Hive veritabanına kaydeder
  void _savePalette(BuildContext context) {
    final box = Hive.box<PaletteModel>('palettes');
    final isAlreadySaved = box.values.any((palette) => palette.name == name);

    if (isAlreadySaved) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"$name" zaten koleksiyonda.'),
          backgroundColor: Colors.orange[700],
        ),
      );
      return;
    }

    final newPalette = PaletteModel(
      name: name,
      colors: colors.map((color) => color.value).toList(),
    );
    box.add(newPalette);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"$name" koleksiyona kaydedildi!'),
        backgroundColor: Colors.green[700],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Renk Detayları'),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. Dikey Renk Paleti (Daraltılmış ve Ortalanmış)
            Center(
              child: Container(
                height: 300,
                width: 220, // Sabit, daha dar bir genişlik
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: theme.cardColor,
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    children: colors
                        .map((color) => Expanded(
                              child: Container(color: color),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 2. Palet Adı
            Text(
              name,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            const Divider(height: 40),

            // 3. Renk Kodları Listesi
            Column(
              children: colors.map((color) {
                final hexCode = _colorToHex(color);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: theme.colorScheme.outlineVariant
                                    .withOpacity(0.3))),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        hexCode,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.copy_outlined),
                        tooltip: '$hexCode Kopyala',
                        onPressed: () => _copyToClipboard(context, hexCode),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // --- DÜZELTME BURADA ---
            // 4. Kaydet Butonu (Sadece İkon)
            FilledButton(
              // 'label' (yazı) kaldırıldı.
              // 'icon' yerine 'child' (ana içerik) kullanıldı.
              child: const Icon(Icons.save_alt_outlined, size: 28),
              style: FilledButton.styleFrom(
                // 'minimumSize' (yatay genişlik) kaldırıldı.
                // 'padding' ile butonu kareye yakın ve estetik hale getirelim.
                padding: const EdgeInsets.all(20),
                // 'shape' ile tam yuvarlak (dairesel) yapalım.
                shape: const CircleBorder(),
              ),
              onPressed: () => _savePalette(context),
            ),
            // --- DÜZELTME BİTTİ ---
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}