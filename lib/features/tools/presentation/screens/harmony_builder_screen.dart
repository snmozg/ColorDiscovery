// lib/features/tools/presentation/screens/harmony_builder_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart'; // Renk seçici
import 'package:color_discovery/core/utils/color_utils.dart'; // Renk beyni
import 'package:color_discovery/features/discover_quiz/presentation/widgets/palette_preview_card.dart'; // Kart

// KAYDETMEK İÇİN GEREKLİ IMPORT'LAR
import 'package:hive_flutter/hive_flutter.dart';
import 'package:color_discovery/data/models/palette_model.dart';

class HarmonyBuilderScreen extends StatefulWidget {
  const HarmonyBuilderScreen({super.key});

  @override
  State<HarmonyBuilderScreen> createState() => _HarmonyBuilderScreenState();
}

class _HarmonyBuilderScreenState extends State<HarmonyBuilderScreen> {
  Color _currentColor = Colors.deepPurple; // Ana renk

  // --- YENİ FONKSİYON: Tüm 4 paleti Hive'a kaydeder ---
  void _saveAllHarmonies() {
    // 1. Gerekli tüm paletleri ve isimlerini hesapla
    final complementary = ColorUtils.getComplementaryPalette(_currentColor);
    final triadic = ColorUtils.getTriadicPalette(_currentColor);
    final analogous = ColorUtils.getAnalogousPalette(_currentColor);
    final monochromatic = ColorUtils.getMonochromaticPalette(_currentColor);
    final String baseHex =
        '#${_currentColor.value.toRadixString(16).substring(2).toUpperCase()}';

    // 2. Kaydedilecek modellerin bir listesini oluştur
    final List<PaletteModel> palettesToSave = [
      PaletteModel(
        name: "Tamamlayıcı ($baseHex)",
        colors: complementary.map((c) => c.value).toList(),
      ),
      PaletteModel(
        name: "Üçlü ($baseHex)",
        colors: triadic.map((c) => c.value).toList(),
      ),
      PaletteModel(
        name: "Analog ($baseHex)",
        colors: analogous.map((c) => c.value).toList(),
      ),
      PaletteModel(
        name: "Monokromatik ($baseHex)",
        colors: monochromatic.map((c) => c.value).toList(),
      ),
    ];

    // 3. Veritabanı 'kutusunu' aç ve tüm listeyi tek seferde kaydet
    final box = Hive.box<PaletteModel>('palettes');
    box.addAll(palettesToSave);

    // 4. Kullanıcıya *tek bir* "Kaydedildi!" mesajı göster
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('4 harmoni koleksiyona kaydedildi!'),
          backgroundColor: Colors.green[700],
        ),
      );
    }
  }
  
  // --- ESKİ '_savePaletteToHive' FONKSİYONU SİLİNDİ ---

  @override
  Widget build(BuildContext context) {
    // Renk matematiği (Kartları çizmek için burada kalmalı)
    final complementary = ColorUtils.getComplementaryPalette(_currentColor);
    final triadic = ColorUtils.getTriadicPalette(_currentColor);
    final analogous = ColorUtils.getAnalogousPalette(_currentColor);
    final monochromatic = ColorUtils.getMonochromaticPalette(_currentColor);

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
              pickerAreaBorderRadius:
                  const BorderRadius.all(Radius.circular(8.0)),
            ),

            const SizedBox(height: 24),

            // 2. Seçilen rengi gösteren kutu (Değişiklik yok)
            Text('Seçilen Ana Renk:',
                style: Theme.of(context).textTheme.titleMedium),
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

            // --- GÜNCELLENDİ: 'onSavePressed' parametreleri kaldırıldı ---
            PalettePreviewCard(
              name: "Tamamlayıcı (Complementary)",
              colors: complementary,
              // onTap artık bu kartta mevcut, detay sayfasına gitmek için
              // ancak bu ekranda bir detay sayfası mantığı kurmadık.
              // Bu yüzden 'onTap' boş bırakılabilir.
            ),
            PalettePreviewCard(
              name: "Üçlü (Triadic)",
              colors: triadic,
            ),
            PalettePreviewCard(
              name: "Analog (Analogous)",
              colors: analogous,
            ),
            PalettePreviewCard(
              name: "Monokromatik (Monochromatic)",
              colors: monochromatic,
            ),

            // --- YENİ EKLENDİ: Ana Kaydet Butonu ---
            const SizedBox(height: 32),
            FilledButton.icon(
              icon: const Icon(Icons.save_alt_outlined),
              label: const Text('Tüm Harmonileri Kaydet'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _saveAllHarmonies, // Yeni fonksiyonu çağır
            ),
            const SizedBox(height: 16), // Altta boşluk
          ],
        ),
      ),
    );
  }
}