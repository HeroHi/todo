import 'package:flutter/material.dart';
import 'package:todo_app/utils/extensions/datetime_extension.dart';

class MyDatePicker extends StatefulWidget {
  DateTime selectedDate;

  MyDatePicker({super.key, required this.selectedDate});

  @override
  State<MyDatePicker> createState() => _MyDatePickerState();
}

class _MyDatePickerState extends State<MyDatePicker> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Center(
      child: InkWell(
        onTap: () async {
          await _buildDatePicker();
          setState(() {});
        },
        child: Text(
          widget.selectedDate.formattedDate(),
          style: theme.textTheme.labelMedium,
        ),
      ),
    );
  }

  Future<void> _buildDatePicker() async {
    widget.selectedDate = await (showDatePicker(
            initialDate: widget.selectedDate,
            context: context,
            firstDate: DateTime.now(),
            lastDate: DateTime(2026))) ??
        widget.selectedDate;
  }
}
