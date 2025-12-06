import 'package:flutter/material.dart';

import 'screens/main_screen.dart';
import 'screens/breeds_screen.dart';
import 'utils/colors.dart';

void main() {
  runApp(const CatTinderApp());
}

class CatTinderApp extends StatelessWidget {
  const CatTinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CatTinder',

      theme: ThemeData(
        fontFamily: 'SF Pro',
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.transparent,

        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.backgroundTop,
          brightness: Brightness.light,
        ),

        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white.withValues(alpha: 0.1),
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          indicatorColor: Colors.white.withValues(alpha: 0.25),

          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: Colors.white, size: 28);
            }
            return IconThemeData(color: Colors.white.withValues(alpha: 0.7));
          }),

          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            return TextStyle(
              color: Colors.white.withValues(
                alpha: states.contains(WidgetState.selected) ? 1 : 0.7,
              ),
              fontWeight: FontWeight.w600,
            );
          }),
        ),
      ),

      home: const MainTabs(),
    );
  }
}

class MainTabs extends StatefulWidget {
  const MainTabs({super.key});

  @override
  State<MainTabs> createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs> {
  int index = 0;

  final screens = [const MainScreen(), const BreedsScreen()];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,

        body: screens[index],

        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 12, right: 12),

          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: NavigationBar(
              height: 65,
              selectedIndex: index,
              elevation: 0,
              indicatorShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              destinations: const [
                NavigationDestination(icon: Icon(Icons.pets), label: 'Коты'),
                NavigationDestination(icon: Icon(Icons.list), label: 'Породы'),
              ],
              onDestinationSelected: (i) => setState(() => index = i),
            ),
          ),
        ),
      ),
    );
  }
}
