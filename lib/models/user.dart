import 'dart:convert';

class User {
  String userEmail, uid;
  bool isSelected;
  var groupID;

  User({required this.userEmail, required this.uid, required this.isSelected, required this.groupID});

  void getsSelected() {
    this.isSelected = !this.isSelected;
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': userEmail,
    'isSelected': isSelected,
    'groups': groupID
  };

  static User fromJson(Map<String, dynamic> json) => User (
    uid: json['uid'],
    userEmail: json['email'],
    isSelected: json['isSelected'],
    groupID: json['groups']
  );
}