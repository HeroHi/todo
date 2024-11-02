class TaskModel {
  String id;
  String title;
  String description;
  DateTime date;
  bool isDone;
  static String collectionName = "tasks";

  TaskModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.date,
      required this.isDone});

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      date: DateTime.parse(json["date"]),
      isDone: json["isDone"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "date": date.toIso8601String(),
      "isDone": isDone,
    };
  }
//
}
