// lib/features/discover_quiz/presentation/screens/quiz_mood_screen.dart
import 'package:color_discovery/domain/providers/quiz_providers.dart';
import 'package:color_discovery/features/discover_quiz/presentation/widgets/quiz_option_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizMoodScreen extends ConsumerWidget {
  const QuizMoodScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Palet Oluştur'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Nasıl bir his vermeli?',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    
                    // HATA DÜZELTMESİ: Kartlara daha fazla dikey alan ver
                    childAspectRatio: (1 / 1.2),
                    
                    children: [
                      QuizOptionCard(
                        title: 'Sakin & Huzurlu',
                        icon: Icons.self_improvement,
                        onTap: () {
                          ref
                              .read(quizStateProvider.notifier)
                              .setMood('Sakin');
                          
                          print('Seçimler: ${ref.read(quizStateProvider).projectType} & ${ref.read(quizStateProvider).mood}');
                          // TODO: Adım 6 (Sonuç Ekranı)
                        },
                      ),
                      QuizOptionCard(
                        title: 'Enerjik & Canlı',
                        icon: Icons.flash_on,
                        onTap: () {
                          ref
                              .read(quizStateProvider.notifier)
                              .setMood('Enerjik');
                           print('Seçimler: ${ref.read(quizStateProvider).projectType} & ${ref.read(quizStateProvider).mood}');
                        },
                      ),
                      QuizOptionCard(
                        title: 'Profesyonel & Güvenilir',
                        icon: Icons.work,
                        onTap: () {
                           ref
                              .read(quizStateProvider.notifier)
                              .setMood('Profesyonel');
                           print('Seçimler: ${ref.read(quizStateProvider).projectType} & ${ref.read(quizStateProvider).mood}');
                        },
                      ),
                      QuizOptionCard(
                        title: 'Gizemli & Merak Uyandırıcı',
                        icon: Icons.visibility_off,
                        onTap: () {
                           ref
                              .read(quizStateProvider.notifier)
                              .setMood('Gizemli');
                           print('Seçimler: ${ref.read(quizStateProvider).projectType} & ${ref.read(quizStateProvider).mood}');
                        },
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