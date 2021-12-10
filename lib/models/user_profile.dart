import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  String name;
  String phone;
  String id;
  UserProfile({required this.id, required this.name, required this.phone});

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {

    return UserProfile(
      id: doc['id'] ?? '',
      name: doc['name'] ?? '',
      phone: doc['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => { 'id': id, 'name': name, 'phone': phone};

}
