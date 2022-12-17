import 'package:chatapp/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class loginPage extends StatelessWidget {
  const loginPage ({super.key});
  final String title = "Login Page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("LoginPage"),
            TextButton(
                onPressed: () {Navigator.pop(context);},
                child: Text("FirstPage"))
          ],
        ),
      ),
    );
  }
}