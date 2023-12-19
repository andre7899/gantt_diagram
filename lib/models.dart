class Task {
  String name;
  DateTime startDate;
  DateTime endDate;
  List<Task> subTaks;
  Task({
    required this.name,
    required this.startDate,
    required this.endDate,
    this.subTaks = const [],
  });
}
