// lib/features/discover_quiz/presentation/widgets/palette_preview_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Panoya Kopyalamak için

// 1. STATENLESS -> STATEFUL WIDGET DÖNÜŞÜMÜ
class PalettePreviewCard extends StatefulWidget {
  const PalettePreviewCard({
    super.key,
    required this.colors,
    required this.name,
    this.onSavePressed, 
  });

  final List<Color> colors;
  final String name;
  final VoidCallback? onSavePressed;

  @override
  State<PalettePreviewCard> createState() => _PalettePreviewCardState();
}

class _PalettePreviewCardState extends State<PalettePreviewCard> {
  // 2. KARTIN AÇIK MI KAPALI MI OLDUĞUNU TUTAN YENİ STATE (HAFIZA)
  bool _isExpanded = false;

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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      // 'AnimatedCrossFade' -> İçeriğin yumuşakça değişmesini sağlar
      child: AnimatedCrossFade(
        duration: const Duration(milliseconds: 300), // Animasyon süresi
        // 3. KAPALI HAL (Sadece kartı göster)
        firstChild: _buildCollapsedCard(context),
        // 4. AÇIK HAL (Kartı + HEX kodlarını göster)
        secondChild: _buildExpandedCard(context),
        // 5. Hangi hali göstereceğimizi seç
        crossFadeState: _isExpanded 
            ? CrossFadeState.showSecond 
            : CrossFadeState.showFirst,
      ),
    );
  }

  // --- KARTIN KAPALI HALİ (Eski kodumuz) ---
  Widget _buildCollapsedCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.name, // 'widget.name' olarak değişti
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              // YENİ KOPYALA BUTONU (Açma/Kapama)
              IconButton(
                icon: const Icon(Icons.copy_outlined),
                tooltip: 'Renk kodlarını göster/kopyala',
                onPressed: () {
                  setState(() {
                    _isExpanded = true; // Kartı AÇ
                  });
                },
              ),
              if (widget.onSavePressed != null) // 'widget.onSavePressed' olarak değişti
                IconButton(
                  icon: const Icon(Icons.save_alt_outlined),
                  tooltip: 'Koleksiyona Kaydet',
                  onPressed: widget.onSavePressed,
                  color: Theme.of(context).colorScheme.primary,
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Renk blokları (Artık tıklanabilir değil)
          SizedBox(
            height: 80, 
            child: Row(
              children: widget.colors.map((color) { // 'widget.colors' olarak değişti
                return Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: widget.colors.first == color
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            )
                          : widget.colors.last == color
                              ? const BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                )
                              : null,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // --- YENİ: KARTIN AÇIK HALİ (HEX Kodlarıyla birlikte) ---
  Widget _buildExpandedCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              // YENİ KAPAT BUTONU
              IconButton(
                icon: const Icon(Icons.close),
                tooltip: 'Gizle',
                onPressed: () {
                  setState(() {
                    _isExpanded = false; // Kartı KAPAT
                  });
                },
              ),
              if (widget.onSavePressed != null)
                IconButton(
                  icon: const Icon(Icons.save_alt_outlined),
                  tooltip: 'Koleksiyona Kaydet',
                  onPressed: widget.onSavePressed,
                  color: Theme.of(context).colorScheme.primary,
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Renk blokları (Tıklanmaz)
          SizedBox(
            height: 80, 
            child: Row(
              children: widget.colors.map((color) {
                return Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: widget.colors.first == color
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            )
                          : widget.colors.last == color
                              ? const BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                )
                              : null,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          
          // YENİ EKLENEN BÖLÜM: HEX KOD LİSTESİ
          const Divider(height: 24),
          Text(
            'Renk Kodları (HEX):',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Column(
            children: widget.colors.map((color) {
              final String hexCode = _colorToHex(color);
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(width: 12, height: 12, color: color, margin: const EdgeInsets.only(right: 8)),
                      Text(hexCode, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy_all_outlined, size: 20),
                    tooltip: '$hexCode Kopyala',
                    onPressed: () {
                      _copyToClipboard(context, hexCode);
                    },
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}