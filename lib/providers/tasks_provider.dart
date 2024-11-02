import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo_app/firebase/firestore_service.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/models/user_model.dart';

class TasksProvider extends ChangeNotifier {
  List<TaskModel> tasks = [];
  DateTime selectedDate = DateTime.now();

  Future<void> updateTasks() async {
    tasks = await FirestoreService.getTasksFromFirestore(selectedDate);
    notifyListeners();
  }

  Future<void> deleteTaskFromFirestore(String taskId) async {
    await FirestoreService.deleteTaskFromFirestore(taskId);
    await updateTasks();
  }

  Future<void> editTaskInFirestore(
      {required String taskId,
      required String title,
      required String description,
      required DateTime date,
      bool isDone = false}) async {
    TaskModel taskAfterEdit = TaskModel(
        id: taskId,
        title: title,
        description: description,
        date: date,
        isDone: isDone);
    await FirebaseFirestore.instance
        .collection(UserModel.collectionName)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(TaskModel.collectionName)
        .doc(taskId)
        .set(taskAfterEdit.toJson());
    await updateTasks();
  }
}
