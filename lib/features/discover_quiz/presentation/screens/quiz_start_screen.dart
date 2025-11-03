// lib/features/discover_quiz/presentation/screens/quiz_start_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:color_discovery/domain/providers/quiz_providers.dart';
import 'package:color_discovery/features/discover_quiz/presentation/widgets/quiz_option_card.dart';
import 'package:color_discovery/features/discover_quiz/presentation/screens/quiz_loading_screen.dart';
import 'package:color_discovery/features/discover_quiz/presentation/screens/quiz_results_screen.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart'; 

// Hangi adımda olduğumuzu tutan lokal provider
final _quizStepProvider = StateProvider.autoDispose<int>((ref) => 1); // 1. Adımla başla
// Seçilen temel rengi *geçici* olarak tutan lokal provider
final _tempColorProvider = StateProvider.autoDispose<Color>((ref) => Colors.deepPurple);

class QuizStartScreen extends ConsumerWidget {
  const QuizStartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          // Geçiş animasyonu
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400), 
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            // 3 adımlı akış
            child: switch (currentStep) {
              1 => _buildStep1(context, ref), // Proje Tipi
              2 => _buildStep2(context, ref), // YENİ: Temel Renk (Senin istediğin)
              3 => _buildStep3(context, ref), // YENİ: Duygu/Mod (Son adım)
              _ => _buildStep1(context, ref), // Varsayılan
            },
          ),
        ),
      ),
    );
  }

  // Soru 1 (Proje Tipi) - (Adım 2'ye yönlendirir - Değişiklik yok)
  Widget _buildStep1(BuildContext context, WidgetRef ref) {
    return Center(
      key: const ValueKey('Step1'), 
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Ne tasarlıyorsun?', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: (1 / 1.2), 
              children: [
                QuizOptionCard(title: 'Mobil Uygulama', icon: Icons.phone_android, onTap: () { ref.read(quizStateProvider.notifier).setProjectType('Mobil Uygulama'); ref.read(_quizStepProvider.notifier).state = 2; }),
                QuizOptionCard(title: 'Web Sitesi', icon: Icons.web, onTap: () { ref.read(quizStateProvider.notifier).setProjectType('Web Sitesi'); ref.read(_quizStepProvider.notifier).state = 2; }),
                QuizOptionCard(title: 'Logo & Marka', icon: Icons.design_services, onTap: () { ref.read(quizStateProvider.notifier).setProjectType('Logo & Marka'); ref.read(_quizStepProvider.notifier).state = 2; }),
                QuizOptionCard(title: 'Oyun Arayüzü', icon: Icons.sports_esports, onTap: () { ref.read(quizStateProvider.notifier).setProjectType('Oyun Arayüzü'); ref.read(_quizStepProvider.notifier).state = 2; }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // YENİ SIRALAMA: Soru 2 (Temel Renk Seçimi)
  Widget _buildStep2(BuildContext context, WidgetRef ref) {
    // Geçici olarak seçilen rengi lokal provider'dan izle
    final Color tempColor = ref.watch(_tempColorProvider);

    return Center(
      key: const ValueKey('Step2_Color'), // 'Key' adını değiştirdik
      // Kaydırma (scroll) özelliği ekle
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Belirli bir temel rengin var mı?', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            
            // Renk Seçici
            ColorPicker(
              pickerColor: tempColor,
              onColorChanged: (color) {
                // Rengi geçici hafızaya yaz
                ref.read(_tempColorProvider.notifier).state = color;
              },
              colorPickerWidth: 300.0,
              pickerAreaHeightPercent: 0.7,
              enableAlpha: false,
              displayThumbColor: true,
              paletteType: PaletteType.hsv,
              pickerAreaBorderRadius: const BorderRadius.all(Radius.circular(8.0)),
            ),
            
            const SizedBox(height: 24),

            // Karar Butonları (Adım 3'e yönlendirir)
            ElevatedButton(
              onPressed: () {
                // 1. Geçici rengi, ana hafızaya kaydet
                ref.read(quizStateProvider.notifier).setBaseColor(tempColor);
                // 2. Adım 3'e git
                ref.read(_quizStepProvider.notifier).state = 3;
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: const Text('Bu Rengi Kullan ve Devam Et'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                // 1. Ana hafızadaki temel rengi temizle (atla)
                ref.read(quizStateProvider.notifier).clearBaseColor();
                // 2. Adım 3'e git
                ref.read(_quizStepProvider.notifier).state = 3;
              },
              child: const Text('Renk Seçmeden Devam Et (Rastgele Öner)'),
            ),
          ],
        ),
      ),
    );
  }

  // YENİ SIRALAMA: Soru 3 (Duygu/Mod) - (Sonuçlara yönlendirir)
  Widget _buildStep3(BuildContext context, WidgetRef ref) {
    return Center(
      key: const ValueKey('Step3_Mood'), // 'Key' adını değiştirdik
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Nasıl bir his vermeli?', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: (1 / 1.2), 
              children: [
                // Artık 'onTap'ler sonuçlara yönlendiriyor
                QuizOptionCard(title: 'Sakin & Huzurlu', icon: Icons.self_improvement, onTap: () { ref.read(quizStateProvider.notifier).setMood('Sakin'); _navigateToResults(context, ref); }),
                QuizOptionCard(title: 'Enerjik & Canlı', icon: Icons.flash_on, onTap: () { ref.read(quizStateProvider.notifier).setMood('Enerjik'); _navigateToResults(context, ref); }),
                QuizOptionCard(title: 'Profesyonel & Güvenilir', icon: Icons.work, onTap: () { ref.read(quizStateProvider.notifier).setMood('Profesyonel'); _navigateToResults(context, ref); }),
                QuizOptionCard(title: 'Gizemli & Merak Uyandırıcı', icon: Icons.visibility_off, onTap: () { ref.read(quizStateProvider.notifier).setMood('Gizemli'); _navigateToResults(context, ref); }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Sonuçlara Yönlendirme Fonksiyonu (Değişiklik yok)
  void _navigateToResults(BuildContext context, WidgetRef ref) async {
    final bool? analysisDone = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => const QuizLoadingScreen(),
      ),
    );

    if (analysisDone == true && context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const QuizResultsScreen(),
        ),
      );
    }
  }
}