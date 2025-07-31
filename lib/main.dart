import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      // themeMode: ThemeMode.dark,
      home: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Header Section
                buildHeader(),
                const SizedBox(height: 30),

                // Profile Section
                buildProfile(),
                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 30),

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
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black12,
      title: Text(
        'Portfolio Kunto',
        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF7B5FFF)),
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
      const SizedBox(height: 30),
      const Divider(),
      const SizedBox(height: 30),

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
