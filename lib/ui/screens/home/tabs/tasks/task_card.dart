import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/providers/tasks_provider.dart';
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: widget.theme.primaryColor),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: stateColor),
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
              ),
              Text(
                "${widget.taskModel.date.hour}:${widget.taskModel.date.minute}",
                style:
                    widget.theme.textTheme.labelMedium!.copyWith(fontSize: 15),
              )
            ],
          ),
          const Spacer(),
          _buildState(stateColor)
        ],
      ),
    );
  }

  _buildState(Color stateColor) {
    return InkWell(
      onTap: () {
        widget.taskModel.isDone = !widget.taskModel.isDone;
        tasksProvider.editTaskInFirestore(
            taskId: widget.taskModel.id,
            title: widget.taskModel.title,
            description: widget.taskModel.description,
            date: widget.taskModel.date,
            isDone: widget.taskModel.isDone);
        setState(() {});
      },
      child: widget.taskModel.isDone
          ? Text(
              context.tr("done"),
              style: AppTextStyles.bold.copyWith(color: stateColor),
            )
          : Container(
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
