class TaskModel {
  final String title;
  final String description;
  final String hexColor;
  final DateTime dueAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TaskModel({
    required this.title,
    required this.description,
    required this.hexColor,
    required this.dueAt,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'hexColor': hexColor,
      'dueAt': dueAt.toIso8601String(),
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
        title: map["title"],
        description: map["description"],
        hexColor: map["hexColor"],
        dueAt: DateTime.parse(map["dueAt"]),
        createdAt: DateTime.parse(map["createdAt"]),
        updatedAt: DateTime.parse(map['updatedAt']));
  }
}
