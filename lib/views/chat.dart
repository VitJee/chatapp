import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/group.dart';

class Chat extends StatefulWidget {
  Chat({required this.group});
  late Group group;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  var _chatController = TextEditingController();
  List<dynamic> chat = ["not init"];

  @override
  void initState() {
    setState(() {
      readChat();
    });
    print("hello");
  }

  void readChat() async {
    DocumentReference dr = FirebaseFirestore.instance.collection("groups").doc(widget.group.groupID);
    dr.get().then((doc) {
      final data = doc.data() as Map<String, dynamic>;
      chat.addAll(data["chat"]);
    });
  }

  void sendMessage() async {
    DocumentReference ds = FirebaseFirestore.instance.collection("groups").doc(widget.group.groupID);
    ds.update({"chat": FieldValue.arrayUnion([_chatController.text])});
    _chatController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            sendMessage();
          });
        },
        child: Icon(Icons.send),
      ),
      appBar: AppBar(title: TextField(
        controller: _chatController,
      )),
      body: ListView.builder(
          itemCount: chat.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(chat[index]),
            );
          }
      ),
    );
  }
}