import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio_app/providers/portfolio_provider.dart';
import 'package:my_portfolio_app/providers/profile_provider.dart';
import 'package:my_portfolio_app/routes.dart';
import 'package:provider/provider.dart';
import 'screens/portfolio_screen.dart';
import 'screens/profile_screen.dart';
import 'widgets/custom_buttom_nav_bar.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => PortfolioProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Portfolio',
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        // colorScheme: ColorScheme.fromSeed(
        //   seedColor: Colors.indigo,
        // ),
        // primarySwatch: Colors.indigo,
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme().apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      themeMode: ThemeMode.dark,
      home: MainScreen(),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  void _changeTab(int index) {
    setState(() => _currentIndex = index);
  }

  List<Widget> get _screens => [ProfileScreen(), PortfolioScreen()];

  // final List<String> _titles = ['Profile', 'Projects'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _changeTab,
      ),
    );
  }
}
