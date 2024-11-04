import 'package:flutter/material.dart';

void showLoading(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );
}

void hideLoading(BuildContext context) {
  Navigator.pop(context);
}
