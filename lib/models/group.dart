class Group {

  String groupID;
  bool isSelected;

  Group({required this.groupID, required this.isSelected});

  Map<String, dynamic> toJson() => {
    'id': groupID,
    'isSelected': isSelected,
  };

  static Group fromJson(Map<String, dynamic> json) => Group (
    groupID: json['id'],
    isSelected: json['isSelected'],
  );
}