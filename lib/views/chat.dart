import 'package:cloud_firestore/cloud_firestore.dart' as fireStore;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:string_splitter/string_splitter.dart';

import '../models/group.dart';

class Chat extends StatefulWidget {
  Chat({required this.groupID});

  late String groupID;

  @override
  State<Chat> createState() => _ChatState(groupID: groupID);
}

class _ChatState extends State<Chat> {
  _ChatState({required this.groupID});

  var _chatController = TextEditingController();
  late String groupID;
  late Query chatQuery = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL:
              "https://chatapp-lernatelier-default-rtdb.europe-west1.firebasedatabase.app/")
      .ref()
      .child("groups/${groupID}/chat");
  List<dynamic> allChat = [];

  @override
  void initState() {
    setState(() {
      readChat();
    });
  }

  bool isItTheSender(String message) {
    if (message.split(":")[0] == FirebaseAuth.instance.currentUser!.email) {
      return true;
    } else {
      return false;
    }
  }

  String getDisplayName(String message) {
    List<String> strList = StringSplitter.split(
        message,
        splitters: ["@", ":"]
    );
    return "${strList[0]}: ${strList[2]}";
  }

  void readChat() async {
    var snapshot = await chatQuery.get();
    allChat = snapshot.value as List<dynamic>;

    setState(() {});
  }

  void sendMessage() async {
    //DocumentReference ds = FirebaseFirestore.instance.collection("groups").doc(widget.groupID);
    String email = FirebaseAuth.instance.currentUser!.email.toString();
    String message = "$email: ${_chatController.text}";
    //ds.update({"chat": FieldValue.arrayUnion([message])});
    DatabaseReference ref = FirebaseDatabase.instanceFor(
            app: Firebase.app(),
            databaseURL:
                "https://chatapp-lernatelier-default-rtdb.europe-west1.firebasedatabase.app/")
        .ref("groups/$groupID");
    var snapshot = await chatQuery.get();
    List<dynamic> chatHistory = snapshot.value as List<dynamic>;
    chatHistory.add(message);
    ref.set({
      "chat": chatHistory
    });

    setState(() {
      _chatController.clear();
    });
    readChat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: sendMessage,
          child: Icon(Icons.send),
        ),
        appBar: AppBar(title: Text("Chat - ${groupID}")),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(50, 10, 50, 30),
              child: TextField(
                controller: _chatController,
                decoration: const InputDecoration(
                    labelText: "Type here",
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3, color: Colors.blue))),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: allChat.length,
                  itemBuilder: (context, index) {
                    if (allChat[0] == allChat.last) {
                      return const Center(
                        child: Text("Chat is empty"),
                      );
                    } else {
                      if (index != 0) {
                        Color c = Colors.grey;
                        if (isItTheSender(allChat[index])) {
                          c = Colors.green;
                        }
                        return BubbleNormal(
                          text: getDisplayName(allChat[index]),
                          color: c,
                          isSender: isItTheSender(allChat[index]),
                        );
                      } else {
                        return const Text("");
                      }
                    }
                  }
              )
            ),
          ],
        ));
  }
}

/*
FirebaseAnimatedList(
                  padding: EdgeInsets.fromLTRB(50, 20, 50, 0),
                  query: chatQuery,
                  itemBuilder: (context, snapshot, animation, index) {
                    return BubbleNormal(
                      text: snapshot.value.toString(),
                      color: Colors.green,
                      isSender: false,
                    );
                  }),
 */