// lib/features/discover_quiz/presentation/screens/quiz_loading_screen.dart
import 'package:flutter/material.dart';
// Lottie'yi sildik, çünkü o hata veriyordu.
// import 'package:lottie/lottie.dart'; 

class QuizLoadingScreen extends StatefulWidget {
  const QuizLoadingScreen({super.key});

  @override
  State<QuizLoadingScreen> createState() => _QuizLoadingScreenState();
}

class _QuizLoadingScreenState extends State<QuizLoadingScreen> {
  @override
  void initState() {
    super.initState();
    // "Analiz ediliyor" hissini vermek için 2 saniye beklet
    _navigateToResults();
  }

  void _navigateToResults() {
    // 3 saniye yerine 2 saniyeye düşürdüm, daha hızlı
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        // Bir önceki ekrana (quiz_start_screen) "true" döndür
        Navigator.of(context).pop(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //
            // DEĞİŞİKLİK BURADA:
            // Hata veren 'Lottie.network' yerine Flutter'ın kendi
            // güvenilir yükleme göstergesini koyduk.
            const CircularProgressIndicator(
              strokeWidth: 5,
            ),
            //
            //
            const SizedBox(height: 32),
            Text(
              'Paletiniz oluşturuluyor...',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Projeniz için en iyi renkler analiz ediliyor.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}