import 'package:easy_localization/easy_localization.dart';
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
    ThemeData theme = Theme.of(context);
    bool isArabic = (context.locale.languageCode == "ar");
    return Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppColors.transparent),
        height: MediaQuery.sizeOf(context).height * 0.132,
        child: Slidable(
          closeOnScroll: true,
          startActionPane:
              isArabic ? null : _buildActionPane(tasksProvider, context, theme),
          endActionPane: isArabic
              ? _buildArabicActionPane(tasksProvider, context, theme)
              : null,
          child: child,
        ));
  }

  ActionPane _buildActionPane(
      TasksProvider tasksProvider, BuildContext context, ThemeData theme) {
    return ActionPane(motion: const BehindMotion(), children: [
      SlidableAction(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
        onPressed: (_) async {
          tasksProvider.deleteTaskFromFirestore(taskModel.id);
        },
        backgroundColor: AppColors.deleteColor,
        icon: Icons.delete,
        label: context.tr("delete"),
        foregroundColor: Colors.white,
        autoClose: true,
      ),
      SlidableAction(
        onPressed: (context) {
          Navigator.pushNamed(context, TaskEdit.routeName,
              arguments: taskModel);
        },
        borderRadius: BorderRadius.circular(15),
        backgroundColor: Colors.transparent,
        foregroundColor: theme.primaryColorDark,
        label: context.tr("edit"),
        icon: Icons.edit,
      ),
    ]);
  }

  ActionPane _buildArabicActionPane(
      TasksProvider tasksProvider, BuildContext context, ThemeData theme) {
    return ActionPane(motion: const BehindMotion(), children: [
      SlidableAction(
        onPressed: (context) {
          Navigator.pushNamed(context, TaskEdit.routeName,
              arguments: taskModel);
        },
        borderRadius: BorderRadius.circular(15),
        backgroundColor: Colors.transparent,
        foregroundColor: theme.primaryColorDark,
        label: context.tr("edit"),
        icon: Icons.edit,
      ),
      SlidableAction(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
        onPressed: (_) async {
          tasksProvider.deleteTaskFromFirestore(taskModel.id);
        },
        backgroundColor: AppColors.deleteColor,
        icon: Icons.delete,
        label: context.tr("delete"),
        foregroundColor: Colors.white,
        autoClose: true,
      ),
    ]);
  }
}
