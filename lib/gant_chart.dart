import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gantt_diagram/models.dart';
import 'package:intl/intl.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

class GanttChart extends StatefulWidget {
  GanttChart({
    super.key,
    required this.eventList,
    this.activitiesHeight = 50,
    this.activitiesWidth = 120,
    this.headerHeight = 50,
    this.weekWidth = 150,
    this.gap = 3,
  }) : assert(
            eventList
                .every((task) => task.startDate.compareTo(task.endDate) < 0),
            'startDate must be before endDate in each task');

  double activitiesWidth;
  double weekWidth;
  double activitiesHeight;
  double headerHeight;
  final double gap;
  List<Task> eventList;

  @override
  State<GanttChart> createState() => _GanttChartState();
}

class _GanttChartState extends State<GanttChart> {
  late LinkedScrollControllerGroup _verticalControllersGroup;

  final ScrollController _horizontalController = ScrollController();

  late ScrollController _vertical1Scroll;
  late ScrollController _vertical2Scroll;

  ///Obtain the minimun date oh the task list
  DateTime get minDate {
    List<Task> taskList = [];
    for (var task in widget.eventList) {
      taskList.add(task);

      for (var subtask in task.subTaks) {
        taskList.add(subtask);
      }
    }
    return taskList
        .reduce((value, element) =>
            value.startDate.compareTo(element.startDate) < 0 ? value : element)
        .startDate;
  }

  ///Obtain the maximum date oh the task list
  DateTime get maxDate {
    List<Task> taskList = [];
    for (var task in widget.eventList) {
      taskList.add(task);

      for (var subtask in task.subTaks) {
        taskList.add(subtask);
      }
    }
    return taskList
        .reduce((value, element) =>
            value.startDate.compareTo(element.endDate) > 0 ? value : element)
        .endDate;
  }

  ///week start date list
  List<DateTime> get weekStartDateList {
    List<DateTime> startDates = [];
    int weekday = minDate.weekday;
    DateTime startDateOfWeek = minDate.subtract(Duration(days: weekday - 1));
    if (weekday == 6 || weekday == 7) {
      startDateOfWeek = startDateOfWeek.add(const Duration(days: 7));
    }
    for (DateTime date = startDateOfWeek;
        date.isBefore(maxDate);
        date = date.add(const Duration(days: 7))) {
      startDates.add(date);
      // print(date);
    }
    return startDates;
  }

  @override
  void initState() {
    _verticalControllersGroup = LinkedScrollControllerGroup();
    _vertical1Scroll = _verticalControllersGroup.addAndGet();
    _vertical2Scroll = _verticalControllersGroup.addAndGet();

    super.initState();
  }

