import 'package:flutter/material.dart';
import 'package:my_portfolio_app/providers/profile_provider.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.read<ProfileProvider>();

    // final TextEditingController nameController = TextEditingController(
    //   text: profileProvider.name,
    // );
    // final TextEditingController professionController = TextEditingController(
    //   text: profileProvider.profession,
    // );
    // final TextEditingController bioController = TextEditingController(
    //   text: profileProvider.bio,
    // );

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: profileProvider.nameController,
              decoration: const InputDecoration(labelText: 'Edit Name'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: profileProvider.professionController,
              decoration: const InputDecoration(labelText: 'Edit Profession'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: profileProvider.bioController,
              decoration: const InputDecoration(labelText: 'Edit Bio'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                profileProvider.updateProfile();
                Navigator.pop(context);
              },
              child: const Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
