import 'package:flutter/material.dart';
import 'dart:math';

class User {
  final String userName;
  final String userPassword;
  final String userID;
  static int LENGTH_OF_ID = 20;

  const User(this.userName, this.userPassword, this.userID);

  static String createUserID() {
    var aCode = 'A'.codeUnitAt(0);
    var zCode = 'Z'.codeUnitAt(0);
    List<String> alphabets = List<String>.generate(
      zCode - aCode + 1,
          (index) => String.fromCharCode(aCode + index),
    );
    String ret = "";
    for (int i = 0; i < LENGTH_OF_ID; i++) {
      ret += alphabets[Random().nextInt(26)];
    }
    return ret;
  }
}