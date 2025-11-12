// lib/domain/providers/quiz_providers.dart
import 'package:color_discovery/data/models/quiz_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 'setTone' FONKSİYONU OLMAYAN TEMİZ HAL
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

  // 'setTone' buradan kaldırıldı.

  void reset() {
    state = QuizState();
  }
}

final quizStateProvider =
    StateNotifierProvider<QuizStateNotifier, QuizState>((ref) {
  return QuizStateNotifier();
});