// lib/data/models/quiz_state.dart
import 'package:flutter/material.dart';

// SADECE 3 SORULUK (Tone OLMAYAN) TEMİZ HAL
class QuizState {
  final String? projectType; // Soru 1
  final Color? baseColor;     // Soru 2
  final String? mood;        // Soru 3

  QuizState({
    this.projectType,
    this.baseColor,
    this.mood,
  });

  QuizState copyWith({
    String? projectType,
    Color? baseColor,
    String? mood,
    bool clearBaseColor = false,
  }) {
    return QuizState(
      projectType: projectType ?? this.projectType,
      baseColor: clearBaseColor ? null : baseColor ?? this.baseColor,
      mood: mood ?? this.mood,
    );
  }
}