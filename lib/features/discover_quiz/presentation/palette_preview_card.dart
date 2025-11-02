// lib/features/discover_quiz/presentation/widgets/palette_preview_card.dart
import 'package:flutter/material.dart';

class PalettePreviewCard extends StatelessWidget {
  const PalettePreviewCard({
    super.key,
    required this.colors,
    required this.name,
  });

  final List<Color> colors;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 80, 
              child: Row(
                children: colors.map((color) {
                  return Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: colors.first == color
                            ? const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              )
                            : colors.last == color
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
      ),
    );
  }
}