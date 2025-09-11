class Profile {
  final String uid;
  final String email;
  final String name;
  final String role;
  final String? phone;
  final String? address;
  final String? profession;
  final String? bio;
  final String? photo;

  Profile({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    this.phone,
    this.address,
    this.profession,
    this.bio,
    this.photo,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'profession': profession,
      'email': email,
      'phone': phone,
      'address': address,
      'bio': bio,
      'photo': photo,
      'role': role,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> data) {
    return Profile(
      uid: data['uid'],
      name: data['name'],
      profession: data['profession'],
      email: data['email'],
      phone: data['phone'],
      address: data['address'],
      bio: data['bio'],
      photo: data['photo'],
      role: data['role'] ?? 'member',
    );
  }

  Profile copyWith({
    String? name,
    String? email,
    String? role,
    String? phone,
    String? address,
    String? profession,
    String? bio,
    String? photo,
  }) {
    return Profile(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      profession: profession ?? this.profession,
      bio: bio ?? this.bio,
      photo: photo ?? this.photo,
    );
  }
}
