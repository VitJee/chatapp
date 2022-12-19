import 'package:chatapp/models/group.dart';
import 'package:chatapp/models/redirects.dart';
import 'package:chatapp/models/user.dart' as modUser;
import 'package:chatapp/views/chat.dart';
import 'package:chatapp/views/createGroup.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fireStore;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'users.dart';

class SearchGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SearchGroupPage();
  }
}

class SearchGroupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SearchGroupState();
}

class SearchGroupState extends State<SearchGroupPage> {
  var userAuth = FirebaseAuth.instance.currentUser!;
  late Query groupsQuery = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
      "https://chatapp-lernatelier-default-rtdb.europe-west1.firebasedatabase.app/")
      .ref()
      .child("groups");
  final double fontSize = 32;
  var searchGroupController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void searchGroup() {}

  void openChat(String selectedGroup) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return Chat(groupID: selectedGroup);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("ChatApp - All Groups")),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(50, 10, 50, 30),
              child: TextField(
                controller: searchGroupController,
                decoration: const InputDecoration(
                    labelText: "Search Group",
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3, color: Colors.blue
                        )
                    )
                ),
              ),
            ),
            Expanded(
              child: FirebaseAnimatedList(
                  query: groupsQuery,
                  itemBuilder: (context, snapshot, animation, index) {
                    Map groups = snapshot.value as Map;
                    groups["key"] = snapshot.key;
                    return ListTile(
                      title: Text(snapshot.key.toString()),
                      onTap: () {
                        openChat(snapshot.key.toString());
                      },
                    );
                  }),
            ),
          ],
        ),
        floatingActionButton: SpeedDial(
          child: Icon(Icons.menu),
          children: [
            SpeedDialChild(
                child: Icon(Icons.people),
                label: "All Users",
                onTap: () {
                  Redirect.allUsers(context);
                }),
            SpeedDialChild(
                child: Icon(Icons.search),
                label: "All Groups",
                onTap: searchGroup),
            SpeedDialChild(
                child: Icon(Icons.add),
                label: "Create Group",
                onTap: () {
                  Redirect.createGroup(context);
                }),
            SpeedDialChild(
                child: Icon(Icons.exit_to_app),
                label: "Sign Out",
                onTap: () {
                  Redirect.signOut(context);
                })
          ],
        )
    );
  }
}
