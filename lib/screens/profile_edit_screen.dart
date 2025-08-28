import 'package:flutter/material.dart';
import 'package:my_portfolio_app/providers/profile_provider.dart';
import 'package:my_portfolio_app/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final InputDecoration fieldDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.black,
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 1,
        ),
      ),
    );

    final profileProvider = context.read<ProfileProvider>();

    return Scaffold(
      appBar: CustomAppBar(title: 'Edit Profile'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: profileProvider.nameController,
              decoration: fieldDecoration.copyWith(labelText: 'Edit Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: profileProvider.professionController,
              decoration: fieldDecoration.copyWith(
                labelText: 'Edit Profession',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: profileProvider.bioController,
              decoration: fieldDecoration.copyWith(labelText: 'Edit Bio'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      profileProvider.updateProfile();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Profile updated successfully!"),
                          backgroundColor: Colors.deepPurple.shade100,
                          duration: Duration(seconds: 2),
                        ),
                      );

                      Navigator.pop(context, true);
                    },
                    child: const Text('Update Profile'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
