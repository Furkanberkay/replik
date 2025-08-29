import 'package:flutter/material.dart';
import 'thema/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';

void main() => runApp(const ReplikApp());

class ReplikApp extends StatefulWidget {
  const ReplikApp({super.key});
  @override
  State<ReplikApp> createState() => _ReplikAppState();
}

class _ReplikAppState extends State<ReplikApp> {
  int _index = 0;

  final _screens = const [HomeScreen(), SearchScreen()];
  final _titles = const ['Popular', 'Search'];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Replik',
      theme: buildAppTheme(),
      home: Scaffold(
        appBar: AppBar(title: Text(_titles[_index]), centerTitle: true),
        body: Container(
          decoration: const BoxDecoration(gradient: appGradient),
          child: _screens[_index],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Popular'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          ],
        ),
      ),
    );
  }
}
