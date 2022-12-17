import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChatApp extends StatelessWidget {
  ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    void signout() {
      GoogleSignIn().signOut();
      FirebaseAuth.instance.signOut();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("ChatApp"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(user.email!),
            ElevatedButton(
                onPressed: signout,
                child: const Text("Sign Out")
            )
          ],
        ),
      )
    );
  }
}