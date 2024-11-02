import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/models/user_model.dart';
import 'package:todo_app/utils/extensions/datetime_extension.dart';

class TasksProvider extends ChangeNotifier {
  List<TaskModel> tasks = [];
  DateTime selectedDate = DateTime.now();

  Future<void> getTasksFromFirestore() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(UserModel.collectionName)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(TaskModel.collectionName)
        .orderBy("date")
        .get();
    tasks = querySnapshot.docs.map(
      (docSnapshot) {
        Map<String, dynamic> json = docSnapshot.data() as Map<String, dynamic>;
        return TaskModel.fromJson(json);
      },
    ).toList();
    tasks = tasks.where(
      (element) {
        return element.date.compareDate(selectedDate);
      },
    ).toList();
    notifyListeners();
  }

  Future<void> deleteTaskFromFirestore(String taskId) async {
    await FirebaseFirestore.instance
        .collection(UserModel.collectionName)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(TaskModel.collectionName)
        .doc(taskId)
        .delete();
    await getTasksFromFirestore();
    notifyListeners();
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
    await getTasksFromFirestore();
    notifyListeners();
  }
}
