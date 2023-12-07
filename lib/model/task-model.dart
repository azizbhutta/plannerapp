class Task {
  String id;
  String title;
  DateTime? dateTime;

  Task({required this.id, required this.title, this.dateTime});

  factory Task.fromMap(Map<String, dynamic> map, String id) {
    return Task(
      id: id, // Use the provided document ID
      title: map['title'] ?? '',
      dateTime: map['dateTime']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'dateTime': dateTime,
    };
  }
}
