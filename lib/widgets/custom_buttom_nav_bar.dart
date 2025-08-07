import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.deepPurple.shade100,
      backgroundColor: Color(0xFF7B5FFF),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
  BottomNavigationBarItem(icon: Icon(Icons.contact_mail), label: 'Contact'),
      ],
    );
  }
}
