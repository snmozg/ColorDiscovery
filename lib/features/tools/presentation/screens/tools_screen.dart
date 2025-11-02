// lib/features/tools/presentation/screens/tools_screen.dart
import 'package:color_discovery/features/tools/presentation/screens/image_picker_screen.dart';
import 'package:flutter/material.dart';

// 'Keşfet' ekranındaki kartın tasarımını burada YENİDEN KULLANACAĞIZ!
import 'package:color_discovery/features/discover_quiz/presentation/widgets/quiz_option_card.dart';
import 'package:color_discovery/features/tools/presentation/screens/harmony_builder_screen.dart';


class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Araçlar',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView( // GridView yerine ListView kullanacağız
          children: [
            // 1. Görüntüden Palet Aracı
            // (Daha önce yaptığımız 'QuizOptionCard' widget'ını zekice yeniden kullanıyoruz)
            QuizOptionCard(
              title: 'Görüntüden Palet Oluştur',
              icon: Icons.image_search, // İkonu değiştirdik
              onTap: () {
                // Görev 10.1'de oluşturduğumuz ekrana git
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ImagePickerScreen(),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 16), // Kartlar arasına boşluk

            // 2. Renk Teorisi Aracı (İleride Yapılacak)
            QuizOptionCard(
              title: 'Renk Teorisi Yardımcısı',
              icon: Icons.contrast, // İkonu değiştirdik
              onTap: () {
               Navigator.of(context).push(
            MaterialPageRoute(
             builder: (context) => const HarmonyBuilderScreen(),
             ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}