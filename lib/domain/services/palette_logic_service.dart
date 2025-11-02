// lib/domain/services/palette_logic_service.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:color_discovery/domain/providers/quiz_providers.dart';

// 1. Bu servisi UI'da çağırmak için bir Provider oluştur
final paletteLogicServiceProvider = Provider<PaletteLogicService>((ref) {
  // Bu servis, kararı verebilmek için quiz'in hafızasına (quizStateProvider) ihtiyaç duyar
  final quizState = ref.watch(quizStateProvider);
  return PaletteLogicService(quizState: quizState);
});

// 2. İş mantığımızın (Beynimizin) yaşadığı sınıf
class PaletteLogicService {
  final quizState; // Hafızadaki seçimler

  PaletteLogicService({required this.quizState});

  // 'getPalette' fonksiyonunu buraya taşıdık!
  Map<String, List<Color>> getPalette() {
    final String projectType = quizState.projectType ?? 'Bilinmeyen';
    final String mood = quizState.mood ?? 'Bilinmeyen';

    if (projectType == 'Mobil Uygulama' && mood == 'Sakin') {
      return {
        "Sakin Mobil Uygulama": [
          const Color(0xFFE0E5EC), // Açık Gri (Arka Plan)
          const Color(0xFF4A90E2), // Mavi (Ana)
          const Color(0xFF50E3C2), // Yeşil (Vurgu)
          const Color(0xFF34495E), // Koyu Mavi (Metin)
          const Color(0xFFF4F7F9), // Çok Açık Gri (Kart)
        ]
      };
    }

    if (projectType == 'Web Sitesi' && mood == 'Profesyonel') {
       return {
        "Kurumsal Web Sitesi": [
          const Color(0xFF003049), // Koyu Mavi
          const Color(0xFFD62828), // Kırmızı
          const Color(0xFFF77F00), // Turuncu
          const Color(0xFFFCBF49), // Sarı
          const Color(0xFFEAE2B7), // Bej
        ]
      };
    }
    
    // Diğer tüm seçimler için varsayılan Palet
    return {
      "Enerjik Palet": [
        const Color(0xFFF94144),
        const Color(0xFFF3722C),
        const Color(0xFFF8961E),
        const Color(0xFFF9C74F),
        const Color(0xFF90BE6D),
      ]
    };
  }
}