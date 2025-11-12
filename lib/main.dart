// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:color_discovery/presentation/screens/main_navigation_screen.dart';
import 'package:color_discovery/data/models/palette_model.dart';

// --- YENİ: Modern Renk Paletimiz ---
const Color modernNavy = Color(0xFF0D253F); // Ana Lacivert (Primary)
const Color modernLightGray = Color(0xFFF7F7F7); // Açık Mod Arka Plan
const Color modernDarkGray = Color(0xFF1A1A1A);  // Koyu Mod Arka Plan
const Color modernDarkSurface = Color(0xFF2C2C2E); // Koyu Mod Kart Rengi
// --- BİTTİ ---

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  Hive.registerAdapter(PaletteModelAdapter());
  await Hive.openBox<PaletteModel>('palettes');

  runApp(
    const ProviderScope(
      child: ColorDiscoveryApp(),
    ),
  );
}

class ColorDiscoveryApp extends StatelessWidget {
  const ColorDiscoveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color Discovery',
      debugShowCheckedModeBanner: false, 
      
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: ThemeMode.system, 

      home: const MainNavigationScreen(), 
    );
  }

  // --- GÜNCELLENDİ: Tüm _buildTheme fonksiyonu ---
  ThemeData _buildTheme(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;

    // 1. Temel Material 3 temasını oluştur
    final baseTheme = ThemeData(
      brightness: brightness,
      useMaterial3: true,
      
      // YENİ TEMA RENGİ: Modern Lacivert
      colorScheme: ColorScheme.fromSeed(
        seedColor: modernNavy,
        brightness: brightness,
      ),
    );

    // 2. Yazı tiplerini bu temele uygula
    final textTheme = GoogleFonts.poppinsTextTheme(baseTheme.textTheme);

    // 3. Temayı bizim özel stillerimizle zenginleştir
    return baseTheme.copyWith(
      textTheme: textTheme, // Google Fonts'u uygula
      
      // YENİ: Açık/Koyu temalar için profesyonel arka plan renkleri
      scaffoldBackgroundColor: isDark ? modernDarkGray : modernLightGray,

      // YENİ: Kartların görünümünü iyileştir
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        // Koyu temada kartlar arka plandan çok az daha açık olmalı
        color: isDark ? modernDarkSurface : Colors.white,
      ),

      // YENİ: AppBar (Üst bar) temasını arka plana uydur
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent, 
        foregroundColor: baseTheme.colorScheme.onSurface,
      ),
      
      // YENİ: Standart buton temasını ayarla
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: baseTheme.colorScheme.primary, // modernNavy
          foregroundColor: baseTheme.colorScheme.onPrimary, // beyaz
        ),
      ),
    ); 
  }
  // --- GÜNCELLEME BİTTİ ---
}