import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/tasks_provider.dart';

import '../../../../../models/task_model.dart';
import '../../../../../utils/app_colors.dart';
import '../../../task_edit/task_edit.dart';

class MySlider extends StatelessWidget {
  final Widget child;
  final TaskModel taskModel;

  const MySlider({super.key, required this.child, required this.taskModel});

  @override
  Widget build(BuildContext context) {
    TasksProvider tasksProvider = Provider.of(context);
    return Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppColors.deleteColor),
        height: MediaQuery.sizeOf(context).height * 0.132,
        child: Slidable(
          closeOnScroll: true,
          startActionPane: ActionPane(motion: const BehindMotion(), children: [
            SlidableAction(
              onPressed: (context) {
                Navigator.pushNamed(context, TaskEdit.routeName,
                    arguments: taskModel);
              },
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15)),
              backgroundColor: Colors.blueGrey,
              foregroundColor: AppColors.black,
              label: "Edit",
              icon: Icons.edit,
            ),
            SlidableAction(
              borderRadius: BorderRadius.circular(15),
              onPressed: (_) async {
                tasksProvider.deleteTaskFromFirestore(taskModel.id);
              },
              backgroundColor: AppColors.deleteColor,
              icon: Icons.delete,
              label: "Delete",
              foregroundColor: Colors.white,
              autoClose: true,
            ),
          ]),
          child: child,
        ));
  }
}
