// lib/data/models/quiz_state.dart

// Test boyunca kullanıcının seçimlerini tutacak model
class QuizState {
  final String? projectType; // Soru 1: Mobil, Web etc.
  final String? mood;        // Soru 2: Sakin, Enerjik etc.

  QuizState({
    this.projectType,
    this.mood,
  });

  // Seçimleri güncellerken yeni bir obje oluşturmak için
  QuizState copyWith({
    String? projectType,
    String? mood,
  }) {
    return QuizState(
      projectType: projectType ?? this.projectType,
      mood: mood ?? this.mood,
    );
  }
}