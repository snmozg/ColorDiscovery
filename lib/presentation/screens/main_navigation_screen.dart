import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/collections/presentation/screens/collections_screen.dart';
import '../../../features/tools/presentation/screens/tools_screen.dart';
import 'discover_screen.dart';

// Hangi sekmenin seçili olduğunu takip eden bir anahtar
final mainNavigationProvider = StateProvider<int>((ref) => 0);

class MainNavigationScreen extends ConsumerWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Anahtarı (provider'ı) dinle
    final selectedIndex = ref.watch(mainNavigationProvider);

    // Hangi ekrana gideceğimizi belirleyen liste
    const List<Widget> screens = [
      DiscoverScreen(),    // 0. ekran
      ToolsScreen(),       // 1. ekran
      CollectionsScreen(), // 2. ekran
    ];

    return Scaffold(
      // Seçili olan ekranı göster
      body: screens[selectedIndex],

      // Alttaki 3'lü buton (NavigationBar)
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          // Bir butona tıklarsan, anahtarı güncelle
          ref.read(mainNavigationProvider.notifier).state = index;
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore),
            label: 'Keşfet',
          ),
          NavigationDestination(
            icon: Icon(Icons.image),
            label: 'Araçlar',
          ),
          NavigationDestination(
            icon: Icon(Icons.palette),
            label: 'Koleksiyon',
          ),
        ],
      ),
    );
  }
}