import 'package:flutter/material.dart';
import 'package:todo_flutter/models/task.dart';
import 'package:todo_flutter/ui/theme.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({Key? key, required this.task}) : super(key: key);
  final Task task;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.height * 0.23
          : 200,
      width: MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.width * 0.7,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: MediaQuery.of(context).orientation == Orientation.portrait
              ? 20
              : 0),
      decoration: BoxDecoration(
          color: task.color == 0 ? orangeClr : Colors.green,
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${task.title}',
                  style: Themes().taskTileHeadingTextStyle,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text('${task.date}',
                    style: const TextStyle(color: Colors.white)),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_sharp,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text('${task.startTime} - ${task.endTime}',
                        style: const TextStyle(color: Colors.white)),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: SingleChildScrollView(
                        child: Text(
                  '${task.note}',
                  style: const TextStyle(color: Colors.white),
                )))
              ],
            ),
          ),
          RotatedBox(
            quarterTurns: 3,
            child: task.isCompleted == 0
                ? const Text('TODO', style: TextStyle(color: Colors.white))
                : const Text('COMPLETED',
                    style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}
