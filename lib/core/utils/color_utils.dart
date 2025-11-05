// lib/core/utils/color_utils.dart
import 'package:flutter/material.dart';

class ColorUtils {
  
  // --- YARDIMCI FONKSİYONLAR (Artık 'public') ---
  // '_' (alt çizgi) kaldırıldı

  /// Bir rengin daha AÇIK bir tonunu (tint) üretir
  static Color getTint(Color color, [double amount = 0.2]) {
    final HSLColor hsl = HSLColor.fromColor(color);
    final double newLightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(newLightness).toColor();
  }

  /// Bir rengin daha KOYU bir tonunu (shade) üretir
  static Color getShade(Color color, [double amount = 0.2]) {
    final HSLColor hsl = HSLColor.fromColor(color);
    final double newLightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(newLightness).toColor();
  }

  /// İki renk arasındaki orta noktayı bulur
  static Color lerp(Color a, Color b, [double t = 0.5]) {
    return Color.lerp(a, b, t)!;
  }

  // --- ANA HESAPLAMA FONKSİYONLARI (Hepsi 5 Renk Döndürür) ---
  // (Bunlar artık 'public' yardımcıları kullanıyor)

  static List<Color> getComplementaryPalette(Color baseColor) {
    final HSLColor hslBase = HSLColor.fromColor(baseColor);
    final double complementaryHue = (hslBase.hue + 180.0) % 360.0;
    final Color complementaryColor = hslBase.withHue(complementaryHue).toColor();

    return [
      getTint(baseColor, 0.3),    // 1.
      getTint(baseColor, 0.1),    // 2.
      baseColor,                   // 3.
      complementaryColor,          // 4.
      getShade(complementaryColor, 0.1) // 5.
    ];
  }

  static List<Color> getTriadicPalette(Color baseColor) {
    final HSLColor hslBase = HSLColor.fromColor(baseColor);
    final double hue1 = (hslBase.hue + 120.0) % 360.0;
    final double hue2 = (hslBase.hue + 240.0) % 360.0;
    
    final Color color1 = hslBase.withHue(hue1).toColor();
    final Color color2 = hslBase.withHue(hue2).toColor();

    return [
      baseColor,            // 1.
      color1,               // 2.
      color2,               // 3.
      getTint(baseColor),   // 4.
      getShade(color1),     // 5.
    ];
  }

  static List<Color> getAnalogousPalette(Color baseColor) {
    final HSLColor hslBase = HSLColor.fromColor(baseColor);
    final double hue1 = (hslBase.hue + 30.0) % 360.0;
    final double hue2 = (hslBase.hue - 30.0 + 360.0) % 360.0;
    
    final Color color1 = hslBase.withHue(hue1).toColor();
    final Color color2 = hslBase.withHue(hue2).toColor();

    return [
      getShade(baseColor, 0.3), // 1.
      getShade(baseColor, 0.1), // 2.
      baseColor,                 // 3.
      color1,                    // 4.
      color2,                    // 5.
    ];
  }

  static List<Color> getMonochromaticPalette(Color baseColor) {
    final HSLColor hslBase = HSLColor.fromColor(baseColor);

    return [
      hslBase.withLightness((hslBase.lightness + 0.4).clamp(0.0, 1.0)).toColor(), // 1.
      hslBase.withLightness((hslBase.lightness + 0.2).clamp(0.0, 1.0)).toColor(), // 2.
      baseColor,                                                            // 3.
      hslBase.withLightness((hslBase.lightness - 0.2).clamp(0.0, 1.0)).toColor(), // 4.
      hslBase.withLightness((hslBase.lightness - 0.4).clamp(0.0, 1.0)).toColor(), // 5.
    ];
  }
}