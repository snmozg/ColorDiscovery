// lib/features/discover_quiz/presentation/widgets/palette_preview_card.dart
import 'package:flutter/material.dart';
// import 'dart:ui'; // Blur (ImageFiltered) artık kullanılmıyor.

class PalettePreviewCard extends StatelessWidget {
  const PalettePreviewCard({
    super.key,
    required this.colors,
    required this.name,
    this.onTap, // Tıklanma olayı için
  });

  final List<Color> colors;
  final String name;
  final VoidCallback? onTap; // Kartın tıklanma olayı

  // --- SADE ARKA PLAN ---
  Widget _buildSimpleBackground(BuildContext context) {
    return Container(
      color: Colors.white, // Kartın arka planı tamamen beyaz
    );
  }

  // --- STABİL DİKEY RENK ÇUBUKLARI WIDGET'I ---
  /// Kartın altındaki dikey renk çubuklarını oluşturan widget.
  Widget _buildColorSwatches(List<Color> colors) {
    // Sadece ilk 3 rengi al
    final List<Color> effectiveColors =
        colors.isNotEmpty ? colors.take(3).toList() : [];
    
    // Her bir renk kutusu için sabit yükseklik
    const double swatchHeight = 22.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min, // İçeriği kadar yer kapla
      children: effectiveColors.map((color) {
        return Container(
          height: swatchHeight,
          width: 80, // Renk çubukları sabit genişlikte
          color: color,
          margin: const EdgeInsets.symmetric(vertical: 2.0),
        );
      }).toList(),
    );
  }

  // --- DÜZELTİLMİŞ Ana Widget (build) ---
  @override
  Widget build(BuildContext context) {
    // Palet adı stili
    final TextStyle nameTextStyle =
        (Theme.of(context).textTheme.titleLarge ??
                const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ))
            .copyWith(
      color: Colors.black87,
      letterSpacing: 0.8,
    );

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          // --- ANA DÜZELTME: Sabit Yükseklik (SizedBox) KALDIRILDI ---
          // Artık kartın yüksekliği, onu çağıran GridView'ın
          // 'childAspectRatio' ayarı tarafından belirlenecek.
          child: Stack(
            children: [
              // 1. Sade Beyaz Arka Plan
              Positioned.fill(
                child: _buildSimpleBackground(context),
              ),

              // 2. İçerik
              // 'Column' yapısı, 'Stack' içinde düzgün çalışması için
              // 'Spacer' widget'ları ile yeniden düzenlendi.
              Padding(
                padding: const EdgeInsets.all(12.0), // Her yerden boşluk
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Üst Kısım: Palet Adı
                    Text(
                      name,
                      style: nameTextStyle,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    // Esnek boşluk
                    const Spacer(),

                    // Orta Kısım: Dikey Renk Çubukları
                    _buildColorSwatches(colors),

                    // Esnek boşluk
                    const Spacer(),

                    // Alt Kısım: ">" Butonu (sağ altta)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary, // Lacivert
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 16,
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
    );
  }
}