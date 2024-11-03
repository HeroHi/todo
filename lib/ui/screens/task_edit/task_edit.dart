import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/providers/tasks_provider.dart';
import 'package:todo_app/ui/screens/home/tabs/tasks/task_card.dart';
import 'package:todo_app/utils/app_text_styles.dart';
import 'package:todo_app/utils/extensions/datetime_extension.dart';
import 'package:todo_app/widgets/my_text_field.dart';
import 'package:todo_app/widgets/show_toast.dart';

import '../../../utils/app_colors.dart';

class TaskEdit extends StatefulWidget {
  static String routeName = "taskEdit";

  const TaskEdit({super.key});

  @override
  State<TaskEdit> createState() => _TaskEditState();
}

class _TaskEditState extends State<TaskEdit> {
  late ThemeData theme;

  TextEditingController titleController = TextEditingController();
  TimeOfDay time = TimeOfDay.now();
  TextEditingController descriptionController = TextEditingController();
  late TaskModel taskModel;
  late TasksProvider tasksProvider;

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    tasksProvider = Provider.of(context);
    taskModel = ModalRoute.of(context)!.settings.arguments as TaskModel;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(context.tr("toDo")),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                _buildStackBg(context),
                _buildEditBox(context),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container _buildEditBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 55),
      width: MediaQuery.sizeOf(context).width * 0.883,
      height: MediaQuery.sizeOf(context).height * 0.709,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: theme.primaryColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.tr("editTask"),
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          Hero(
              tag: taskModel.id,
              child: Material(
                  type: MaterialType.transparency,
                  child: TaskCard(taskModel: taskModel))),
          MyTextField(
              hintText: context.tr("title"), controller: titleController),
          MyTextField(
              hintText: context.tr("description"),
              controller: descriptionController),
          Text(
            context.tr("selectTime"),
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.start,
          ),
          _buildTimePicker(),
          Text(
            context.tr("selectDate"),
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.start,
          ),
          _buildDatePicker(),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              onPressed: () async {
                await tasksProvider.editTaskInFirestore(
                    taskId: taskModel.id,
                    title: titleController.text,
                    description: descriptionController.text,
                    date: taskModel.date,
                    isDone: taskModel.isDone);
                taskModel.title = titleController.text;
                taskModel.description = descriptionController.text;
                showToast(
                    msg: context.tr("taskEditSuccess"),
                    color: AppColors.doneColor);
                setState(() {});
              },
              child: Text(
                context.tr("saveChanges"),
                style: AppTextStyles.intermediate
                    .copyWith(fontSize: 18, color: AppColors.white),
              ))
        ],
      ),
    );
  }

  Widget _buildStackBg(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColors.primary,
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height * 0.116,
        ),
        Expanded(
          child: Container(
              color: theme.primaryColorLight,
              width: MediaQuery.sizeOf(context).width),
        ),
      ],
    );
  }

  Future<void> _showMyDatePicker() async {
    taskModel.date = await (showDatePicker(
            initialDate: taskModel.date,
            currentDate: taskModel.date,
            context: context,
            firstDate: DateTime.now(),
            lastDate: DateTime(2026))) ??
        taskModel.date;
  }

  Widget _buildDatePicker() {
    return Center(
      child: InkWell(
        onTap: () async {
          await _showMyDatePicker();
          setState(() {});
        },
        child: Text(
          taskModel.date.formattedDate(),
          style: theme.textTheme.labelMedium,
        ),
      ),
    );
  }

  Future<void> _showMyTimePicker() async {
    time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(taskModel.date)) ??
        time;
    taskModel.date =
        taskModel.date.copyWith(hour: time.hour, minute: time.minute);
  }

  Widget _buildTimePicker() {
    return Center(
      child: InkWell(
        onTap: () async {
          await _showMyTimePicker();
        },
        child: Text(
          time.toString(),
          style: theme.textTheme.labelMedium,
        ),
      ),
    );
  }
}