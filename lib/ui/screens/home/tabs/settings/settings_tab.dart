import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/theme_provider.dart';

import '../../../../../utils/app_colors.dart';

class SettingsTab extends StatelessWidget {
  late ThemeData theme;
  late ThemeProvider themeProvider;

  SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    themeProvider = Provider.of(context);
    return Column(
      children: [
        Container(
          color: AppColors.primary,
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height * 0.116,
        ),
        Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Language",
                textAlign: TextAlign.start,
                style: theme.textTheme.titleLarge,
              ),
              _buildDropDownMenu(context, value: "en", items: [
                DropdownMenuItem(
                  child: Text("Arabic"),
                  value: "ar",
                ),
                DropdownMenuItem(
                  child: Text("English"),
                  value: "en",
                )
              ]),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    "Mode",
                    textAlign: TextAlign.start,
                    style: theme.textTheme.titleLarge,
                  ),
                  const Spacer(),
                  _buildThemeSwitch()
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildDropDownMenu(BuildContext context,
      {required List<DropdownMenuItem<dynamic>> items,
      required dynamic value}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: theme.primaryColor,
        border: Border.all(color: AppColors.primary),
      ),
      width: MediaQuery.sizeOf(context).width,
      child: DropdownButton(
        isExpanded: true,
        elevation: 0,
        padding: EdgeInsets.only(left: 12),
        underline: const SizedBox.shrink(),
        value: value,
        items: items,
        onChanged: (value) {},
      ),
    );
  }

  Widget _buildThemeSwitch() => Switch(
      value: themeProvider.isDark,
      inactiveTrackColor: AppColors.transparent,
      activeColor: AppColors.primary,
      onChanged: (newValue) {
        themeProvider.toggleTheme();
      });
}
