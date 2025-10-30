// lib/features/discover_quiz/presentation/screens/quiz_start_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod eklendi
import 'package:color_discovery/domain/providers/quiz_providers.dart'; // Provider eklendi
import 'package:color_discovery/features/discover_quiz/presentation/screens/quiz_mood_screen.dart'; // 2. Soru ekranı eklendi
import 'package:color_discovery/features/discover_quiz/presentation/widgets/quiz_option_card.dart';

// StatelessWidget'ı ConsumerWidget olarak değiştir
class QuizStartScreen extends ConsumerWidget {
  const QuizStartScreen({super.key});

  // build metoduna 'WidgetRef ref' eklendi
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
                  'Ne tasarlıyorsun?',
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
                    children: [
                      QuizOptionCard(
                        title: 'Mobil Uygulama',
                        icon: Icons.phone_android,
                        // onTap'ı güncelle
                        onTap: () {
                          // 1. Hafızaya "Mobil Uygulama" yaz
                          ref
                              .read(quizStateProvider.notifier)
                              .setProjectType('Mobil Uygulama');
                          
                          // 2. İkinci soruya (Mood) git
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const QuizMoodScreen(),
                            ),
                          );
                        },
                      ),
                      QuizOptionCard(
                        title: 'Web Sitesi',
                        icon: Icons.web,
                        // onTap'ı güncelle
                        onTap: () {
                          ref
                              .read(quizStateProvider.notifier)
                              .setProjectType('Web Sitesi');
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const QuizMoodScreen(),
                            ),
                          );
                        },
                      ),
                      QuizOptionCard(
                        title: 'Logo & Marka',
                        icon: Icons.design_services,
                        // onTap'ı güncelle
                        onTap: () {
                          ref
                              .read(quizStateProvider.notifier)
                              .setProjectType('Logo & Marka');
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const QuizMoodScreen(),
                            ),
                          );
                        },
                      ),
                      QuizOptionCard(
                        title: 'Oyun Arayüzü',
                        icon: Icons.sports_esports,
                        // onTap'ı güncelle
                        onTap: () {
                          ref
                              .read(quizStateProvider.notifier)
                              .setProjectType('Oyun Arayüzü');
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const QuizMoodScreen(),
                            ),
                          );
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