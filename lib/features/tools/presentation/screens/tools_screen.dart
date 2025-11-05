// lib/features/tools/presentation/screens/tools_screen.dart
import 'package:color_discovery/features/tools/presentation/screens/image_picker_screen.dart';
import 'package:flutter/material.dart';
import 'package:color_discovery/features/discover_quiz/presentation/widgets/quiz_option_card.dart';
import 'package:color_discovery/features/tools/presentation/screens/harmony_builder_screen.dart';

import 'package:color_discovery/core/routes/fade_page_route.dart'; // Artık bu dosya var!

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Araçlar', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView( 
          children: [
            QuizOptionCard(
              title: 'Görüntüden Palet Oluştur',
              icon: Icons.image_search,
              onTap: () {
                Navigator.of(context).push(
                  FadePageRoute( // Yumuşak geçiş
                    child: const ImagePickerScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16), 
            QuizOptionCard(
              title: 'Renk Teorisi Yardımcısı',
              icon: Icons.contrast,
              onTap: () {
                Navigator.of(context).push(
                  FadePageRoute( // Yumuşak geçiş
                    child: const HarmonyBuilderScreen(),
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