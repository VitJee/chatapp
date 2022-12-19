import 'package:chatapp/models/redirects.dart';
import 'package:chatapp/views/searchgroup.dart';
import 'package:chatapp/views/users.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class CreateGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CreateGroupPage();
  }
}

class CreateGroupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CreateGroupState();
}

class CreateGroupState extends State<CreateGroupPage> {

  final _groupNameController = TextEditingController();
  final double paddingLeft = 50;
  final double paddingRight = 50;
  final double paddingTop = 10;
  final double paddingBottom = 30;

  void createGroup() {
    List<String> list = [];
    /*FirebaseFirestore.instance.collection("groups").doc(_groupNameController.text).set({
      "chat": list,
      "id": _groupNameController.text,
      "isSelected": false
    });*/
    DatabaseReference db = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: "https://chatapp-lernatelier-default-rtdb.europe-west1.firebasedatabase.app/"
    ).ref("groups/${_groupNameController.text}");
    db.set({
      "chat": [""]
    });
    setState(() {
      _groupNameController.clear();
    });
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
      return SearchGroup();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Group"),
      ),
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(paddingLeft, paddingTop, paddingRight, paddingBottom),
              child: TextField(
                controller: _groupNameController,
                decoration: const InputDecoration(
                    labelText: "Group Name",
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3, color: Colors.blue
                        )
                    )
                ),
              ),
          ),
          ElevatedButton(
              onPressed: createGroup,
              child: Text("Create Group")
          )
        ],
      ),
    );
  }
}