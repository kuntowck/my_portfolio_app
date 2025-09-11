import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio_app/providers/auth_provider.dart';
import 'package:my_portfolio_app/providers/portfolio_provider.dart';
import 'package:my_portfolio_app/providers/profile_provider.dart';
import 'package:my_portfolio_app/routes.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/portfolio_screen.dart';
import 'screens/profile_screen.dart';
import 'widgets/custom_buttom_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseOptions(
      projectId: 'flutter-app-d09a5', // Project ID
      messagingSenderId: '439569327558', //Project Number
      apiKey: 'AIzaSyBIBM-SoWXnwiKRHcRLG8gGMy1L919wqYs', //Web API Key
      appId: '1:439569327558:android:e2fdb9b5a285c45605fec7',
    ), // App ID
  );

  await Supabase.initialize(
    url: "https://uylolxiduxanmjqcmjgj.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV5bG9seGlkdXhhbm1qcWNtamdqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc1NzA0MjcsImV4cCI6MjA3MzE0NjQyN30.YH4BKLxxLi7qVcgPgsItcJ0pVfjEoHK1XNOoGXaid6c",
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => PortfolioProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
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
      // home: MainScreen(),
      initialRoute: AppRoutes.login,
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
      body: SafeArea(child: _screens[_currentIndex]),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _changeTab,
      ),
    );
  }
}
