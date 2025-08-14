import 'package:flutter/material.dart';
import 'package:my_portfolio_app/models/profile_model.dart';

class ProfileProvider extends ChangeNotifier {
  Profile _profiles = Profile(
    name: "Kunto Wicaksono",
    profession: "Software Engineer",
    bio:
        'Halo! You can call me Kunto. I am a passionate software engineer with experience '
        'building mobile and web apps. I love clean code, coffee, and football.',
  );

  Profile get profiles => _profiles;

  late TextEditingController nameController;
  late TextEditingController professionController;
  late TextEditingController bioController;

  ProfileProvider() {
    nameController = TextEditingController(text: profiles.name);
    professionController = TextEditingController(text: profiles.profession);
    bioController = TextEditingController(text: profiles.bio);
  }

  void updateProfile() {
    _profiles = Profile(
      name: nameController.text,
      profession: professionController.text,
      bio: bioController.text,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    professionController.dispose();
    bioController.dispose();
    super.dispose();
  }
}
