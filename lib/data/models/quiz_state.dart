// lib/data/models/quiz_state.dart
import 'package:flutter/material.dart';

class QuizState {
  final String? projectType; // Soru 1
  final Color? baseColor;     // Soru 2
  final String? mood;        // Soru 3
  final String? tone;        // Soru 4

  QuizState({
    this.projectType,
    this.baseColor,
    this.mood,
    this.tone,
  });

  QuizState copyWith({
    String? projectType,
    Color? baseColor,
    String? mood,
    String? tone,
    bool clearBaseColor = false,
  }) {
    return QuizState(
      projectType: projectType ?? this.projectType,
      baseColor: clearBaseColor ? null : baseColor ?? this.baseColor,
      mood: mood ?? this.mood,
      tone: tone ?? this.tone,
    );
  }
}