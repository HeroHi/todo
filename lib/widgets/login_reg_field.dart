import 'package:flutter/material.dart';

class LoginRegField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassField;
  final FormFieldValidator<String> validator;
  final Key formKey;
  final Icon prefixIcon;
  bool isHidden = false;

  LoginRegField(
      {super.key,
      required this.prefixIcon,
      required this.formKey,
      required this.controller,
      this.isPassField = false,
      required this.validator,
      required this.hintText});

  @override
  State<LoginRegField> createState() => _LoginRegFieldState();
}

class _LoginRegFieldState extends State<LoginRegField> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Form(
      key: widget.formKey,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: widget.controller,
        validator: widget.validator,
        style: theme.textTheme.titleMedium,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: theme.textTheme.labelMedium,
          prefixIcon: widget.prefixIcon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          suffixIcon: widget.isPassField
              ? IconButton(
                  onPressed: () {
                    widget.isHidden = !widget.isHidden;
                    setState(() {});
                  },
                  icon: Icon(
                    widget.isHidden
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: theme.primaryColorDark,
                  ))
              : const SizedBox.shrink(),
        ),
        obscureText: widget.isHidden,
      ),
    );
  }
}
