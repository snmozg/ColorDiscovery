// lib/features/tools/presentation/screens/image_picker_screen.dart

// TÜM IMPORT'LAR 'package:' (İKİ NOKTA) İLE BAŞLAMALI
import 'dart:io'; 
import 'package:flutter/material.dart'; // package:flutter (doğru)
import 'package:image_picker/image_picker.dart'; // package:image_picker (doğru)
import 'package:palette_generator/palette_generator.dart'; // package:palette_generator (doğru)

// Diğer doğru 'import'lar
import 'package:color_discovery/features/discover_quiz/presentation/widgets/quiz_option_card.dart';
import 'package:color_discovery/features/discover_quiz/presentation/widgets/palette_preview_card.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:color_discovery/data/models/palette_model.dart';


class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  File? _imageFile;
  List<Color> _paletteColors = [];
  bool _isLoading = false;

  Future<void> _pickAndAnalyzeImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    setState(() {
      _imageFile = File(pickedFile.path);
      _paletteColors = [];
      _isLoading = true;
    });

    final PaletteGenerator generator =
        await PaletteGenerator.fromImageProvider(
      FileImage(_imageFile!),
      maximumColorCount: 5,
    );

    setState(() {
      _paletteColors = generator.colors.toList();
      _isLoading = false;
    });
  }

  Future<void> _showSaveDialog() async {
    final nameController = TextEditingController(text: "Görüntüden Palet");
    
    if (!mounted) return; 

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Paleti Kaydet'),
          content: TextField(
            controller: nameController,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Palet Adı',
            ),
          ),
          actions: [
            TextButton(
              child: const Text('İptal'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            ElevatedButton(
              child: const Text('Kaydet'),
              onPressed: () {
                final String paletteName = nameController.text.trim();
                if (paletteName.isNotEmpty) {
                  _savePaletteToHive(paletteName);
                  Navigator.of(dialogContext).pop(); 
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _savePaletteToHive(String paletteName) {
    final newPalette = PaletteModel(
      name: paletteName,
      colors: _paletteColors.map((color) => color.value).toList(),
    );

    final box = Hive.box<PaletteModel>('palettes');
    box.add(newPalette);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"$paletteName" koleksiyona kaydedildi!'),
          backgroundColor: Colors.green[700],
        ),
      );
      Navigator.of(context).pop();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Görüntüden Palet Oluştur'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_imageFile == null)
                  QuizOptionCard(
                    title: 'Galeriden Görüntü Seç',
                    icon: Icons.photo_library,
                    onTap: _pickAndAnalyzeImage,
                  )
                else
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _imageFile!,
                      fit: BoxFit.cover,
                      height: 300,
                    ),
                  ),

                const SizedBox(height: 24),

                if (_isLoading)
                  const CircularProgressIndicator()
                else if (_paletteColors.isNotEmpty)
                  Column(
                    children: [
                      Text(
                        'Çıkarılan Baskın Renkler:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      PalettePreviewCard(
                        name: "Analiz Sonucu",
                        colors: _paletteColors,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _showSaveDialog,
                        icon: const Icon(Icons.save_alt),
                        label: const Text('Koleksiyona Kaydet'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}