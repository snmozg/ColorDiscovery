// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:color_discovery/presentation/screens/main_navigation_screen.dart';

// Veritabanı Modelimiz
import 'package:color_discovery/data/models/palette_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Hive (Yerel Veritabanı) başlatılıyor
  await Hive.initFlutter();

  // Hive'a "çevirmenimizi" (Adapter) tanıtıyoruz
  // BU SATIR HATA VERİYORSA, "sihirli komut" (build_runner)
  // adımını (bir önceki adımdaki) tekrar çalıştırman gerekir.
  Hive.registerAdapter(PaletteModelAdapter());

  // Paletleri saklayacağımız "kutuyu" (database'i) açıyoruz
  await Hive.openBox<PaletteModel>('palettes');

  // Uygulamayı Riverpod Scope ile çalıştır
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
      
      // Temaları yeni, temiz fonksiyondan al
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: ThemeMode.system, 

      home: const MainNavigationScreen(), 
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    // 1. Temel Material 3 temasını oluştur
    final baseTheme = ThemeData(
      brightness: brightness,
      useMaterial3: true,
      
      // YENİ TEMA RENGİ: Mor yerine nötr bir Mavi
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue, // Ana marka rengimiz
        brightness: brightness,
      ),
    );

    // 2. Yazı tiplerini bu temele uygula
    final textTheme = GoogleFonts.poppinsTextTheme(baseTheme.textTheme);

    // 3. Temayı bizim özel stillerimizle zenginleştir
    return baseTheme.copyWith(
      textTheme: textTheme, // Google Fonts'u uygula
      
      // YENİ: Açık/Koyu temalar için profesyonel arka plan renkleri
      scaffoldBackgroundColor: brightness == Brightness.dark 
          ? const Color(0xFF1C1C1E) // Koyu Tema: Füme
          : const Color(0xFFF7F7F7), // Açık Tema: Hafif Gri

      // YENİ: Kartların görünümünü iyileştir
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        // Koyu temada kartlar arka plandan çok az daha açık olmalı
        color: brightness == Brightness.dark
            ? const Color(0xFF2C2C2E) 
            : baseTheme.colorScheme.surfaceContainerHigh,
      ),

      // YENİ: AppBar (Üst bar) temasını arka plana uydur
      appBarTheme: AppBarTheme(
        elevation: 0,
        // AppBar'ı tamamen transparan yap, arka plan rengini göstersin
        backgroundColor: Colors.transparent, 
        foregroundColor: baseTheme.colorScheme.onSurface, // Yazı rengi
      ),

      // YENİ: NavigationBar (Alt bar) temasını profesyonelleştir
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        // Koyu temada alt bar, kartlarla aynı renk
        backgroundColor: brightness == Brightness.dark
            ? const Color(0xFF2C2C2E)
            : baseTheme.colorScheme.surfaceContainerHigh,
        // Seçili ikonun arka plan rengi
        indicatorColor: baseTheme.colorScheme.primary.withOpacity(0.1),
        // Seçili ikonun rengi
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return textTheme.labelSmall?.copyWith(
              color: baseTheme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            );
          }
          // Seçili olmayan ikonun rengi
          return textTheme.labelSmall?.copyWith(
            color: baseTheme.colorScheme.onSurface.withOpacity(0.6),
          );
        }),
        iconTheme: MaterialStateProperty.resolveWith((states) {
           if (states.contains(MaterialState.selected)) {
             return IconThemeData(color: baseTheme.colorScheme.primary);
           }
           // Seçili olmayan ikonun rengi
           return IconThemeData(color: baseTheme.colorScheme.onSurface.withOpacity(0.6));
        }),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: baseTheme.colorScheme.primary,
          foregroundColor: baseTheme.colorScheme.onPrimary,
        ),
      ),
    ); 
  }
}