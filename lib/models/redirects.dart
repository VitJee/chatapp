import 'package:chatapp/views/createGroup.dart';
import 'package:chatapp/views/searchgroup.dart';
import 'package:chatapp/views/login.dart';
import 'package:chatapp/views/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Redirect {
  static void signOut(context) {
    GoogleSignIn().signOut();
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return Login();
    }));
  }

  static void searchGroups(context) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return SearchGroup();
    }));
  }

  static void allUsers(context) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return Users();
    }));
  }

  static void createGroup(context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
          return CreateGroup();
        }));
  }
}
