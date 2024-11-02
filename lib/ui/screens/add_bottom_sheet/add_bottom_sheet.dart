import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/models/user_model.dart';
import 'package:todo_app/providers/tasks_provider.dart';
import 'package:todo_app/widgets/my_date_picker.dart';
import 'package:todo_app/widgets/my_text_field.dart';

import '../../../utils/app_colors.dart';

class AddBottomSheet extends StatefulWidget {
  AddBottomSheet({super.key});

  @override
  State<AddBottomSheet> createState() => _AddBottomSheetState();
}

class _AddBottomSheetState extends State<AddBottomSheet> {
  late ThemeData theme;
  late TasksProvider tasksProvider;
  DateTime selectedDate = DateTime.now();
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
        children: [
          Text(
            "Add New Task",
            style: theme.textTheme.titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: MyTextField(
                hintText: "enter your title", controller: titleController),
          ),
          MyTextField(
              hintText: "enter task description",
              controller: descriptionController),
          const SizedBox(
            height: 80,
          ),
          MyDatePicker(selectedDate: selectedDate),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () {
                addTaskToFirestore();
                tasksProvider.updateTasks();
                Navigator.pop(context);
              },
              child: Text(
                "Add",
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
}
