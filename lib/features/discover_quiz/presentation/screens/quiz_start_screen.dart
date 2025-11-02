// lib/features/discover_quiz/presentation/screens/quiz_start_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:color_discovery/domain/providers/quiz_providers.dart';
import 'package:color_discovery/features/discover_quiz/presentation/widgets/quiz_option_card.dart';
// YENİ EKLENEN IMPORT'LAR
import 'package:color_discovery/features/discover_quiz/presentation/screens/quiz_loading_screen.dart';
import 'package:color_discovery/features/discover_quiz/presentation/screens/quiz_results_screen.dart';

// Bu 'lokal' provider, SADECE bu ekranda hangi adımda olduğumuzu tutar.
// .autoDispose -> bu ekrandan çıkınca hafızası (adım sayısı) sıfırlanır.
final _quizStepProvider = StateProvider.autoDispose<int>((ref) => 1); // 1. Adımla başla

class QuizStartScreen extends ConsumerWidget {
  const QuizStartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Hangi adımda olduğumuzu bu provider'dan dinle
    final currentStep = ref.watch(_quizStepProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Palet Oluştur'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          // Hangi adımı göstereceğimizi seçen 'switch'
          child: currentStep == 1
              ? _buildStep1(context, ref) // Soru 1'i göster
              : _buildStep2(context, ref), // Soru 2'yi göster
        ),
      ),
    );
  }

  // Soru 1 (Proje Tipi)
  Widget _buildStep1(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Ne tasarlıyorsun?',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: (1 / 1.2), // Taşma hatası için
              children: [
                QuizOptionCard(
                  title: 'Mobil Uygulama',
                  icon: Icons.phone_android,
                  onTap: () {
                    // 1. Ana hafızaya seçimi kaydet
                    ref
                        .read(quizStateProvider.notifier)
                        .setProjectType('Mobil Uygulama');
                    // 2. Lokal adımı 2'ye yükselt
                    ref.read(_quizStepProvider.notifier).state = 2;
                  },
                ),
                QuizOptionCard(
                  title: 'Web Sitesi',
                  icon: Icons.web,
                  onTap: () {
                    ref
                        .read(quizStateProvider.notifier)
                        .setProjectType('Web Sitesi');
                    ref.read(_quizStepProvider.notifier).state = 2;
                  },
                ),
                QuizOptionCard(
                  title: 'Logo & Marka',
                  icon: Icons.design_services,
                  onTap: () {
                    ref
                        .read(quizStateProvider.notifier)
                        .setProjectType('Logo & Marka');
                    ref.read(_quizStepProvider.notifier).state = 2;
                  },
                ),
                QuizOptionCard(
                  title: 'Oyun Arayüzü',
                  icon: Icons.sports_esports,
                  onTap: () {
                    ref
                        .read(quizStateProvider.notifier)
                        .setProjectType('Oyun Arayüzü');
                    ref.read(_quizStepProvider.notifier).state = 2;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Soru 2 (Duygu/Mod)
  Widget _buildStep2(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Nasıl bir his vermeli?',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: (1 / 1.2), // Taşma hatası için
              children: [
                QuizOptionCard(
                  title: 'Sakin & Huzurlu',
                  icon: Icons.self_improvement,
                  onTap: () {
                    // 1. Ana hafızaya seçimi kaydet
                    ref.read(quizStateProvider.notifier).setMood('Sakin');
                    // 2. Sonuçlara git
                    _navigateToResults(context, ref);
                  },
                ),
                QuizOptionCard(
                  title: 'Enerjik & Canlı',
                  icon: Icons.flash_on,
                  onTap: () {
                    ref.read(quizStateProvider.notifier).setMood('Enerjik');
                    _navigateToResults(context, ref);
                  },
                ),
                QuizOptionCard(
                  title: 'Profesyonel & Güvenilir',
                  icon: Icons.work,
                  onTap: () {
                    ref
                        .read(quizStateProvider.notifier)
                        .setMood('Profesyonel');
                    _navigateToResults(context, ref);
                  },
                ),
                QuizOptionCard(
                  title: 'Gizemli & Merak Uyandırıcı',
                  icon: Icons.visibility_off,
                  onTap: () {
                    ref
                        .read(quizStateProvider.notifier)
                        .setMood('Gizemli');
                    _navigateToResults(context, ref);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //
  // SON GÜNCELLENEN KISIM BURASI
  //
  // Sonuçlara Yönlendirme Fonksiyonu
  void _navigateToResults(BuildContext context, WidgetRef ref) async {
    // 1. Animasyon ekranına git ve bitmesini bekle
    // (push -> yeni bir ekran açar)
    final bool? analysisDone = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => const QuizLoadingScreen(),
      ),
    );

    // 2. Animasyon bittiyse (true döndürdüyse) ve ekran hala görünürse
    if (analysisDone == true && context.mounted) {
      // Sonuç ekranına git (mevcut Test ekranını onunla değiştir)
      // (pushReplacement -> mevcut ekranı (quiz_start_screen) kapatır, yenisini açar)
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const QuizResultsScreen(),
        ),
      );
    }
  }
}