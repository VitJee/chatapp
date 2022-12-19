import 'package:chatapp/models/redirects.dart';
import 'package:chatapp/models/user.dart' as modUser;
import 'package:chatapp/views/searchgroup.dart';
import 'package:chatapp/views/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class Users extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return UsersPage();
  }
}

class UsersPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UsersState();
}

class UsersState extends State<UsersPage> {
  final double fontSize = 32;
  final user = FirebaseAuth.instance.currentUser!;
  List<modUser.User> allUsers = [];
  late Stream<List<modUser.User>> allUsersStream;

  String labelText = "bruh";

  @override
  void initState() {
    allUsers = [];
    allUsersStream = FirebaseFirestore.instance.collection("users")
        .where("uid", isNotEqualTo: user.uid)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => modUser.User.fromJson(doc.data())).toList());
    read();
    super.initState();
  }

  void read() async {
    allUsers = await allUsersStream.first;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ChatApp - Users"),
      ),
      body: allUsers.length > 0 ? ListView.separated(
          itemCount: allUsers.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.person_outline_outlined),
              title: Text(allUsers[index].userEmail),
              onTap: () {},
            );
          }, separatorBuilder: (BuildContext context, int index) =>
          Divider(
            color: Colors.black,
          ),
      ) : Center(
        child: Text("There are no Users"),
      ),
      floatingActionButton: SpeedDial(
        child: Icon(Icons.menu),
        children: [
          SpeedDialChild(
            child: Icon(Icons.search),
            label: "All Groups",
            onTap: () {
              Redirect.searchGroups(context);
            }
          ),
          SpeedDialChild(
            child: Icon(Icons.exit_to_app),
            label: "Sign Out",
            onTap: () {
              Redirect.signOut(context);
            }
          )
        ],
      )
    );
  }
}