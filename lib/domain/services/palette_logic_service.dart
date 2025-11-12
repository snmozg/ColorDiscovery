// lib/domain/services/palette_logic_service.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:color_discovery/domain/providers/quiz_providers.dart';
import 'package:color_discovery/core/utils/color_utils.dart';
import 'dart:math'; 

// "TONE" KONTROLÜ OLMAYAN TEMİZ HAL
final paletteLogicServiceProvider = Provider<PaletteLogicService>((ref) {
  final quizState = ref.watch(quizStateProvider);
  return PaletteLogicService(quizState: quizState);
});

class PaletteLogicService {
  final quizState; 

  PaletteLogicService({required this.quizState});

  Map<String, List<Color>> getPalette() {
    // 1. Hafızadan 3 soruyu al
    final String projectType = quizState.projectType ?? 'Bilinmeyen';
    final String mood = quizState.mood ?? 'Bilinmeyen';
    final Color? baseColor = quizState.baseColor; 
    // 'tone' buradan kaldırıldı.

    // 2. Temel rengi belirle
    final Color finalBaseColor = baseColor ?? _generateRandomColor();

    String paletteName;
    List<Color> generatedPalette;

    // 3. DUYGU'ya göre oluştur
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
      case 'Lüks':
        paletteName = baseColor != null ? "Lüks Vurgulu Palet" : "Rastgele Lüks Palet";
        var mono = ColorUtils.getMonochromaticPalette(finalBaseColor);
        var comp = ColorUtils.getComplementaryPalette(finalBaseColor);
        generatedPalette = [mono[3], mono[4], finalBaseColor, mono[1], comp[3]];
        break;
      case 'Eğlenceli':
        paletteName = baseColor != null ? "Eğlenceli Üçlü Palet" : "Rastgele Eğlenceli Palet";
        generatedPalette = ColorUtils.getTriadicPalette(finalBaseColor);
        break;
      case 'Doğal':
         paletteName = baseColor != null ? "Doğal Analog Palet" : "Rastgele Doğal Palet";
        generatedPalette = ColorUtils.getAnalogousPalette(finalBaseColor);
        break;
      default:
        paletteName = "Rastgele Palet";
        generatedPalette = ColorUtils.getTriadicPalette(finalBaseColor);
    }
    
    // 4. 'Tone' modifikasyonu buradan kaldırıldı.
    return {paletteName: generatedPalette};
  }

  Color _generateRandomColor() {
    final Random random = Random();
    return HSLColor.fromAHSL(
      1.0, 
      random.nextDouble() * 360, 
      (random.nextDouble() * 0.5) + 0.3, 
      (random.nextDouble() * 0.4) + 0.4, 
    ).toColor();
  }
}