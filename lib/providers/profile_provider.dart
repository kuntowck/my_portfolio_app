import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_portfolio_app/models/profile_model.dart';
import 'package:my_portfolio_app/services/profile_service.dart';

class ProfileProvider extends ChangeNotifier {
  // Profile _profiles = Profile(
  //   name: "Kunto Wicaksono",
  //   profession: "Software Engineer",
  //   bio:
  //       'Halo! You can call me Kunto. I am a passionate software engineer with experience '
  //       'building mobile and web apps. I love clean code, coffee, and football.',
  // );
  final picker = ImagePicker();
  final formKey = GlobalKey<FormState>();
  final ProfileService _profileService = ProfileService();
  Profile? _profile;
  bool _isLoading = false;

  Profile? get profile => _profile;
  bool get isLoading => _isLoading;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final professionController = TextEditingController();
  final bioController = TextEditingController();

  Future<void> loadProfile(String uid) async {
    _setLoading(true);

    try {
      _profile = await _profileService.getUserProfile(uid);

      if (_profile != null) {
        nameController.text = _profile!.name;
        phoneController.text = _profile!.phone ?? '';
        addressController.text = _profile!.address ?? '';
        professionController.text = _profile!.profession ?? '';
        bioController.text = _profile!.bio ?? '';
      }

      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateProfile() async {
    if (_profile == null) return;

    if (!formKey.currentState!.validate()) return;

    _setLoading(true);

    try {
      final profileUpdated = Profile(
        uid: _profile!.uid,
        email: _profile!.email,
        role: _profile!.role,
        photo: _profile!.photo ?? '',
        name: nameController.text,
        phone: phoneController.text,
        address: addressController.text,
        profession: professionController.text,
        bio: bioController.text,
      );

      await _profileService.updateUserProfile(profileUpdated);

      _profile = profileUpdated;

      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> uploadProfilePhoto(File file) async {
    if (_profile == null) return;

    _isLoading = true;

    notifyListeners();

    try {
      final url = await _profileService.uploadProfilePhoto(_profile!.uid, file);
      final updatedProfile = _profile!.copyWith(photo: url);

      await _profileService.updateUserProfile(updatedProfile);

      _profile = updatedProfile;

      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      uploadProfilePhoto(File(pickedFile.path));
    }
  }

  void clearProfile() {
    _profile = null;

    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;

    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    professionController.dispose();
    bioController.dispose();
    super.dispose();
  }
}
