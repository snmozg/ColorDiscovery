// lib/domain/services/palette_logic_service.dart
import 'package:flutter/material.dart'; // 'Color' VE 'HSLColor' BURADAN GELİYOR
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:color_discovery/domain/providers/quiz_providers.dart';

// Renk Matematiği Beynini import ediyoruz
import 'package:color_discovery/core/utils/color_utils.dart';
import 'dart:math'; // RASTGELE renk için eklendi

// Provider (Değişiklik yok)
final paletteLogicServiceProvider = Provider<PaletteLogicService>((ref) {
  final quizState = ref.watch(quizStateProvider);
  return PaletteLogicService(quizState: quizState);
});

// İş mantığı sınıfı
class PaletteLogicService {
  final quizState; 

  PaletteLogicService({required this.quizState});

  // 'getPalette' fonksiyonu
  Map<String, List<Color>> getPalette() {
    // 1. Hafızadan seçimleri al
    final String projectType = quizState.projectType ?? 'Bilinmeyen';
    final String mood = quizState.mood ?? 'Bilinmeyen';
    final Color? baseColor = quizState.baseColor; // Opsiyonel temel renk!

    // 2. BEYİN KONTROLÜ:
    final Color finalBaseColor = baseColor ?? _generateRandomColor();

    String paletteName;
    List<Color> generatedPalette;

    // 3. SEÇİLEN DUYGUYA GÖRE, 'ColorUtils' BEYNİMİZİ KULLAN
    switch (mood) {
      case 'Sakin':
        paletteName = baseColor != null ? "Sakin Analog Palet" : "Rastgele Sakin Palet";
        generatedPalette = ColorUtils.getAnalogousPalette(finalBaseColor);
        break;
      case 'Enerjik':
        paletteName = baseColor != null ? "Enerjik Tamamlayıcı Palet" : "Rastgele Enerjik Palet";
        generatedPalette = ColorUtils.getComplementaryPalette(finalBaseColor);
        break;
      case 'Profesyonel':
        paletteName = baseColor != null ? "Profesyonel Monokromatik Palet" : "Rastgele Profesyonel Palet";
        generatedPalette = ColorUtils.getMonochromaticPalette(finalBaseColor);
        break;
      case 'Gizemli':
        paletteName = baseColor != null ? "Gizemli Üçlü Palet" : "Rastgele Gizemli Palet";
        generatedPalette = ColorUtils.getTriadicPalette(finalBaseColor);
        break;
      default:
        paletteName = "Rastgele Palet";
        generatedPalette = ColorUtils.getTriadicPalette(finalBaseColor);
    }
    
    return {paletteName: generatedPalette};
  }

  // YENİ FONKSİYON: Rastgele, canlı bir renk üreten yardımcı
  Color _generateRandomColor() {
    final Random random = Random();
    // Çok koyu veya çok soluk olmayan, "canlı" bir renk üret
    return HSLColor.fromAHSL(
      1.0, // Opaklık
      random.nextDouble() * 360, // Renk Tonu (Hue)
      (random.nextDouble() * 0.5) + 0.3, // Doygunluk (Saturation) (0.3 - 0.8 arası)
      (random.nextDouble() * 0.4) + 0.4, // Parlaklık (Lightness) (0.4 - 0.8 arası)
    ).toColor();
  }
}