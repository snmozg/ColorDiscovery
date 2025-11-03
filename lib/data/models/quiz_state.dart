// lib/data/models/quiz_state.dart
import 'package:flutter/material.dart'; // HATA DÜZELTİLDİ (package:flutter)

class QuizState {
  final String? projectType; // Soru 1: Mobil, Web etc.
  final String? mood;        // Soru 2: Sakin, Enerjik etc.
  final Color? baseColor;     // Soru 3: Opsiyonel temel renk

  QuizState({
    this.projectType,
    this.mood,
    this.baseColor,
  });

  // Seçimleri güncellerken yeni bir obje oluşturmak için
  QuizState copyWith({
    String? projectType,
    String? mood,
    Color? baseColor,
    bool clearBaseColor = false, // Rengi 'null' olarak ayarlamak için
  }) {
    return QuizState(
      projectType: projectType ?? this.projectType,
      mood: mood ?? this.mood,
      baseColor: clearBaseColor ? null : baseColor ?? this.baseColor,
    );
  }
}