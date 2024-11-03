import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/tasks_provider.dart';
import 'package:todo_app/ui/screens/home/tabs/tasks/task_card.dart';

import '../../../../../utils/app_colors.dart';
import 'my_slider.dart';

class TasksTab extends StatefulWidget {
  late ThemeData theme;

  TasksTab({super.key});

  @override
  State<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  late TasksProvider tasksProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      tasksProvider.updateTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    tasksProvider = Provider.of(context);
    widget.theme = Theme.of(context);
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildTimeLineBg(),
              _buildTimeLine(),
            ],
          ),
        ),
        Expanded(
          flex: 7,
          child: ListView.builder(
            itemCount: tasksProvider.tasks.length,
            itemBuilder: (context, index) => MySlider(
              taskModel: tasksProvider.tasks[index],
              child: Hero(
                tag: tasksProvider.tasks[index].id,
                child: Material(
                  type: MaterialType.transparency,
                  child: TaskCard(
                    taskModel: tasksProvider.tasks[index],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildTimeLineBg() {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: AppColors.primary,
            width: MediaQuery.sizeOf(context).width,
          ),
        ),
        Expanded(
          child: Container(
              color: widget.theme.primaryColorLight,
              width: MediaQuery.sizeOf(context).width),
        ),
      ],
    );
  }

  Widget _buildTimeLine() {
    TextStyle timeLineStyle =
        widget.theme.textTheme.titleLarge!.copyWith(fontSize: 15);
    return EasyDateTimeLine(
        locale: context.locale.languageCode,
        headerProps: const EasyHeaderProps(showHeader: false),
        initialDate: DateTime.now(),
        activeColor: AppColors.primary,
        onDateChange: (selectedDate) {
          tasksProvider.selectedDate = selectedDate;
          tasksProvider.updateTasks();
        },
        dayProps: EasyDayProps(
            todayHighlightStyle: TodayHighlightStyle.withBackground,
            todayHighlightColor: widget.theme.primaryColor,
            todayStyle: DayStyle(
              dayStrStyle: timeLineStyle,
              dayNumStyle: timeLineStyle,
              monthStrStyle: timeLineStyle,
              decoration: BoxDecoration(
                color: widget.theme.primaryColor,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            inactiveDayStyle: DayStyle(
                dayStrStyle: timeLineStyle,
                dayNumStyle: timeLineStyle,
                monthStrStyle: timeLineStyle,
                decoration: BoxDecoration(
                  color: widget.theme.primaryColor,
                  borderRadius: BorderRadius.circular(14),
                ))));
  }
}
