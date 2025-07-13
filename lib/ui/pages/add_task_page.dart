import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/controllers/task_controller.dart';
import 'package:to_do_app/models/task.dart';
import 'package:to_do_app/ui/theme.dart';
import 'package:to_do_app/ui/widgets/button.dart';
import 'package:to_do_app/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime _selectedData = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();
  int _selectedRemaind = 5;
  List<int> remaindList = [5, 10, 15, 20];
  String _selectedRepate = "None";
  List<String> repateList = ['None', 'Daily', 'Weekly', 'Monthly'];

  int selectedColor = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.only(right: 10, left: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Add Task",
                style: headingstyle,
              ),
              InputField(
                title: "Title",
                hint: "Enter yout title",
                controller: _titleController,
              ),
              InputField(
                title: "Note",
                hint: "Enter yout Note",
                controller: _noteController,
              ),
              InputField(
                title: "Date",
                hint: DateFormat.yMd().format(_selectedData),
                widget: IconButton(
                    onPressed: () => _getDateFromUser(),
                    icon: const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey,
                    )),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: "State Time",
                      hint: _startTime,
                      widget: IconButton(
                          onPressed: () => _getTimeFromUser(isStarttime: true),
                          icon: const Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          )),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: InputField(
                      title: "End Time",
                      hint: _endTime,
                      widget: IconButton(
                          onPressed: () => _getTimeFromUser(isStarttime: false),
                          icon: const Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          )),
                    ),
                  ),
                ],
              ),
              InputField(
                  title: "Remind",
                  hint: " $_selectedRemaind minutes early",
                  widget: Row(
                    children: [
                      DropdownButton(
                        dropdownColor: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(10),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedRemaind = int.parse(newValue.toString());
                          });
                        },
                        style: subTitlestyle,
                        items: remaindList
                            .map((value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(
                                    "$value",
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ))
                            .toList(),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                        iconSize: 32,
                        elevation: 4,
                        underline: Container(height: 0),
                      ),
                      const SizedBox(
                        width: 6,
                      )
                    ],
                  )),
              InputField(
                  title: "Repeat",
                  hint: _selectedRepate,
                  widget: Row(
                    children: [
                      DropdownButton(
                        dropdownColor: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(10),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedRepate = newValue.toString();
                          });
                        },
                        style: subTitlestyle,
                        items: repateList
                            .map((value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ))
                            .toList(),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                        iconSize: 32,
                        elevation: 4,
                        underline: Container(height: 0),
                      ),
                      const SizedBox(
                        width: 6,
                      )
                    ],
                  )),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPallete(),
                  MyButton(
                    label: "Create Task",
                    onTap: () {
                      _validateDate();
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 24,
          color: primaryClr,
        ),
      ),
      elevation: 0,
      backgroundColor: context.theme.scaffoldBackgroundColor,
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage("images/person.jpeg"),
          radius: 18,
        ),
        SizedBox(
          width: 20,
        )
      ],
    );
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTasksToDb();
      _taskController.getTasks();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        "Required",
        "message",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: const Icon(
          Icons.warning_amber_outlined,
          color: Colors.red,
        ),
      );
    } else {
      print("########## SOMTHING BAD HAPPENED ############");
    }
  }

  _addTasksToDb() async {
    try {
      int value = await _taskController.addTask(
          task: Task(
              title: _titleController.text,
              note: _noteController.text,
              isCompleted: 0,
              date: DateFormat.yMd().format(_selectedData),
              startTime: _startTime,
              endTime: _endTime,
              color: selectedColor,
              remind: _selectedRemaind,
              repeat: _selectedRepate));
      print("create task :$value");
      setState(() {});
    } catch (e) {
      print("Error");
    }
  }

  Column _colorPallete() {
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Colors",
          style: titlestyle,
        ),
        Wrap(
          children: List.generate(3, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CircleAvatar(
                  child: selectedColor == index
                      ? const Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 16,
                        )
                      : null,
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                          ? pinkClr
                          : orangeClr,
                  radius: 14,
                ),
              ),
            );
          }),
        )
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedData,
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
    );
    if (_pickedDate != null) {
      setState(() {
        _selectedData = _pickedDate;
      });
    }
  }

  _getTimeFromUser({required bool isStarttime}) async {
    TimeOfDay? _pickedTime = await showTimePicker(
      context: context,
      initialTime: isStarttime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(
              DateTime.now().add(const Duration(minutes: 15))),
    );

    String _formatedTime = _pickedTime!.format(context);

    if (isStarttime) {
      setState(() => _startTime = _formatedTime);
    } else if (!isStarttime) {
      setState(() => _endTime = _formatedTime);
    } else {
      print("time cancel or somthing is wrong");
    }
  }
}
