import 'package:chatapp/models/group.dart';
import 'package:chatapp/models/user.dart' as modUser;
import 'package:chatapp/views/chat.dart';
import 'package:chatapp/views/createGroup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  late Stream<List<Group>> allGroupsStream;
  List<Group> allGroups = [];
  var userAuth = FirebaseAuth.instance.currentUser!;

  var labelText = "Type Name here";

  @override
  void initState() {
    allGroupsStream = FirebaseFirestore.instance.collection("groups")
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Group.fromJson(doc.data())).toList());
    readUsers();
    super.initState();
  }

  final double fontSize = 32;
  var searchFriend = TextEditingController();

  void readUsers() async {
    allGroups = await allGroupsStream.first;
    setState(() {});
  }

  void openChat(Group selectedGroup) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
      return Chat(group: selectedGroup);
    }));
  }

  void searchGroup() {
  }

  void createGroup() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
      return CreateGroup();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: TextField(
            controller: searchFriend,
            decoration: InputDecoration(
              labelText: labelText
            ),
          )
      ),
      body: allGroups.length > 0 ? ListView.separated(
          itemCount: allGroups.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.chat),
              title: Text(allGroups[index].groupID),
              onTap: () {
                setState(() {
                  openChat(allGroups[index]);
                });
              },
            );
          }, separatorBuilder: (BuildContext context, int index) =>
          Divider(
            color: Colors.black,
          ),
      ) : Center(
        child: Text("No Group found"),
      ),
      floatingActionButton: SpeedDial(
        child: Icon(Icons.menu),
        children: [
          SpeedDialChild(
            child: Icon(Icons.search),
            label: "Search",
            onTap: searchGroup
          ),
          SpeedDialChild(
            child: Icon(Icons.add),
            label: "Create Group",
            onTap: createGroup
          )
        ],
      )
    );
  }
}