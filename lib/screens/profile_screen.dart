import 'package:flutter/material.dart';
import 'package:my_portfolio_app/providers/auth_provider.dart';
import 'package:my_portfolio_app/providers/profile_provider.dart';
import 'package:my_portfolio_app/routes.dart';
import 'package:my_portfolio_app/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

// const String name = "Kunto Wicaksono";
// const String profession = "Software Engineer";
// const String bio =
//     'Halo! You can call me Kunto. I am a passionate software engineer with experience '
//     'building mobile and web apps. I love clean code, coffee, and football.';
// const String email = "kunto@solecode.id";
// const String phone = "+62 812-3456-7890";
// const String address = "Jakarta, Indonesia";

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);
    final profile = profileProvider.profile!;

    return Scaffold(
      appBar: CustomAppBar(title: 'Profile'),
      body: profileProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : profileProvider.profile == null
          ? Center(child: Text("No profile data found."))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Profile Section
                  buildProfile(context, profile),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),

                  // Contact Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildContact(Icons.email, profile.email),
                      buildContact(Icons.phone, profile.phone),
                      buildContact(Icons.location_on, profile.address),
                    ],
                  ),
                ],
              ),
            ),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              child: Text(
                'Menu',
                // style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: Text('Contact'),
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.contact);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Settings'),
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.setting);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                ),
                label: Text('Sign Out'),
                icon: Icon(Icons.logout),
                onPressed: () async {
                  await authProvider.signOut();
                      
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                  }
                },
              ),
            ),
          ],
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
        'About Me',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ],
  );
}

Widget buildProfile(context, profile) {
  return Column(
    children: [
      // Image
      ClipOval(
        child: (profile.photo != null && profile!.photo!.isNotEmpty)
            ? Image.network(
                profile!.photo!,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              )
            : Image.asset(
                "assets/img/logo-noimage.png",
                width: 150,
                height: 150,
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
          Row(
            children: [
              Text(
                profile.name ?? '',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              buttonEdit(context),
            ],
          ),
          Text(profile.profession ?? ''),
          const SizedBox(height: 8),
          Text(profile.bio ?? ''),
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
        Text(text ?? ''),
      ],
    ),
  );
}

Widget buttonEdit(context) {
  return IconButton(
    icon: Icon(Icons.edit, color: Color(0xFF7B5FFF)),
    onPressed: () {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (_) => EditProfileScreen()),
      // );

      Navigator.pushNamed(context, AppRoutes.editProfile);
    },
    tooltip: 'Edit',
  );
}
