import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_buttom_nav_bar.dart';

const String description =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
const String project1 = "assets/img/project1.png";
const String project2 = "assets/img/project2.png";
const String project3 = "assets/img/project3.png";
const String project4 = "assets/img/project4.png";

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Projects', showBack: true),
      body: MainContent(),
      // bottomNavigationBar: CustomBottomNavBar(
      //   currentIndex: _currentIndex,
      //   onTap: _changeTab,
      // ),
    );
  }
}

class MainContent extends StatelessWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            _card(1, 'HealthCare ', description, 'CodeIgniter4', project1),
            _card(2, 'Sneakers Dominator ', description, 'Bootstrap', project3),
            _card(3, 'Artho ', description, 'Figma', project4),
            _card(
              4,
              'Animalia ',
              description,
              'HTML, CSS, JavaScript',
              project2,
            ),
          ],
        ),
      ),
    );
  }
}

Card _card(
  int index,
  String title,
  String subtitle,
  String stack,
  String image,
) {
  return Card(
    child: Column(
      children: [
        Image.asset(
          image,
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        ListTile(
          // tileColor: Colors.black12,
          leading: CircleAvatar(
            radius: 16,
            backgroundColor: Color(0xFF7B5FFF),
            child: Text(
              index.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(subtitle),
              SizedBox(height: 8),
              Text('Stack: $stack'),
            ],
          ),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
          // trailing: Row(
          //   children: [
          //     Text('View Project'),
          //     Icon(Icons.arrow_forward_ios, size: 16)
          //   ],
          // ),
        ),
      ],
    ),
  );
}
