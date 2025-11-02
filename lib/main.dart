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
    final baseTheme = ThemeData(
      brightness: brightness,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: brightness,
      ),
    );

    final textTheme = GoogleFonts.poppinsTextTheme(baseTheme.textTheme);

    return baseTheme.copyWith(
      textTheme: textTheme,
      
      scaffoldBackgroundColor: baseTheme.colorScheme.surface,
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: baseTheme.colorScheme.surfaceContainerHigh,
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