// lib/core/utils/color_utils.dart
import 'package:flutter/material.dart';

class ColorUtils {
  
  // --- YARDIMCI FONKSİYONLAR (Ara Tonlar İçin) ---

  /// Bir rengin daha AÇIK bir tonunu (tint) üretir
  static Color _getTint(Color color, [double amount = 0.2]) {
    final HSLColor hsl = HSLColor.fromColor(color);
    // Parlaklığı (lightness) artır (ama 1.0'ı geçmesin)
    final double newLightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(newLightness).toColor();
  }

  /// Bir rengin daha KOYU bir tonunu (shade) üretir
  static Color _getShade(Color color, [double amount = 0.2]) {
    final HSLColor hsl = HSLColor.fromColor(color);
    // Parlaklığı (lightness) azalt (ama 0.0'ın altına düşmesin)
    final double newLightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(newLightness).toColor();
  }

  /// İki renk arasındaki orta noktayı bulur (interpolation)
  static Color _lerp(Color a, Color b, [double t = 0.5]) {
    return Color.lerp(a, b, t)!;
  }

  // --- ANA HESAPLAMA FONKSİYONLARI (Hepsi 5 Renk Döndürür) ---

  /// Bir ana renge göre TAMAMLAYICI (Complementary) paleti döndürür.
  /// ARTIK HER ZAMAN 5 RENK.
  static List<Color> getComplementaryPalette(Color baseColor) {
    final HSLColor hslBase = HSLColor.fromColor(baseColor);
    final double complementaryHue = (hslBase.hue + 180.0) % 360.0;
    final Color complementaryColor = hslBase.withHue(complementaryHue).toColor();

    return [
      _getTint(baseColor, 0.3),    // 1. Ana Rengin Açık Tonu
      _getTint(baseColor, 0.1),    // 2. Ana Rengin Az Açık Tonu
      baseColor,                   // 3. Ana Renk (Merkez)
      complementaryColor,          // 4. Zıt Renk
      _getShade(complementaryColor, 0.1) // 5. Zıt Rengin Koyu Tonu
    ];
  }

  /// Bir ana renge göre ÜÇLÜ (Triadic) paleti döndürür.
  /// ARTIK HER ZAMAN 5 RENK.
  static List<Color> getTriadicPalette(Color baseColor) {
    final HSLColor hslBase = HSLColor.fromColor(baseColor);
    final double hue1 = (hslBase.hue + 120.0) % 360.0;
    final double hue2 = (hslBase.hue + 240.0) % 360.0;
    
    final Color color1 = hslBase.withHue(hue1).toColor();
    final Color color2 = hslBase.withHue(hue2).toColor();

    return [
      baseColor,            // 1. Ana Renk
      color1,               // 2. Üçlü Renk 1
      color2,               // 3. Üçlü Renk 2
      _getTint(baseColor),  // 4. Ana Rengin Açık Tonu
      _getShade(color1),    // 5. Üçlü 1'in Koyu Tonu
    ];
  }

  /// Bir ana renge göre ANALOG (Analogous) paleti döndürür.
  /// ARTIK HER ZAMAN 5 RENK.
  static List<Color> getAnalogousPalette(Color baseColor) {
    final HSLColor hslBase = HSLColor.fromColor(baseColor);
    final double hue1 = (hslBase.hue + 30.0) % 360.0;
    final double hue2 = (hslBase.hue - 30.0 + 360.0) % 360.0;
    
    final Color color1 = hslBase.withHue(hue1).toColor();
    final Color color2 = hslBase.withHue(hue2).toColor();

    return [
      _getShade(baseColor, 0.3), // 1. Ana Rengin Koyu Tonu (Arka Plan)
      _getShade(baseColor, 0.1), // 2. Ana Rengin Az Koyu Tonu
      baseColor,                 // 3. Ana Renk
      color1,                    // 4. Yakın Renk 1
      color2,                    // 5. Yakın Renk 2
    ];
  }

  /// Bir ana renge göre MONOKROMATİK paleti döndürür.
  /// ARTIK HER ZAMAN 5 RENK.
  static List<Color> getMonochromaticPalette(Color baseColor) {
    final HSLColor hslBase = HSLColor.fromColor(baseColor);

    // Aynı rengin 5 farklı parlaklık tonunu oluştur
    return [
      hslBase.withLightness((hslBase.lightness + 0.4).clamp(0.0, 1.0)).toColor(), // 1. En Açık
      hslBase.withLightness((hslBase.lightness + 0.2).clamp(0.0, 1.0)).toColor(), // 2. Açık
      baseColor,                                                            // 3. Ana Renk
      hslBase.withLightness((hslBase.lightness - 0.2).clamp(0.0, 1.0)).toColor(), // 4. Koyu
      hslBase.withLightness((hslBase.lightness - 0.4).clamp(0.0, 1.0)).toColor(), // 5. En Koyu
    ];
  }
}