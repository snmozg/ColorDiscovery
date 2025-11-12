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

  // Bu ekran bir PaletteModel değil, temel bilgileri alır.
  // Bu, hem 'Keşfet' (Map) hem de 'Koleksiyon' (PaletteModel) ekranlarından
  // çağrılabilmesini sağlar.
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

    // Güvenlik kontrolü: Bu isimde bir palet zaten var mı?
    // (Daha gelişmiş bir 'equals' kontrolü de yapılabilir)
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

    // Kaydet
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
            // 1. Dikey Renk Paleti (Büyük)
            Container(
              height: 300, // Görseldeki gibi büyük
              width: double.infinity,
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
                // Renkleri dikey Column ile diz
                child: Column(
                  children: colors
                      .map((color) => Expanded(
                            child: Container(color: color),
                          ))
                      .toList(),
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
            // 'ListView' yerine 'Column' kullanıyoruz ki sayfa kaydırılabilir olsun
            Column(
              children: colors.map((color) {
                final hexCode = _colorToHex(color);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      // Renk Kutusu (Görseldeki gibi)
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
                      // HEX Kodu
                      Text(
                        hexCode,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      // Kopyala Butonu (Görseldeki gibi)
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

            // 4. Kaydet Butonu (Görseldeki gibi)
            FilledButton.icon(
              icon: const Icon(Icons.save_alt_outlined),
              label: const Text('Koleksiyona Kaydet'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () => _savePalette(context),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}