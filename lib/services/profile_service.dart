import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';

class ProfileService {
  final CollectionReference profiles = FirebaseFirestore.instance.collection(
    'users',
  );
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> createUserProfile(Profile profile) async {
    await profiles.doc(profile.uid).set(profile.toMap());
  }

  Future<Profile?> getUserProfile(String uid) async {
    final doc = await profiles.doc(uid).get();

    if (doc.exists) {
      return Profile.fromMap(doc.data() as Map<String, dynamic>);
    }

    return null;
  }

  Future<void> updateUserProfile(Profile profile) async {
    await profiles.doc(profile.uid).update(profile.toMap());
  }

  Future<bool> checkUserExists(String uid) async {
    final doc = await profiles.doc(uid).get();

    return doc.exists;
  }

  Future<String> uploadProfilePhoto(String uid, File file) async {
    final String fileName = uid;

    await _supabase.storage
        .from('profile-photos')
        .upload(fileName, file, fileOptions: const FileOptions(upsert: true));

    final url = _supabase.storage.from('profile-photos').getPublicUrl(fileName);

    await profiles.doc(uid).update({'photo': url});

    return url;
  }
}
