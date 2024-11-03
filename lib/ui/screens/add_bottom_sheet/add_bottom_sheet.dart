import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/models/user_model.dart';
import 'package:todo_app/providers/tasks_provider.dart';
import 'package:todo_app/utils/extensions/datetime_extension.dart';
import 'package:todo_app/widgets/my_text_field.dart';

import '../../../utils/app_colors.dart';

class AddBottomSheet extends StatefulWidget {
  const AddBottomSheet({super.key});

  @override
  State<AddBottomSheet> createState() => _AddBottomSheetState();
}

class _AddBottomSheetState extends State<AddBottomSheet> {
  late ThemeData theme;
  late TasksProvider tasksProvider;
  DateTime selectedDate = DateTime.timestamp();
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    tasksProvider = Provider.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: theme.primaryColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.tr("addNewTask"),
            style: theme.textTheme.titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          MyTextField(
              hintText: context.tr("enterYourTitle"),
              controller: titleController),
          MyTextField(
              hintText: context.tr("enterTaskDescription"),
              controller: descriptionController),
          Text(
            context.tr("selectDate"),
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.start,
          ),
          _buildDatePicker(),
          Text(context.tr("selectTime"), style: theme.textTheme.titleMedium),
          _buildTimePicker(),
          ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () {
                addTaskToFirestore();
                tasksProvider.updateTasks();
                Navigator.pop(context);
              },
              child: Text(
                context.tr("add"),
                style: theme.textTheme.titleLarge,
              ))
        ],
      ),
    );
  }

  void addTaskToFirestore() async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection(UserModel.collectionName)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(TaskModel.collectionName)
        .doc();
    TaskModel task = TaskModel(
        id: documentReference.id,
        title: titleController.text,
        description: descriptionController.text,
        date: selectedDate,
        isDone: false);
    await documentReference.set(task.toJson());
  }

  Future<void> _showMyDatePicker() async {
    selectedDate = await (showDatePicker(
            initialDate: DateTime.now(),
            currentDate: selectedDate,
            context: context,
            firstDate: DateTime.now(),
            lastDate: DateTime(2026))) ??
        selectedDate;
  }

  Widget _buildDatePicker() {
    return Center(
      child: InkWell(
        onTap: () async {
          await _showMyDatePicker();
          setState(() {});
        },
        child: Text(
          selectedDate.formattedDate(),
          style: theme.textTheme.labelMedium,
        ),
      ),
    );
  }

  Future<void> _showMyTimePicker() async {
    selectedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(selectedDate)) ??
        selectedTime;
    selectedDate = selectedDate.copyWith(
        hour: selectedTime.hour, minute: selectedTime.minute);
  }

  Widget _buildTimePicker() {
    return Center(
      child: InkWell(
        onTap: () async {
          await _showMyTimePicker();
          setState(() {});
        },
        child: Text(
          selectedTime.toString(),
          style: theme.textTheme.labelMedium,
        ),
      ),
    );
  }
}
