// lib/features/discover_quiz/presentation/screens/quiz_start_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:color_discovery/domain/providers/quiz_providers.dart';
import 'package:color_discovery/features/discover_quiz/presentation/widgets/quiz_option_card.dart';
import 'package:color_discovery/features/discover_quiz/presentation/screens/quiz_loading_screen.dart';
import 'package:color_discovery/features/discover_quiz/presentation/screens/quiz_results_screen.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart'; 

// 3 ADIMLI ÇALIŞAN TEST EKRANI
final _quizStepProvider = StateProvider.autoDispose<int>((ref) => 1); 
final _tempColorProvider = StateProvider.autoDispose<Color>((ref) => Colors.deepPurple);

class QuizStartScreen extends ConsumerWidget {
  const QuizStartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = ref.watch(_quizStepProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Palet Asistanı'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400), 
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            // SADECE 3 ADIMLI YAPI
            child: switch (currentStep) {
              1 => _buildStep1(context, ref), // Soru 1: Proje
              2 => _buildStep2(context, ref), // Soru 2: Temel Renk
              3 => _buildStep3(context, ref), // Soru 3: Duygu
              _ => _buildStep1(context, ref),
            },
          ),
        ),
      ),
    );
  }

  // Soru 1 (Proje Tipi)
  Widget _buildStep1(BuildContext context, WidgetRef ref) {
    return Center(
      key: const ValueKey('Step1_Project'), 
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Bu paleti nerede kullanacaksın?', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: (1 / 1.2), 
              children: [
                QuizOptionCard(title: 'Dijital Arayüz (Web/Mobil)', icon: Icons.phone_android, onTap: () { ref.read(quizStateProvider.notifier).setProjectType('Dijital'); ref.read(_quizStepProvider.notifier).state = 2; }),
                QuizOptionCard(title: 'Marka & Logo Tasarımı', icon: Icons.design_services, onTap: () { ref.read(quizStateProvider.notifier).setProjectType('Marka'); ref.read(_quizStepProvider.notifier).state = 2; }),
                QuizOptionCard(title: 'Ev Dekoru & İç Mekan', icon: Icons.chair, onTap: () { ref.read(quizStateProvider.notifier).setProjectType('İç Mekan'); ref.read(_quizStepProvider.notifier).state = 2; }),
                QuizOptionCard(title: 'Sosyal Medya & Sunum', icon: Icons.slideshow, onTap: () { ref.read(quizStateProvider.notifier).setProjectType('Sunum'); ref.read(_quizStepProvider.notifier).state = 2; }),
                QuizOptionCard(title: 'İllüstrasyon & Sanat', icon: Icons.palette, onTap: () { ref.read(quizStateProvider.notifier).setProjectType('Sanat'); ref.read(_quizStepProvider.notifier).state = 2; }),
                QuizOptionCard(title: 'Sadece İlham Arıyorum', icon: Icons.lightbulb_outline, onTap: () { ref.read(quizStateProvider.notifier).setProjectType('İlham'); ref.read(_quizStepProvider.notifier).state = 2; }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Soru 2 (Temel Renk Seçimi)
  Widget _buildStep2(BuildContext context, WidgetRef ref) {
    final Color tempColor = ref.watch(_tempColorProvider);
    return Center(
      key: const ValueKey('Step2_Color'),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Belirli bir temel rengin var mı?', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ColorPicker(
              pickerColor: tempColor,
              onColorChanged: (color) { ref.read(_tempColorProvider.notifier).state = color; },
              colorPickerWidth: 300.0, pickerAreaHeightPercent: 0.7, enableAlpha: false,
              displayThumbColor: true, paletteType: PaletteType.hsv,
              pickerAreaBorderRadius: const BorderRadius.all(Radius.circular(8.0)),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ref.read(quizStateProvider.notifier).setBaseColor(tempColor);
                ref.read(_quizStepProvider.notifier).state = 3; // 3'e git
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: const Text('Bu Rengi Kullan ve Devam Et'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                ref.read(quizStateProvider.notifier).clearBaseColor();
                ref.read(_quizStepProvider.notifier).state = 3; // 3'e git
              },
              child: const Text('Renk Seçmeden Devam Et (Rastgele Öner)'),
            ),
          ],
        ),
      ),
    );
  }

  // Soru 3 (Duygu/Mod)
  Widget _buildStep3(BuildContext context, WidgetRef ref) {
    return Center(
      key: const ValueKey('Step3_Mood'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Nasıl bir his vermeli?', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: (1 / 1.2), 
              children: [
                QuizOptionCard(title: 'Sakin & Yatıştırıcı', icon: Icons.self_improvement, onTap: () { ref.read(quizStateProvider.notifier).setMood('Sakin'); _navigateToResults(context, ref); }),
                QuizOptionCard(title: 'Enerjik & Cesur', icon: Icons.flash_on, onTap: () { ref.read(quizStateProvider.notifier).setMood('Enerjik'); _navigateToResults(context, ref); }),
                QuizOptionCard(title: 'Profesyonel & Güvenilir', icon: Icons.work, onTap: () { ref.read(quizStateProvider.notifier).setMood('Profesyonel'); _navigateToResults(context, ref); }),
                QuizOptionCard(title: 'Lüks & Sofistike', icon: Icons.diamond_outlined, onTap: () { ref.read(quizStateProvider.notifier).setMood('Lüks'); _navigateToResults(context, ref); }),
                QuizOptionCard(title: 'Samimi & Eğlenceli', icon: Icons.sentiment_satisfied, onTap: () { ref.read(quizStateProvider.notifier).setMood('Eğlenceli'); _navigateToResults(context, ref); }),
                QuizOptionCard(title: 'Doğal & Organik', icon: Icons.eco, onTap: () { ref.read(quizStateProvider.notifier).setMood('Doğal'); _navigateToResults(context, ref); }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Sonuçlara Yönlendirme Fonksiyonu
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