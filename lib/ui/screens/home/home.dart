import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/theme_provider.dart';
import 'package:todo_app/ui/screens/add_bottom_sheet/add_bottom_sheet.dart';
import 'package:todo_app/ui/screens/home/tabs/settings/settings_tab.dart';
import 'package:todo_app/ui/screens/home/tabs/tasks/tasks_tab.dart';
import 'package:todo_app/ui/screens/login/login.dart';
import 'package:todo_app/utils/app_colors.dart';

class Home extends StatefulWidget {
  late ThemeData theme;
  static String routeName = "Home";

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> tabs = [TasksTab(), SettingsTab()];
  int currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    widget.theme = Theme.of(context);
    ThemeProvider themeProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text("ToDo"),
            const SizedBox(
              height: 10,
            ),
            Text(FirebaseAuth.instance.currentUser!.displayName!),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              },
              icon: Icon(
                Icons.logout,
                color: widget.theme.primaryColor,
              ))
        ],
      ),
      body: tabs[currentTabIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: BottomAppBar(
          color: widget.theme.primaryColor,
          padding: const EdgeInsets.all(0),
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          height: 80,
          child: BottomNavigationBar(
              onTap: (value) {
                currentTabIndex = value;
                setState(() {});
              },
              elevation: 0,
              iconSize: 35,
              currentIndex: currentTabIndex,
              backgroundColor: AppColors.transparent,
              unselectedItemColor: themeProvider.bottomNavBarIconColor,
              selectedItemColor: AppColors.primary,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.list,
                    ),
                    label: ""),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.settings,
                    ),
                    label: "")
              ])),
    );
  }

  _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return AddBottomSheet();
          },
        );
      },
      child: Icon(
        Icons.add,
        color: AppColors.white,
      ),
    );
  }
}
