// lib/data/models/palette_model.dart
import 'package:hive/hive.dart';

// Bu 'part' satırı ŞİMDİLİK HATA VERECEK. Bu normal.
// Bir sonraki görevdeki komut bu hatayı düzeltecek.
part 'palette_model.g.dart'; 

@HiveType(typeId: 0) // Hive için bu modelin kimliği (ID'si)
class PaletteModel extends HiveObject {
  
  @HiveField(0) // 0 numaralı alan
  final String name;

  @HiveField(1) // 1 numaralı alan
  // Hive, 'Color' tipini doğrudan saklayamaz.
  // Bu yüzden renkleri bir 'int' (sayı) listesi olarak saklayacağız.
  final List<int> colors;

  PaletteModel({
    required this.name,
    required this.colors,
  });
}