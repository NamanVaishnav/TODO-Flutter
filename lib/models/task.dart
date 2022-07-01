class Task {
  int? id;
  String? title;
  String? note;
  int? isCompleted;
  String? date;
  String? startTime;
  String? endTime;
  int? color;

  Task({
    this.id,
    this.title,
    this.note,
    this.isCompleted,
    this.date,
    this.startTime,
    this.endTime,
    this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'color': color,
      'isCompleted': isCompleted,
    };
  }

  Task.fromMap(Map<String, dynamic> task) {
    id = task['id'];
    title = task['title'].toString();
    note = task['note'].toString();
    date = task['date'];
    startTime = task['startTime'];
    endTime = task['endTime'];
    color = task['color'];
    isCompleted = task['isCompleted'];
  }
}
