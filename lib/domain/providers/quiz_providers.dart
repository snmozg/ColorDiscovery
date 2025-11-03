// lib/domain/providers/quiz_providers.dart
import 'package:color_discovery/data/models/quiz_state.dart'; // HATA DÜZELTİLDİ (package:color_discovery)
import 'package:flutter/material.dart'; 
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizStateNotifier extends StateNotifier<QuizState> {
  QuizStateNotifier() : super(QuizState());

  void setProjectType(String projectType) {
    state = state.copyWith(projectType: projectType);
  }

  void setMood(String mood) {
    state = state.copyWith(mood: mood);
  }

  // YENİ FONKSİYON: Temel rengi hafızaya yaz
  void setBaseColor(Color color) {
    state = state.copyWith(baseColor: color);
  }

  // YENİ FONKSİYON: Temel rengi (atla derse) hafızadan sil
  void clearBaseColor() {
    state = state.copyWith(clearBaseColor: true);
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