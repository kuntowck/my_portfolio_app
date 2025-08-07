import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/portfolio_screen.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/custom_buttom_nav_bar.dart';

void main() {
  runApp(const MyApp());
}

const String name = "Kunto Wicaksono";
const String profession = "Software Engineer";
const String profileImage = "assets/img/profile.jpg";

const String email = "kunto@solecode.id";
const String phone = "+62 812-3456-7890";
const String address = "Jakarta, Indonesia";

const String pageTitle = "About Me";
const String bio =
    'Halo! You can call me Kunto. I am a passionate software engineer with experience '
    'building mobile and web apps. I love clean code, coffee, and football.';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Portfolio',
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.indigo,
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme().apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      themeMode: ThemeMode.dark,
      home: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen> {
 int _currentIndex = 0;

  void _changeTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Portfolio Kunto'),
      body: MainContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PortfolioScreen()),
          );
        },
        child: Icon(Icons.work),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavBar(currentIndex: _currentIndex, onTap: _changeTab,),
    );
  }
}

class MainContent extends StatelessWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header Section
              buildHeader(),
              const SizedBox(height: 20),

              // Profile Section
              buildProfile(),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),

              // Contact Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildContact(Icons.email, email),
                  buildContact(Icons.phone, phone),
                  buildContact(Icons.location_on, address),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildHeader() {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        pageTitle,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      buttonEdit(),
    ],
  );
}

Widget buildProfile() {
  return Column(
    children: [
      // Image
      ClipOval(
        child: Image.asset(
          profileImage,
          width: 200,
          height: 200,
          fit: BoxFit.cover,
        ),
      ),
      const SizedBox(height: 20),
      const Divider(),
      const SizedBox(height: 20),

      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name, Profession, and Bio
          Text(
            name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(profession),
          SizedBox(height: 8),
          Text(bio),
        ],
      ),
    ],
  );
}

Widget buildContact(icon, text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      children: [
        Icon(icon, size: 20, color: Color(0xFF7B5FFF)),
        const SizedBox(width: 8),
        Text(text),
      ],
    ),
  );
}

Widget buttonEdit() {
  return IconButton(
    icon: Icon(Icons.edit, color: Colors.indigo),
    onPressed: () {}, // Tidak ada fungsi
    tooltip: 'Edit',
  );
}
