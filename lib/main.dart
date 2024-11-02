import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/tasks_provider.dart';
import 'package:todo_app/providers/theme_provider.dart';
import 'package:todo_app/ui/screens/home/home.dart';
import 'package:todo_app/ui/screens/login/login.dart';
import 'package:todo_app/ui/screens/register/register.dart';
import 'package:todo_app/ui/screens/task_edit/task_edit.dart';
import 'package:todo_app/utils/app_themes.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
      create: (context) => ThemeProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of(context);
    return ChangeNotifierProvider(
      create: (context) => TasksProvider(),
      child: MaterialApp(
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        themeMode: themeProvider.themeMode,
        routes: {
          Home.routeName: (_) => Home(),
          LoginScreen.routeName: (_) => LoginScreen(),
          RegisterScreen.routeName: (_) => RegisterScreen(),
          TaskEdit.routeName: (_) => TaskEdit(),
        },
        initialRoute: LoginScreen.routeName,
      ),
    );
  }
}
