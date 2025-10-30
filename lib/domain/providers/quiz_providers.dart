// lib/domain/providers/quiz_providers.dart
import 'package:color_discovery/data/models/quiz_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Bu Notifier, QuizState'i (hafızayı) yönetir
class QuizStateNotifier extends StateNotifier<QuizState> {
  QuizStateNotifier() : super(QuizState()); // Boş bir hafıza ile başla

  // Soru 1'in cevabını hafızaya yaz
  void setProjectType(String projectType) {
    state = state.copyWith(projectType: projectType);
  }

  // Soru 2'nin cevabını hafızaya yaz
  void setMood(String mood) {
    state = state.copyWith(mood: mood);
  }

  // Test bittiğinde hafızayı temizle
  void reset() {
    state = QuizState();
  }
}

// Bu provider'ı UI'da çağırarak hafızaya ulaşıp, onu güncelleyeceğiz
final quizStateProvider =
    StateNotifierProvider<QuizStateNotifier, QuizState>((ref) {
  return QuizStateNotifier();
});