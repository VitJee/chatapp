import 'package:chatapp/views/chatapp.dart';
import 'package:chatapp/views/signup.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
      home: Login()
  ));
}

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: StreamBuilder<User?> (
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ChatApp();
        } else {
          return LoginPage();
        }
      },
    )
  );
}

class LoginPage extends StatefulWidget {
  LoginPage({super.key});
  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {

  final CollectionReference users = FirebaseFirestore.instance.collection("users");
  final String title = "Login Page";
  final double paddingLeft = 50;
  final double paddingRight = 50;
  final double paddingTop = 10;
  final double paddingBottom = 30;

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  Future login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email.text.trim(),
          password: _password.text.trim()
      );
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  void signUp() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
      return SignUp();
    }));
  }

  void signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken
    );
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
  }

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
                )
            ),
            Padding(padding: EdgeInsets.fromLTRB(paddingLeft, paddingTop, paddingRight, paddingBottom),
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
                ),)
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
                ElevatedButton(
                    onPressed: login,
                    child: const Text("Login")
                ),
                Padding(padding: EdgeInsets.fromLTRB(5, 0, 5, 0)),
                ElevatedButton(
                    onPressed: signInWithGoogle,
                    child: Text("Google Signin")
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RichText(
                    text: TextSpan(
                      text: "No Account?",
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
                          text: " SignUp",
                          recognizer: TapGestureRecognizer()..onTap = () {
                            signUp();
                          }
                        )
                      ]
                    )
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/*
class LoginPage extends StatelessWidget {
  LoginPage ({super.key});

  final CollectionReference users = FirebaseFirestore.instance.collection("users");
  final String title = "Login Page";
  final double paddingLeft = 50;
  final double paddingRight = 50;
  final double paddingTop = 0;
  final double paddingBottom = 0;
  final double fontSize = 30;

  var username = new TextEditingController();

  void login() {
    print(User.createUserID());
  }

  void register() {

  }

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
            Text("Username:", style: TextStyle(fontSize: fontSize)),
            Padding(
                padding: EdgeInsets.fromLTRB(paddingLeft, paddingTop, paddingRight, paddingBottom),
                child: TextField(
                  controller: username,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3, color: Colors.blue
                        )
                    )
                ),)
            ),
            Text("Password:", style: TextStyle(fontSize: fontSize),),
            Padding(padding: EdgeInsets.fromLTRB(paddingLeft, paddingTop, paddingRight, paddingBottom),
                child: const TextField(decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3, color: Colors.blue
                        )
                    )
                ),)
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
                ElevatedButton(
                    onPressed: login,
                    child: const Text("Login")
                ),
                const Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0)),
                ElevatedButton(
                    onPressed: register,
                    child: const Text("Register")
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
*/