import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_flutter/controllers/todo_controller.dart';
import 'package:intl/intl.dart';
import 'package:todo_flutter/models/task.dart';
import 'package:todo_flutter/services/theme_services.dart';
import 'package:todo_flutter/ui/theme.dart';
import 'package:todo_flutter/ui/widgets/button_widget.dart';
import 'package:todo_flutter/ui/widgets/input_field.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task;
  const AddTaskScreen({Key? key, this.task}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TodoController _taskController = Get.find();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  String _selectedDate = DateFormat.yMd().format(DateTime.now());
  String _startDate = DateFormat('hh:mm a').format(DateTime.now());
  String _endDate = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)));
  final int _selectedColor = 0;

  @override
  void initState() {
    super.initState();
    bool update = (widget.task != null) ? true : false;
    if (update) {
      if (widget.task != null) {
        _titleController.text = widget.task?.title ?? "";
        _descriptionController.text = widget.task?.note ?? "";
        _selectedDate =
            widget.task?.date ?? DateFormat.yMd().format(DateTime.now());
        _startDate = widget.task?.startTime ??
            DateFormat('hh:mm a').format(DateTime.now());
        _endDate = widget.task?.endTime ??
            DateFormat('hh:mm a')
                .format(DateTime.now().add(const Duration(minutes: 15)));
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool update = (widget.task != null) ? true : false;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: primaryClr,
        title: Text(update ? 'Update Task' : 'Add Task'),
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
        actions: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.cancel),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 15, left: 20, right: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  InputField(
                    isEnabled: true,
                    hint: 'Enter title',
                    label: 'Title',
                    iconOrdrop: 'icon',
                    controller: _titleController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InputField(
                    isEnabled: true,
                    hint: 'Enter description',
                    label: 'Description',
                    iconOrdrop: 'icon',
                    controller: _descriptionController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InputField(
                    onTap: () {
                      _selectDate(context);
                    },
                    controller: _dateController,
                    isEnabled: false,
                    hint: _selectedDate.toString(),
                    label: 'Date',
                    iconOrdrop: 'button',
                    widget: IconButton(
                      icon: const Icon(
                        Icons.date_range,
                        color: primaryClr,
                      ),
                      onPressed: () {
                        _selectDate(context);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: 165,
                          child: InputField(
                            onTap: () {
                              _selectStartTime(context);
                            },
                            isEnabled: false,
                            controller: _startTimeController,
                            label: 'Start Time',
                            iconOrdrop: 'button',
                            hint: _startDate.toString(),
                            widget: IconButton(
                              icon: const Icon(
                                Icons.access_time,
                                color: primaryClr,
                              ),
                              onPressed: () {
                                _selectStartTime(context);
                              },
                            ),
                          )),
                      SizedBox(
                          width: 165,
                          child: InputField(
                            onTap: () {
                              _selectEndTime(context);
                            },
                            controller: _endTimeController,
                            isEnabled: false,
                            iconOrdrop: 'button',
                            label: 'End Time',
                            hint: _endDate.toString(),
                            widget: IconButton(
                              icon: const Icon(Icons.access_time,
                                  color: primaryClr),
                              onPressed: () {
                                _selectEndTime(context);
                              },
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //_colorPallete(),
                      ButtonWidget(
                          label: update ? 'Update Task' : 'Add Task',
                          onTap: () async {
                            _submitDate();
                            _submitStartTime();
                            _submitEndTime();
                            if (_formKey.currentState!.validate()) {
                              final Task task = Task();
                              if (update) {
                                _addTaskToDB(widget.task!);
                                await _taskController.updateTask(widget.task!);
                              } else {
                                _addTaskToDB(task);
                                await _taskController.addTask(task);
                              }

                              Get.back();
                            }
                          },
                          color: primaryClr)
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _addTaskToDB(Task task) {
    task.isCompleted = 0;
    task.color = -_selectedColor;
    task.title = _titleController.text;
    task.note = _descriptionController.text;
    task.date = _selectedDate.toString();
    task.startTime = _startDate;
    task.endTime = _endDate;
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      currentDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    setState(() {
      if (selected != null) {
        _selectedDate = DateFormat.yMd().format(selected).toString();
      } else {
        _selectedDate = DateFormat.yMd().format(DateTime.now()).toString();
      }
    });
  }

  _submitDate() {
    _dateController.text = _selectedDate;
  }

  _selectStartTime(BuildContext context) async {
    final TimeOfDay? selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    String formattedTime = selected!.format(context);
    setState(() {
      _startDate = formattedTime;
    });
  }

  _submitStartTime() {
    _startTimeController.text = _startDate;
  }

  _selectEndTime(BuildContext context) async {
    final TimeOfDay? selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    String formattedTime = selected!.format(context);
    setState(() {
      _endDate = formattedTime;
    });
  }

  _submitEndTime() {
    _endTimeController.text = _endDate;
  }
}
