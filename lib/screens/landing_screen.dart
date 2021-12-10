import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:blips/screens/auth_screen.dart';
import 'package:blips/screens/home_screen.dart';

class LandingScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          return
            (snapshot.hasData) ? HomeScreen() : AuthScreen(emailController: emailController, passwordController: passwordController);
        });


  }
}
