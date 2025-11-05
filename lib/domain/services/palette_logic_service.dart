// lib/domain/services/palette_logic_service.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:color_discovery/domain/providers/quiz_providers.dart';
import 'package:color_discovery/core/utils/color_utils.dart';
import 'dart:math';

// Provider (Değişiklik yok)
final paletteLogicServiceProvider = Provider<PaletteLogicService>((ref) {
  final quizState = ref.watch(quizStateProvider);
  return PaletteLogicService(quizState: quizState);
});

// İş mantığı sınıfı
class PaletteLogicService {
  final quizState; 

  PaletteLogicService({required this.quizState});

  // 'getPalette' fonksiyonu TAMAMEN GÜNCELLENDİ
  Map<String, List<Color>> getPalette() {
    // 1. Hafızadan TÜM 4 soruyu al
    final String projectType = quizState.projectType ?? 'Bilinmeyen';
    final String mood = quizState.mood ?? 'Bilinmeyen';
    final Color? baseColor = quizState.baseColor;
    final String tone = quizState.tone ?? 'Fark Etmez'; // YENİ: Ton'u al

    // 2. Temel rengi belirle (Rastgele veya Seçilen)
    final Color finalBaseColor = baseColor ?? _generateRandomColor();

    String paletteName;
    List<Color> basePalette; // Bu, 'Ton' uygulanmamış ham palet

    // 3. ADIM: Paleti DUYGU'ya göre oluştur (YENİ DUYGULAR EKLENDİ)
    switch (mood) {
      case 'Sakin':
        paletteName = baseColor != null ? "Sakin Analog Palet" : "Rastgele Sakin Palet";
        basePalette = ColorUtils.getAnalogousPalette(finalBaseColor);
        break;
      case 'Enerjik':
        paletteName = baseColor != null ? "Enerjik Tamamlayıcı Palet" : "Rastgele Enerjik Palet";
        basePalette = ColorUtils.getComplementaryPalette(finalBaseColor);
        break;
      case 'Profesyonel':
        paletteName = baseColor != null ? "Profesyonel Monokromatik Palet" : "Rastgele Profesyonel Palet";
        basePalette = ColorUtils.getMonochromaticPalette(finalBaseColor);
        break;
      
      // SENİN İSTEDİĞİN YENİ DUYGULAR:
      case 'Lüks':
        paletteName = baseColor != null ? "Lüks Vurgulu Palet" : "Rastgele Lüks Palet";
        // Lüks = Koyu tonlar + Zıt bir vurgu
        var mono = ColorUtils.getMonochromaticPalette(finalBaseColor);
        var comp = ColorUtils.getComplementaryPalette(finalBaseColor);
        basePalette = [mono[3], mono[4], finalBaseColor, mono[1], comp[3]]; // Koyu, En Koyu, Ana, Açık, Zıt
        break;
      case 'Eğlenceli':
        paletteName = baseColor != null ? "Eğlenceli Üçlü Palet" : "Rastgele Eğlenceli Palet";
        basePalette = ColorUtils.getTriadicPalette(finalBaseColor);
        break;
      case 'Doğal':
         paletteName = baseColor != null ? "Doğal Analog Palet" : "Rastgele Doğal Palet";
         // Doğal renkler genellikle yakın tonlardır
        basePalette = ColorUtils.getAnalogousPalette(finalBaseColor);
        break;
      
      // 'Gizemli' (eski) ve diğerleri buraya düşüyor
      default:
        paletteName = "Rastgele Palet";
        basePalette = ColorUtils.getTriadicPalette(finalBaseColor);
    }
    
    // 4. ADIM (YENİ): Paleti SORU 4'e ("TON") göre MODİFİYE ET
    
    List<Color> finalPalette;

    switch (tone) {
      case 'Açık':
        // Palet'i "Açık & Havadar" yap
        paletteName = "$paletteName (Açık Ton)";
        // 'map' kullanarak 5 rengi de 'getTint' fonksiyonundan geçir
        finalPalette = basePalette.map((color) => ColorUtils.getTint(color, 0.25)).toList();
        break;
      case 'Koyu':
        // Palet'i "Koyu & Dramatik" yap
        paletteName = "$paletteName (Koyu Ton)";
        // 'map' kullanarak 5 rengi de 'getShade' fonksiyonundan geçir
        finalPalette = basePalette.map((color) => ColorUtils.getShade(color, 0.25)).toList();
        break;
      
      // 'Dengeli' veya 'Fark Etmez' seçildiyse
      case 'Dengeli':
      case 'Fark Etmez':
      default:
        // Ham palete dokunma, 'Dengeli' halini kullan
        finalPalette = basePalette;
    }

    // 5. Modifiye edilmiş son paleti döndür
    return {paletteName: finalPalette};
  }

  // Rastgele renk üretici (Değişiklik yok)
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