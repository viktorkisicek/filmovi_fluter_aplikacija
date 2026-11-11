import 'package:flutter/material.dart';
import 'gallery_screen.dart';
import 'list_screen.dart';
import 'table_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  static const _screens = <Widget>[
    ListScreen(),
    TableScreen(),
    GalleryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() {
          _index = index;
        }),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: 'Popis'),
          NavigationDestination(
            icon: Icon(Icons.table_chart),
            label: 'Tablica',
          ),
          NavigationDestination(
            icon: Icon(Icons.photo_library),
            label: 'Galerija',
          ),
        ],
      ),
    );
  }
}
