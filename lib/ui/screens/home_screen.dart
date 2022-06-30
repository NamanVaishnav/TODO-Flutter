import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_flutter/services/theme_services.dart';
import 'package:todo_flutter/ui/screens/add_todo_screen.dart';
import 'package:todo_flutter/ui/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: primaryClr,
        title: const Text('TODO'),
        actions: [
          IconButton(
            onPressed: () {
              ThemeServices().switchTheme();
            },
            icon: Icon(
              Get.isDarkMode
                  ? Icons.wb_sunny_outlined
                  : Icons.nightlight_round_outlined,
            ),
            color: Get.isDarkMode ? Colors.white : darkGreyClr,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryClr,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () => Get.to(() => AddTodoScreen(),
            transition: Transition.downToUp,
            duration: const Duration(milliseconds: 500)),
      ),
      body: Container(),
    );
  }
}
