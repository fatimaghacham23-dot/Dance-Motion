import 'package:dance_motion/screens/account_screen.dart';
import 'package:dance_motion/screens/home_screen.dart';
import 'package:dance_motion/screens/wishlist_screen.dart';
import 'package:dance_motion/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appState = AppState();
  await appState.loadPreferences();
  runApp(DanceMotionApp(appState: appState));
}

class DanceMotionApp extends StatelessWidget {
  final AppState appState;

  const DanceMotionApp({super.key, required this.appState});

  ThemeData get _lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.light),
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF6F4FF),
        cardTheme: const CardTheme(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
          elevation: 2,
        ),
      );

  ThemeData get _darkTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF110E1B),
        cardTheme: const CardTheme(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
          elevation: 1,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: appState,
      child: Consumer<AppState>(
        builder: (context, state, _) {
          return MaterialApp(
            title: 'Dance Motion',
            theme: _lightTheme,
            darkTheme: _darkTheme,
            themeMode: state.themeMode,
            debugShowCheckedModeBanner: false,
            home: const MainScaffold(),
          );
        },
      ),
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  static const _navigationItems = [
    _NavigationTab(icon: Icons.home, label: 'Home'),
    _NavigationTab(icon: Icons.favorite, label: 'Wishlist'),
    _NavigationTab(icon: Icons.person, label: 'Account'),
  ];

  final _pages = const [
    HomeScreen(),
    WishlistScreen(),
    AccountScreen(),
  ];

  void _onItemTapped(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _navigationItems.map((tab) {
            final index = _navigationItems.indexOf(tab);
            final isSelected = index == _currentIndex;
            final bgColor = isSelected ? colorScheme.primary : colorScheme.onBackground.withOpacity(0.1);
            final iconColor = isSelected ? Colors.white : colorScheme.onSurface.withOpacity(0.7);
            return GestureDetector(
              onTap: () => _onItemTapped(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: bgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(tab.icon, color: iconColor, size: 24),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tab.label,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.7),
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
}

class _NavigationTab {
  final IconData icon;
  final String label;

  const _NavigationTab({required this.icon, required this.label});
}
