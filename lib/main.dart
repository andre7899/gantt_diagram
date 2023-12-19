import 'package:flutter/material.dart';
import 'package:gantt_diagram/gant_chart.dart';
import 'package:gantt_diagram/models.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gantt',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Diagrama de gantt'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Center(
          child: GanttChart(
            eventList: taskExamples,
            activitiesHeight: 40,
            activitiesWidth: 96,
            headerHeight: 50,
            gap: 5,
          ),
        ),
      ),
    );
  }
}

List<Task> taskExamples = [
  Task(
      name: 'Tarea1',
      startDate: DateTime(2023, 08, 19),
      endDate: DateTime(2023, 09, 12),
      subTaks: [
        Task(
            name: 'subTarea2',
            startDate: DateTime(2023, 09, 10),
            endDate: DateTime(2023, 10, 5)),
        Task(
            name: 'subTarea3',
            startDate: DateTime(2023, 09, 10),
            endDate: DateTime(2023, 10, 5)),
        Task(
            name: 'subTarea4',
            startDate: DateTime(2023, 09, 10),
            endDate: DateTime(2023, 10, 5)),
      ]),
  Task(
      name: 'Tarea2',
      startDate: DateTime(2023, 09, 10),
      endDate: DateTime(2023, 10, 5)),
  Task(
      name: 'Tarea3',
      startDate: DateTime(2023, 10, 3),
      endDate: DateTime(2023, 10, 20),
      subTaks: [
        Task(
            name: 'subTarea1',
            startDate: DateTime(2023, 09, 10),
            endDate: DateTime(2023, 10, 5)),
        Task(
            name: 'subTarea2',
            startDate: DateTime(2023, 09, 10),
            endDate: DateTime(2023, 10, 5)),
      ]),
  Task(
      name: 'Tarea4',
      startDate: DateTime(2023, 10, 3),
      endDate: DateTime(2023, 10, 20)),
  // Task(
  //     name: 'Tarea5',
  //     startDate: DateTime(2023, 9, 15),
  //     endDate: DateTime(2023, 10, 20)),
  Task(
      name: 'Tarea6',
      startDate: DateTime(2023, 10, 3),
      endDate: DateTime(2023, 10, 20),
      subTaks: [
        Task(
            name: 'subTarea2',
            startDate: DateTime(2023, 09, 10),
            endDate: DateTime(2023, 10, 5)),
        Task(
            name: 'subTarea2',
            startDate: DateTime(2023, 09, 10),
            endDate: DateTime(2023, 10, 5)),
        Task(
            name: 'subTarea2',
            startDate: DateTime(2023, 09, 10),
            endDate: DateTime(2023, 10, 5)),
      ]),
  Task(
      name: 'Tarea7',
      startDate: DateTime(2023, 10, 3),
      endDate: DateTime(2023, 10, 20)),
  Task(
      name: 'Tarea8',
      startDate: DateTime(2023, 10, 3),
      endDate: DateTime(2023, 10, 25)),
];
