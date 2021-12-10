import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blips/providers/auth_provider.dart';
import 'package:blips/services/shared_prefs.dart';
import 'package:blips/models/user_profile.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void signIn(String email, String password, AuthProvider authProvider) async {
    auth.signInWithEmailAndPassword(email: email, password: password)
        .then((userCredential) {
      final user = userCredential.user;
      authProvider.setUser(user!);

    });
  }

  Future<void> register(String email, String password, AuthProvider authProvider) async {

    final User? user = (await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user;

    UserProfile userProfile  = UserProfile(id: user?.uid ?? "", name: "", phone: "");

    await _firestore.collection('users')
        .doc(user?.uid).set(userProfile.toJson());

    sharedPrefs.uid = user?.uid?? "";
    authProvider.setUser(user!);


  }
}