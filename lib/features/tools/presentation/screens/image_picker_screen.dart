// lib/features/tools/presentation/screens/image_picker_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Panoya kopyalamak için
import 'package:image_picker/image_picker.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:color_discovery/data/models/palette_model.dart';
// Paylaşma fonksiyonu için
import 'package:share_plus/share_plus.dart';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  File? _imageFile;
  List<Color> _paletteColors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pickImageOnLoad();
    });
  }

  Future<void> _pickImageOnLoad() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _paletteColors = [];
    });

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      if (mounted) Navigator.of(context).pop();
      return;
    }

    setState(() {
      _imageFile = File(pickedFile.path);
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

  // --- Kopyalama ve Paylaşma için Yardımcı Metotlar ---

  // Rengi HEX koduna çevirir
  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  // Tıklandığında panoya kopyalar
  void _copyToClipboard(BuildContext context, String hexCode) {
    Clipboard.setData(ClipboardData(text: hexCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$hexCode panoya kopyalandı!'),
        backgroundColor: Colors.grey[800],
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // Paleti metin olarak paylaşır
  void _sharePalette() {
    if (_paletteColors.isEmpty) return;
    final hexCodes =
        _paletteColors.map((color) => _colorToHex(color)).join(', ');
    final String textToShare =
        "Color Discovery ile harika bir palet buldum: $hexCodes";
    Share.share(textToShare);
  }
  
  // (Kaydetme fonksiyonları _showSaveDialog ve _savePaletteToHive değişmedi)
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

  // --- GÜNCELLENDİ: Çerçeve (Border) kaldırıldı ---
  Widget _buildColorDisplay(List<Color> colors) {
    return Container(
      height: 100, // Sabit yükseklik
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        // border: Border.all(color: Theme.of(context).dividerColor), // <-- BU ÇERÇEVE KALDIRILDI
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12), // 11 -> 12 olarak güncellendi
        child: Row(
          children: colors.map((color) {
            final hexCode = _colorToHex(color);
            return Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // 1. Renk bloğu
                  Container(color: color),
                  // 2. Kopyalama ikonu (Arka plansız)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {
                        _copyToClipboard(context, hexCode);
                      },
                      child: Icon(
                        Icons.copy_outlined,
                        color: Colors.white,
                        size: 18,
                        shadows: const [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 4.0,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
  // --- GÜNCELLEME BİTTİ ---

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                if (_imageFile != null)
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
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      _buildColorDisplay(_paletteColors), // Çerçevesiz widget
                      const SizedBox(height: 32),
                      
                      // 3'lü Buton Grubu
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // 1. Tekrar Butonu
                          FilledButton(
                            child: const Icon(Icons.refresh, size: 24),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                              shape: const CircleBorder(),
                              backgroundColor: theme.colorScheme.secondaryContainer,
                              foregroundColor: theme.colorScheme.onSecondaryContainer,
                            ),
                            onPressed: _pickImageOnLoad,
                          ),
                          // 2. Kaydet Butonu
                          FilledButton(
                            child: const Icon(Icons.save_alt_outlined, size: 24),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                              shape: const CircleBorder(),
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                            ),
                            onPressed: _showSaveDialog,
                          ),
                          // 3. Paylaş Butonu
                          FilledButton(
                            child: const Icon(Icons.share, size: 24),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                              shape: const CircleBorder(),
                              backgroundColor: theme.colorScheme.secondaryContainer,
                              foregroundColor: theme.colorScheme.onSecondaryContainer,
                            ),
                            onPressed: _sharePalette,
                          ),
                        ],
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