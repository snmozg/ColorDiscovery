// lib/features/tools/presentation/screens/harmony_builder_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart'; // Renk seçici
import 'package:color_discovery/core/utils/color_utils.dart'; // Renk beyni
import 'package:color_discovery/features/discover_quiz/presentation/widgets/palette_preview_card.dart'; // Kart

// YENİ EKLENDİ (KAYDETMEK İÇİN):
import 'package:hive_flutter/hive_flutter.dart';
import 'package:color_discovery/data/models/palette_model.dart';


class HarmonyBuilderScreen extends StatefulWidget {
  const HarmonyBuilderScreen({super.key});

  @override
  State<HarmonyBuilderScreen> createState() => _HarmonyBuilderScreenState();
}

class _HarmonyBuilderScreenState extends State<HarmonyBuilderScreen> {
  Color _currentColor = Colors.deepPurple; // Ana renk

  // YENİ FONKSİYON: Paleti Hive veritabanına kaydeder
  void _savePaletteToHive(String paletteName, List<Color> paletteColors) {
    // 1. Kaydedilecek modeli hazırla
    final newPalette = PaletteModel(
      name: paletteName,
      // Renkleri (Color) veritabanına uygun 'int' listesine çevir
      colors: paletteColors.map((color) => color.value).toList(),
    );

    // 2. Veritabanı 'kutusunu' aç ve modeli kaydet
    final box = Hive.box<PaletteModel>('palettes');
    box.add(newPalette);

    // 3. Kullanıcıya "Kaydedildi!" mesajı göster
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"$paletteName" koleksiyona kaydedildi!'),
          backgroundColor: Colors.green[700],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Renk matematiği
    final complementary = ColorUtils.getComplementaryPalette(_currentColor);
    final triadic = ColorUtils.getTriadicPalette(_currentColor);
    final analogous = ColorUtils.getAnalogousPalette(_currentColor);
    final monochromatic = ColorUtils.getMonochromaticPalette(_currentColor);

    // Kaydederken palete benzersiz bir isim vermek için ana rengin kodunu al
    final String baseHex = '#${_currentColor.value.toRadixString(16).substring(2).toUpperCase()}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Renk Teorisi Yardımcısı'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. Renk Seçici (Değişiklik yok)
            ColorPicker(
              pickerColor: _currentColor,
              onColorChanged: (color) {
                setState(() {
                  _currentColor = color;
                });
              },
              colorPickerWidth: 300.0,
              pickerAreaHeightPercent: 0.7,
              enableAlpha: false,
              displayThumbColor: true,
              paletteType: PaletteType.hsv,
              pickerAreaBorderRadius: const BorderRadius.all(Radius.circular(8.0)),
            ),
            
            const SizedBox(height: 24),
            
            // 2. Seçilen rengi gösteren kutu (Değişiklik yok)
            Text(
              'Seçilen Ana Renk:',
              style: Theme.of(context).textTheme.titleMedium
            ),
            const SizedBox(height: 12),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: _currentColor,
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            const Divider(height: 48),

            Text(
              'Hesaplanan Harmoniler',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // --- GÜNCELLENDİ: 'onSavePressed' eklendi ---
            PalettePreviewCard(
              name: "Tamamlayıcı (Complementary)",
              colors: complementary,
              onSavePressed: () {
                _savePaletteToHive("Tamamlayıcı ($baseHex)", complementary);
              },
            ),
            PalettePreviewCard(
              name: "Üçlü (Triadic)",
              colors: triadic,
              onSavePressed: () {
                 _savePaletteToHive("Üçlü ($baseHex)", triadic);
              },
            ),
            PalettePreviewCard(
              name: "Analog (Analogous)",
              colors: analogous,
              onSavePressed: () {
                 _savePaletteToHive("Analog ($baseHex)", analogous);
              },
            ),
            PalettePreviewCard(
              name: "Monokromatik (Monochromatic)",
              colors: monochromatic,
              onSavePressed: () {
                 _savePaletteToHive("Monokromatik ($baseHex)", monochromatic);
              },
            ),
          ],
        ),
      ),
    );
  }
}