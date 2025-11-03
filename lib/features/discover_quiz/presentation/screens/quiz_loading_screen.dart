// lib/features/discover_quiz/presentation/screens/quiz_loading_screen.dart
import 'package:flutter/material.dart';
// LOTTIE'Yİ GERİ GETİRDİK!
import 'package:lottie/lottie.dart'; 

class QuizLoadingScreen extends StatefulWidget {
  const QuizLoadingScreen({super.key});

  @override
  State<QuizLoadingScreen> createState() => _QuizLoadingScreenState();
}

class _QuizLoadingScreenState extends State<QuizLoadingScreen> {
  @override
  void initState() {
    super.initState();
    // "Analiz ediliyor" hissini vermek için 3 saniye beklet
    _navigateToResults();
  }

  void _navigateToResults() {
    Future.delayed(const Duration(seconds: 3), () {
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
            // Sıkıcı dönen daire yerine, artık çalışan Lottie animasyonu
            //
            Lottie.network(
              // Bu, test edilmiş, çalışan bir Lottie URL'idir
              'https://assets10.lottiefiles.com/packages/lf20_p8bfn5to.json',
              width: 250,
              height: 250,
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