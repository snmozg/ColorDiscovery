// lib/presentation/widgets/app_logo.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 60, // Logonun varsayılan boyutu
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    // 3 adet üst üste binen daire
    return Stack(
      alignment: Alignment.center,
      children: [
        // Arka Daire (Mavi)
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
          ),
        )
        .animate(
          onPlay: (controller) => controller.repeat(reverse: true),
        )
        .moveX(begin: -size * 0.1, end: size * 0.1, duration: 2000.ms, curve: Curves.easeInOut)
        //
        // HATA DÜZELTİLDİ: Hatalı 'amount'/'amplitude' parametreleri kaldırıldı.
        // Sadece 'hz' (frekans) yeterli.
        //
        .shake(hz: 2), 

        // Orta Daire (İkincil Renk)
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
          ),
        )
        .animate(
          onPlay: (controller) => controller.repeat(reverse: true),
        )
        .moveX(begin: size * 0.1, end: -size * 0.1, duration: 2000.ms, curve: Curves.easeInOut)
        //
        // HATA DÜZELTİLDİ: Parametre kaldırıldı.
        //
        .shake(hz: 1.5),

        // Ön Daire (Üçüncül Renk)
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.7),
          ),
        )
        .animate(
          onPlay: (controller) => controller.repeat(reverse: true),
        )
        .moveY(begin: -size * 0.1, end: size * 0.1, duration: 2000.ms, curve: Curves.easeInOut)
        //
        // HATA DÜZELTİLDİ: Parametre kaldırıldı.
        //
        .shake(hz: 1),
      ],
    );
  }
}