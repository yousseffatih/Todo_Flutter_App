import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/models/task.dart';
import 'package:to_do_app/services/notification_services.dart';
import 'package:to_do_app/services/theme_services.dart';
import 'package:to_do_app/ui/pages/add_task_page.dart';
import 'package:to_do_app/ui/size_config.dart';
import 'package:to_do_app/ui/theme.dart';
import 'package:to_do_app/ui/widgets/button.dart';
import 'package:to_do_app/ui/widgets/task_tile.dart';

import '../../controllers/task_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NotifyHelper notifyHelper;
  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.requestIOSPermissions();
    notifyHelper.initializeNotification();
    _taskController.getTasks();
  }

  final TaskController _taskController = Get.put(TaskController());
  DateTime _selecteddate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              ThemeServices().switchTheme();
              // notifyHelper.displayNotification(title: "Theme Changed", body: "Good For Choising this theme",);
              // notifyHelper.scheduledNotification();
            },
            icon: Icon(
              Get.isDarkMode
                  ? Icons.wb_sunny_outlined
                  : Icons.nightlight_round_outlined,
              size: 24,
              color: Get.isDarkMode ? Colors.white : darkGreyClr,
            ),
          ),
          elevation: 0,
          backgroundColor: context.theme.scaffoldBackgroundColor,
          actions: [
            IconButton(
                onPressed: () {
                  _taskController.deleteAllTasks();
                  notifyHelper.cancelAllNotification();
                },
                icon: Icon(
                  Icons.cleaning_services_outlined,
                  size: 24,
                  color: Get.isDarkMode ? Colors.white : darkGreyClr,
                )),
            const CircleAvatar(
              backgroundImage: AssetImage("images/person.jpeg"),
              radius: 18,
            ),
            const SizedBox(
              width: 20,
            )
          ],
        ),
        body: Column(
          children: [
            _add_Taskbar(),
            _add_Datebar(),
            const SizedBox(
              height: 6,
            ),
            _show_Task(),
          ],
        ));
  }

  _add_Taskbar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingstyle,
              ),
              Text(
                "Today",
                style: headingstyle,
              )
            ],
          ),
          MyButton(
              label: "+ Add Task",
              onTap: () {
                Get.to(() => const AddTaskPage());
                _taskController.getTasks();
              })
        ],
      ),
    );
  }

  _add_Datebar() {
    return Container(
      margin: const EdgeInsets.only(top: 6, left: 20),
      child: DatePicker(
        DateTime.now(),
        initialSelectedDate: _selecteddate,
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        width: 80,
        height: 100,
        dayTextStyle: dayTextstyle,
        dateTextStyle: dateTextstyle,
        monthTextStyle: monthTextstyle,
        onDateChange: (newDate) {
          setState(() {
            _selecteddate = newDate;
          });
        },
      ),
    );
  }

  Future<void> _onRefreshIndicator() async {
    await _taskController.getTasks();
  }

  _show_Task() {
    return Expanded(
      child: Obx(() {
        if (_taskController.tasklist.isEmpty) {
          return _noTaskMsg();
        } else {
          return RefreshIndicator(
            onRefresh: _onRefreshIndicator,
            child: ListView.builder(
              scrollDirection: SizeConfig.orientation == Orientation.landscape
                  ? Axis.horizontal
                  : Axis.vertical,
              itemBuilder: (context, index) {
                Task task = _taskController.tasklist[index];

                if (task.repeat == "Daily" ||
                    task.date == DateFormat.yMd().format(_selecteddate) ||
                    (task.repeat == "Weekly" &&
                        _selecteddate
                                    .difference(
                                        DateFormat.yMd().parse(task.date!))
                                    .inDays %
                                7 ==
                            0) ||
                    (task.repeat == "Monthly" &&
                        DateFormat.yMd().parse(task.date!).day ==
                            _selecteddate.day)) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 1375),
                    child: SlideAnimation(
                      horizontalOffset: 300,
                      child: FadeInAnimation(
                        child: GestureDetector(
                          onTap: () {
                            _showBottomSheet(context, task);
                          },
                          child: TaskTile(task: task),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }

                var hour = task.startTime.toString().split(":")[0];
                var minute = task.startTime.toString().split(":")[1];

                var date = DateFormat.jm().parse(task.startTime!);
                var myTime = DateFormat("HH:mm").format(date);

                notifyHelper.scheduledNotification(
                    int.parse(myTime.toString().split(":")[0]),
                    int.parse(myTime.toString().split(":")[1]),
                    task);
              },
              itemCount: _taskController.tasklist.length,
            ),
          );
        }
      }),
    );
  }

  _noTaskMsg() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 2000),
          child: RefreshIndicator(
            onRefresh: _onRefreshIndicator,
            child: SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                children: [
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(
                          height: 6,
                        )
                      : const SizedBox(
                          height: 230,
                        ),
                  SvgPicture.asset(
                    "images/task.svg",
                    color: primaryClr.withOpacity(0.5),
                    height: 100,
                    semanticsLabel: "Task",
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: Text(
                      "you do not have any tasks yet !\nAdd new tasks to make your productive",
                      style: subTitlestyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(
                          height: 160,
                        )
                      : const SizedBox(
                          height: 160,
                        ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    return Get.bottomSheet(SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 4),
        width: SizeConfig.screenWidth,
        height: (SizeConfig.orientation == Orientation.landscape)
            ? (task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.6
                : SizeConfig.screenHeight * 0.8)
            : (task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.30
                : SizeConfig.screenHeight * 0.39),
        color: Get.isDarkMode ? darkHeaderClr : Colors.white,
        child: Column(
          children: [
            Flexible(
              child: Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:
                        Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            task.isCompleted == 1
                ? Container()
                : _buildbottemSheet(
                    label: "Task Completed",
                    onTap: () {
                      notifyHelper.cancelNotification(task);
                      _taskController.markTaskCompleted(task.id!);
                      Get.back();
                    },
                    clr: primaryClr),
            _buildbottemSheet(
                label: "Delete Completed",
                onTap: () {
                  notifyHelper.cancelNotification(task);
                  _taskController.deleteTasks(task);
                  Get.back();
                },
                clr: Colors.red),
            Divider(
              color: Get.isDarkMode ? Colors.grey : darkGreyClr,
            ),
            _buildbottemSheet(
                label: "Cancel Completed",
                onTap: () {
                  Get.back();
                },
                clr: primaryClr),
            const SizedBox(
              height: 0,
            )
          ],
        ),
      ),
    ));
  }

  _buildbottemSheet(
      {required String label,
      required Function() onTap,
      required Color clr,
      bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        width: SizeConfig.screenWidth * 0.9,
        height: 65,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style:
                isClose ? titlestyle : titlestyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
