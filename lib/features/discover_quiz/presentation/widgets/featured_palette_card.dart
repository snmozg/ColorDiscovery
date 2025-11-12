// lib/features/discover_quiz/presentation/widgets/featured_palette_card.dart
import 'package:flutter/material.dart';
// import 'dart:ui'; // DONMAYA NEDEN OLAN 'ImageFiltered' KALDIRILDI

class FeaturedPaletteCard extends StatelessWidget {
  const FeaturedPaletteCard({
    super.key,
    required this.name,
    required this.colors,
    this.onTap,
  });

  final String name;
  final List<Color> colors;
  final VoidCallback? onTap;

  // --- GÜNCELLENDİ: Daha Koyu Camsı Arka Plan (BLUR OLMADAN) ---
  Widget _buildGradientBackground(BuildContext context) {
    final List<Color> effectiveColors = colors.isNotEmpty
        ? colors.take(3).toList()
        : [Colors.blueGrey.shade900, Colors.blueGrey.shade800];

    final List<Color> gradientColors = effectiveColors.length > 1
        ? effectiveColors
        : [effectiveColors.first, effectiveColors.first.withOpacity(0.7)];

    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Ana Gradyan Arka Plan
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
          ),
        ),
        
        // 2. BLUR YERİNE KOYU CAMSI KATMAN
        // 'ImageFiltered' kaldırıldı.
        // Opaklığı 0.50'ye ayarlayarak istediğiniz koyu camsı etkiyi veriyoruz.
        Container(
          color: Colors.black.withOpacity(0.50), // 0.25 idi, şimdi daha koyu
        ),
      ],
    );
  }
  // --- GÜNCELLEME BİTTİ ---

  // Dikey Renk Çubukları Metodu
  Widget _buildColorSwatches() {
    final List<Color> effectiveColors = colors.isNotEmpty
        ? colors.take(3).toList()
        : [Colors.grey.shade500, Colors.grey.shade600, Colors.grey.shade700];

    return Container(
      width: 60,
      decoration: const BoxDecoration(
        // Çerçevesiz, karartısız
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: effectiveColors.map((color) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 2.5),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6.0),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: SizedBox(
            height: 120,
            child: Stack(
              children: [
                // Koyu ve Blursuz Arka Plan
                Positioned.fill(
                  child: _buildGradientBackground(context),
                ),
                // İçerik
                Positioned.fill(
                  child: Row(
                    children: [
                      // Sol Taraf: Dikey Renkler
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: _buildColorSwatches(),
                      ),
                      // Sağ Taraf: Palet Adı
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            name,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                  shadows: [
                                    const Shadow(
                                      color: Colors.black54,
                                      blurRadius: 4,
                                      offset: Offset(1, 1),
                                    ),
                                  ],
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}