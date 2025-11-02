// lib/features/tools/presentation/screens/harmony_builder_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart'; // Yeni paketimizi import ettik

class HarmonyBuilderScreen extends StatefulWidget {
  const HarmonyBuilderScreen({super.key});

  @override
  State<HarmonyBuilderScreen> createState() => _HarmonyBuilderScreenState();
}

class _HarmonyBuilderScreenState extends State<HarmonyBuilderScreen> {
  // Kullanıcının seçtiği ana rengi hafızada tut
  Color _currentColor = Colors.deepPurple; // Başlangıç rengi

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Renk Teorisi Yardımcısı'),
      ),
      // Kaydırma (scroll) özelliği ekle, çünkü renk seçici uzun olabilir
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. Yeni paketimizden gelen Renk Seçici Widget'ı
            ColorPicker(
              pickerColor: _currentColor,
              onColorChanged: (color) {
                // Kullanıcı yeni bir renk seçtiğinde, state'i (durumu) güncelle
                setState(() {
                  _currentColor = color;
                });
              },
              colorPickerWidth: 300.0,
              pickerAreaHeightPercent: 0.7,
              enableAlpha: false, // Opaklık (alpha) ayarını kapattık
              displayThumbColor: true,
              paletteType: PaletteType.hsv,
              pickerAreaBorderRadius: const BorderRadius.all(Radius.circular(8.0)),
            ),
            
            const SizedBox(height: 24),
            
            // 2. Seçilen rengi gösteren bir kutu
            Text(
              'Seçilen Ana Renk:',
              style: Theme.of(context).textTheme.titleMedium
            ),
            const SizedBox(height: 12),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: _currentColor,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            
            // TODO: Adım 15'te buraya hesaplanan paletler (tamamlayıcı vb.) gelecek
          ],
        ),
      ),
    );
  }
}