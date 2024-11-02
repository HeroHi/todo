import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/providers/tasks_provider.dart';
import 'package:todo_app/ui/screens/home/tabs/tasks/task_card.dart';
import 'package:todo_app/utils/app_text_styles.dart';
import 'package:todo_app/widgets/my_date_picker.dart';
import 'package:todo_app/widgets/my_text_field.dart';
import 'package:todo_app/widgets/show_toast.dart';

import '../../../utils/app_colors.dart';

class TaskEdit extends StatelessWidget {
  late ThemeData theme;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  late TasksProvider tasksProvider;
  static String routeName = "taskEdit";

  TaskEdit({super.key});

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    tasksProvider = Provider.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("To Do List"),
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
    TaskModel taskModel =
        ModalRoute.of(context)!.settings.arguments as TaskModel;
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
            "Edit Task",
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          Hero(
              tag: taskModel.id,
              child: Material(
                  type: MaterialType.transparency,
                  child: TaskCard(taskModel: taskModel))),
          MyTextField(hintText: "Title", controller: titleController),
          MyTextField(
              hintText: "Description", controller: descriptionController),
          Text(
            "Select Time",
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.start,
          ),
          MyDatePicker(selectedDate: selectedDate),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              onPressed: () async {
                await tasksProvider.editTaskInFirestore(
                    taskId: taskModel.id,
                    title: titleController.text,
                    description: descriptionController.text,
                    date: selectedDate);
                showToast(
                    msg: "Task edited successfully",
                    color: AppColors.doneColor);
              },
              child: Text(
                "Save Changes",
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
}
