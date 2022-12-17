import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage ({super.key});
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
            const Text("LoginPage"),
            TextButton(
                onPressed: () {Navigator.pop(context);},
                child: const Text("FirstPage"))
          ],
        ),
      ),
    );
  }
}