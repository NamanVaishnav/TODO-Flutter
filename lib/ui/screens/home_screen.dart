import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_flutter/controllers/todo_controller.dart';
import 'package:todo_flutter/models/task.dart';
import 'package:todo_flutter/services/theme_services.dart';
import 'package:todo_flutter/ui/screens/add_task_screen.dart';
import 'package:todo_flutter/ui/theme.dart';
import 'package:todo_flutter/ui/widgets/task_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _controller = TabController(length: 3, vsync: this);
  List<Widget> tabs = [];
  final TodoController _taskController = Get.put(TodoController());
  DateTime _selectedate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _taskController.getTaskList();
    _controller.addListener(() {
      print(_controller.index);
      _taskController.currentSelectedIndex = _controller.index;
      _taskController.getTaskList();
    });
    tabs = [
      Container(
        child: _tasks(),
      ),
      Container(
        child: _tasks(),
      ),
      Container(
        child: _tasks(),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: _appBar(),
      floatingActionButton: _floatingActionButton(),
      body: Column(children: [
        const SizedBox(height: 20),
        TabBar(
          tabs: const [
            Tab(text: 'Today'),
            Tab(text: 'Tomorrow'),
            Tab(text: 'Upcoming')
          ],
          controller: _controller,
          indicatorSize: TabBarIndicatorSize.label,
        ),
        Expanded(
            child: TabBarView(
          children: tabs,
          controller: _controller,
        ))
      ]),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: primaryClr,
      title: const Text('TODO'),
      leading: IconButton(
        onPressed: () {
          ThemeServices().switchTheme();
        },
        icon: Icon(
          Get.isDarkMode
              ? Icons.wb_sunny_outlined
              : Icons.nightlight_round_outlined,
        ),
        color: Get.isDarkMode ? Colors.white : darkGreyClr,
      ),
    );
  }

  FloatingActionButton _floatingActionButton() {
    return FloatingActionButton(
      backgroundColor: primaryClr,
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
      onPressed: () => Get.to(() => AddTaskScreen(),
          transition: Transition.downToUp,
          duration: const Duration(milliseconds: 500)),
    );
  }

  Widget _tasks() {
    return Expanded(child: Obx(() {
      if (_taskController.taskList.isEmpty) {
        return _noTasksMessage();
      } else {
        return AnimationLimiter(
          child: ListView.builder(
              scrollDirection:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? Axis.vertical
                      : Axis.horizontal,
              itemCount: _taskController.taskList.length,
              itemBuilder: (BuildContext context, int index) {
                Task task = _taskController.taskList[index];
                var date = DateFormat.jm().parse(task.startTime!);
                var myTime = DateFormat('HH:mm').format(date);

                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: Duration(milliseconds: 500 + index * 20),
                  child: SlideAnimation(
                    horizontalOffset: 400.0,
                    child: FadeInAnimation(
                      child: GestureDetector(
                        onTap: () => displayBottomSheet(context, task),
                        child: TaskTile(task: task),
                      ),
                    ),
                  ),
                );
              }),
        );
      }
    }));
  }

  displayBottomSheet(context, Task task) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return _bottomSheet(task);
        });
  }

  Widget _bottomSheet(Task task) {
    return Container(
      margin: EdgeInsets.all(20),
      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.height * 0.2
          : MediaQuery.of(context).size.height * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          task.isCompleted == 0
              ? ElevatedButton(
                  onPressed: () {
                    _taskController.markAsCompleted(task.id);
                    Get.back();
                  },
                  child: Text("Complete Task"))
              : SizedBox(
                  height: 0,
                ),
          ElevatedButton(
              onPressed: () {
                _taskController.deleteTask(task.id);
                Get.back();
              },
              child: Text("Delete Task")),
          ElevatedButton(onPressed: () => Get.back(), child: Text("Cancel"))
        ],
      ),
    );
  }

  Widget _noTasksMessage() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MediaQuery.of(context).orientation == Orientation.portrait
                ? const SizedBox(
                    height: 0,
                  )
                : const SizedBox(
                    height: 50,
                  ),
            SvgPicture.asset(
              'images/task.svg',
              height: 200,
              color: primaryClr.withOpacity(0.5),
              semanticsLabel: 'Tasks',
            ),
            const SizedBox(
              height: 20,
            ),
            Text("There Is No Tasks"),
          ],
        ),
      ),
    );
  }
}
