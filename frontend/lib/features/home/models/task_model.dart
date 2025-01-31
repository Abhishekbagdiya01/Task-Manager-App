class TaskModel {
  String? id;
  final String title;
  final String description;
  String? uid;
  final String hexColor;
  final DateTime dueAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? isSynced;

  TaskModel({
    this.id,
    this.uid,
    required this.title,
    required this.description,
    required this.hexColor,
    required this.dueAt,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'uid': uid,
      'hexColor': hexColor,
      'dueAt': dueAt.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isSynced': isSynced,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
        id: map["id"],
        title: map["title"],
        description: map["description"],
        uid: map["uid"],
        hexColor: map["hexColor"],
        dueAt: DateTime.parse(map["dueAt"]),
        createdAt: DateTime.parse(map["createdAt"]),
        updatedAt: DateTime.parse(map['updatedAt']),
        isSynced: map["isSynced"] ?? 1);
  }
}
