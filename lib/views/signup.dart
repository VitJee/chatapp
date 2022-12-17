import 'package:chatapp/views/chatapp.dart';
import 'package:chatapp/views/signup.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login.dart';

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      body: StreamBuilder<User?> (
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ChatApp();
          } else {
            return SignUpPage();
          }
        },
      )
  );
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  final String title = "Sign Up";

  @override
  State<StatefulWidget> createState() => SignUpState();
}

class SignUpState extends State<SignUpPage> {

  final double paddingLeft = 50;
  final double paddingRight = 50;
  final double paddingTop = 10;
  final double paddingBottom = 30;

  final _email = TextEditingController();
  final _password = TextEditingController();

  Future signUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email.text.trim(),
          password: _password.text.trim()
      );
    } on FirebaseAuthException catch(e) {
      print(e);
    }
  }

  void signIn() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
      return Login();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(paddingLeft, paddingTop, paddingRight, 0),
              child: TextField(
                controller: _email,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                    labelText: "Email",
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3, color: Colors.blue
                        )
                    )
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(paddingLeft, paddingTop, paddingRight, paddingBottom),
              child: TextField(
                controller: _password,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                    labelText: "Password",
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3, color: Colors.blue
                        )
                    )
                ),
              ),
            ),
            ElevatedButton(
                onPressed: signUp,
                child: Text("SignUp")
            ),
            RichText(
                text: TextSpan(
                    text: "You already have an Account?",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20
                    ),
                    children: [
                      TextSpan(
                          style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline
                          ),
                          text: " SignIn",
                          recognizer: TapGestureRecognizer()..onTap = () {
                            signIn();
                          }
                      )
                    ]
                )
            )
          ],
        ),
      ),
    );
  }
}