  @override
  void dispose() {
    _vertical1Scroll.dispose();
    _vertical2Scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          // color: Colors.amber,
          width: widget.activitiesWidth,
          child: Column(
            children: [
              SizedBox(
                height: widget.headerHeight,
              ),
              const SizedBox(
                height: 5,
              ),
              Flexible(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: ListView(
                    controller: _vertical1Scroll,
                    // mainAxisSize: MainAxisSize.min,
                    // shrinkWrap: true,
                    children: [
                      ...widget.eventList.map((task) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: widget.gap),
                              width: widget.activitiesWidth,
                              height: widget.activitiesHeight,
                              color: Colors.blue,
                              child: Center(
                                child: Text(
                                  task.name,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            ...task.subTaks.map((subtask) {
                              return Container(
                                margin:
                                    EdgeInsets.only(top: widget.gap, left: 15),
                                width: widget.activitiesWidth,
                                height: widget.activitiesHeight,
                                // padding: const EdgeInsets.only(left: 20),
                                color: Colors.lightBlue,
                                child: Center(
                                  child: Text(
                                    subtask.name,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            })
                          ],
                        );
                      })
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
            // width: weekStartDateList.length * weekWidth,
            child: Scrollbar(
          controller: _horizontalController,
          trackVisibility: true,
          scrollbarOrientation: ScrollbarOrientation.bottom,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _horizontalController,
            child: Scrollbar(
              controller: _vertical2Scroll,
              trackVisibility: true,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...weekStartDateList.map((weekStartDate) {
                        final initialDayOfWeek = weekStartDate;
                        final endDateOfWeek =
                            initialDayOfWeek.add(const Duration(days: 4));

                        final startDateString =
                            DateFormat('MMM d').format(initialDayOfWeek);
                        final endDateString = DateFormat(
                                '${initialDayOfWeek.month == endDateOfWeek.month ? '' : 'MMM '}d')
                            .format(endDateOfWeek);

                        final headerString =
                            '$startDateString - $endDateString';
                        return Container(
                          padding: EdgeInsets.only(left: widget.gap),
                          height: widget.headerHeight,
                          width: widget.weekWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  color: Colors.grey.shade300,
                                  child: Center(
                                    child: Text(
                                      headerString,
                                      style:
                                          const TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                color: Colors.cyan,
                                width: widget.weekWidth,
                                child: const Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        child: Text(
                                      'L',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    )),
                                    Expanded(
                                        child: Text(
                                      'M',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    )),
                                    Expanded(
                                        child: Text(
                                      'M',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    )),
                                    Expanded(
                                        child: Text(
                                      'J',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    )),
                                    Expanded(
                                        child: Text(
                                      'V',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    )),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      })
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      controller: _vertical2Scroll,
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...widget.eventList.map((task) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    ...weekStartDateList.map((weekStartDate) {
                                      List<bool> daysUsed = [];
                                      for (var days in [0, 1, 2, 3, 4]) {
                                        final date = weekStartDate
                                            .add(Duration(days: days));

                                        daysUsed.add(date.compareTo(
                                                    task.startDate) >=
                                                0 &&
                                            date.compareTo(task.endDate) <= 0);
                                      }
                                      // final endDateOfWeek =
                                      //     weekStartDate.add(const Duration(days: 4));

                                      return Container(
                                        margin:
                                            EdgeInsets.only(top: widget.gap),
                                        padding:
                                            EdgeInsets.only(left: widget.gap),
                                        width: widget.weekWidth,
                                        height: widget.activitiesHeight,
                                        child: Row(
                                          children: [
                                            ...daysUsed.map((dayUsed) {
                                              return Expanded(
                                                  child: Container(
                                                color: dayUsed
                                                    ? Colors.blue
                                                    : Colors.grey,
                                              ));
                                            })
                                          ],
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                                ...task.subTaks.map((subtask) {
                                  return Row(
                                    children: [
                                      ...weekStartDateList.map((weekStartDate) {
                                        List<bool> daysUsed = [];
                                        for (var days in [0, 1, 2, 3, 4]) {
                                          final date = weekStartDate
                                              .add(Duration(days: days));

                                          daysUsed.add(date.compareTo(
                                                      task.startDate) >=
                                                  0 &&
                                              date.compareTo(task.endDate) <=
                                                  0);
                                        }
                                        // final endDateOfWeek =
                                        //     weekStartDate.add(const Duration(days: 4));

                                        return Container(
                                          margin:
                                              EdgeInsets.only(top: widget.gap),
                                          padding:
                                              EdgeInsets.only(left: widget.gap),
                                          width: widget.weekWidth,
                                          height: widget.activitiesHeight,
                                          child: Row(
                                            children: [
                                              ...daysUsed.map((dayUsed) {
                                                return Expanded(
                                                    child: Container(
                                                  color: dayUsed
                                                      ? Colors.lightBlue
                                                      : Colors.grey,
                                                ));
                                              })
                                            ],
                                          ),
                                        );
                                      }),
                                    ],
                                  );
                                })
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  // Column(
                  //   children: [
                  //     ScrollConfiguration(
                  //       behavior: ScrollConfiguration.of(context)
                  //           .copyWith(scrollbars: false),
                  //       child: ListView(
                  //         controller: _vertical3Scroll,
                  //         // mainAxisSize: MainAxisSize.min,
                  //         // shrinkWrap: true,
                  //         children: [
                  //           ...widget.eventList.map((task) {
                  //             return const CircleAvatar();
                  //           })
                  //         ],
                  //       ),
                  //     )
                  //   ],
                  // )
                ],
              ),
            ),
          ),
        ))
      ],
    );
  }
}

Color randomColor() {
  final random = Random();
  Color color = Color.fromARGB(
      255, random.nextInt(200), random.nextInt(200), random.nextInt(200));
  return color;
}

class WeekRange {
  DateTime firstDayWeek;
  DateTime lastDayWeek;
  WeekRange({
    required this.firstDayWeek,
    required this.lastDayWeek,
  });
}

// enum WeekDay {
//   monday(DateTime.monday, 'L'),
//   tuesday(DateTime.tuesday, 'M'),
//   wednesday(DateTime.wednesday, 'M'),
//   thursday(DateTime.thursday, 'J'),
//   friday(DateTime.friday, 'V'),
//   saturday(DateTime.saturday, 'S'),
//   sunday(DateTime.sunday, 'D');

//   factory WeekDay.fromIntWeekday(int weekDay) {
//     return WeekDay.values[weekDay - 1];
//   }
//   factory WeekDay.fromDateTime(DateTime day) {
//     return WeekDay.values[day.weekday - 1];
//   }

//   final int number;
//   final String symbol;
//   const WeekDay(this.number, this.symbol);

//   @override
//   String toString() => '$name ($number)';
// }
