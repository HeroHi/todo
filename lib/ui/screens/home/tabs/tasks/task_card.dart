import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/providers/tasks_provider.dart';
import 'package:todo_app/ui/screens/task_edit/task_edit.dart';
import 'package:todo_app/utils/app_colors.dart';
import 'package:todo_app/utils/app_text_styles.dart';

class TaskCard extends StatefulWidget {
  late ThemeData theme;
  TaskModel taskModel;

  TaskCard({required this.taskModel, super.key});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  late TasksProvider tasksProvider;

  @override
  Widget build(BuildContext context) {
    tasksProvider = Provider.of(context);
    widget.theme = Theme.of(context);
    Color stateColor =
        widget.taskModel.isDone ? AppColors.doneColor : AppColors.primary;
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
                    arguments: widget.taskModel.id);
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
                tasksProvider.deleteTaskFromFirestore(widget.taskModel.id);
              },
              backgroundColor: AppColors.deleteColor,
              icon: Icons.delete,
              label: "Delete",
              foregroundColor: Colors.white,
              autoClose: true,
            ),
          ]),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: widget.theme.primaryColor),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: stateColor),
                  width: 4,
                  height: 64,
                ),
                const SizedBox(
                  width: 30,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.taskModel.title,
                      style: AppTextStyles.bold.copyWith(color: stateColor),
                    ),
                    Text(
                      widget.taskModel.description,
                      style: widget.theme.textTheme.titleMedium,
                    )
                  ],
                ),
                const Spacer(),
                _buildState(stateColor)
              ],
            ),
          )),
    );
  }

  _buildState(Color stateColor) {
    return widget.taskModel.isDone
        ? Text(
            "Done!",
            style: AppTextStyles.bold.copyWith(color: stateColor),
          )
        : InkWell(
            onTap: () {
              widget.taskModel.isDone = !widget.taskModel.isDone;
              tasksProvider.editTaskInFirestore(
                  taskId: widget.taskModel.id,
                  title: widget.taskModel.title,
                  description: widget.taskModel.description,
                  date: widget.taskModel.date,
                  isDone: true);
              setState(() {});
            },
            child: Container(
              width: 70,
              height: 36,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.primary),
              child: Icon(
                Icons.done,
                color: AppColors.white,
              ),
            ),
          );
  }
}
