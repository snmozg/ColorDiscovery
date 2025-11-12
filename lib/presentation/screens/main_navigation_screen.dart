// lib/presentation/screens/main_navigation_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/collections/presentation/screens/collections_screen.dart';
import '../../../features/tools/presentation/screens/tools_screen.dart';
import 'discover_screen.dart';

// Hangi sekmenin seçili olduğunu takip eden provider (Değişiklik yok)
final mainNavigationProvider = StateProvider<int>((ref) => 0);

class MainNavigationScreen extends ConsumerWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(mainNavigationProvider);

    const List<Widget> screens = [
      DiscoveryScreen(),
      ToolsScreen(),
      CollectionsScreen(),
    ];

    return Scaffold(
      body: screens[selectedIndex],

      // --- DEĞİŞİKLİK BURADA ---
      // Eski 'NavigationBar' widget'ı yerine kendi özel widget'ımızı koyduk
      bottomNavigationBar: const CustomBottomNavBar(),
      // --- DEĞİŞİKLİK BİTTİ ---
    );
  }
}

// --- YENİ WIDGET: Özel Navigasyon Barının Çerçevesi ---
class CustomBottomNavBar extends ConsumerWidget {
  const CustomBottomNavBar({super.key});

  // Navigasyon hedeflerimizi tanımlayalım
  static final List<Map<String, dynamic>> _destinations = [
    {'icon': Icons.explore_outlined, 'label': 'Keşfet', 'selectedIcon': Icons.explore},
    {'icon': Icons.image_outlined, 'label': 'Araçlar', 'selectedIcon': Icons.image},
    {'icon': Icons.palette_outlined, 'label': 'Koleksiyon', 'selectedIcon': Icons.palette},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(mainNavigationProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      // Arka plan rengini temadaki kart renginden al
      // (Açık temada beyaz, Koyu temada modernDarkSurface)
      color: theme.cardColor,
      child: SafeArea(
        bottom: true,
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_destinations.length, (index) {
            final item = _destinations[index];
            final bool isSelected = (selectedIndex == index);

            return _CustomNavItem(
              icon: isSelected ? item['selectedIcon'] : item['icon'],
              label: item['label'],
              isSelected: isSelected,
              onTap: () {
                ref.read(mainNavigationProvider.notifier).state = index;
              },
            );
          }),
        ),
      ),
    );
  }
}

// --- YENİ WIDGET: Her bir özel navigasyon butonu ---
class _CustomNavItem extends StatelessWidget {
  const _CustomNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Aktif Renk (Modern Lacivert)
    final Color activeColor = theme.colorScheme.primary; 
    
    // Pasif Renk (Modern Gri)
    final Color inactiveColor = theme.colorScheme.onSurface.withOpacity(0.6);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        // Tıklama efektini daire şeklinde yap
        borderRadius: BorderRadius.circular(100),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? activeColor : inactiveColor,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isSelected ? activeColor : inactiveColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}