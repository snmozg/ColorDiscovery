// lib/domain/providers/quiz_providers.dart
import 'package:color_discovery/data/models/quiz_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizStateNotifier extends StateNotifier<QuizState> {
  QuizStateNotifier() : super(QuizState());

  void setProjectType(String projectType) {
    state = state.copyWith(projectType: projectType);
  }

  void setBaseColor(Color color) {
    state = state.copyWith(baseColor: color);
  }

  void clearBaseColor() {
    state = state.copyWith(clearBaseColor: true);
  }
  
  void setMood(String mood) {
    state = state.copyWith(mood: mood);
  }

  // YENİ FONKSİYON: Tonu (Açık/Koyu) hafızaya yaz
  void setTone(String tone) {
    state = state.copyWith(tone: tone); // 'tone' artık 'quiz_state.dart'ta tanımlı
  }

  // Test bittiğinde hafızayı temizle
  void reset() {
    state = QuizState();
  }
}

// Provider (Değişiklik yok)
final quizStateProvider =
    StateNotifierProvider<QuizStateNotifier, QuizState>((ref) {
  return QuizStateNotifier();
});