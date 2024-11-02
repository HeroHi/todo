import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const MyTextField(
      {super.key, required this.hintText, required this.controller});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        hintText: hintText,
        hintStyle: theme.textTheme.labelMedium,
        contentPadding: const EdgeInsets.all(10),
      ),
    );
  }
}
