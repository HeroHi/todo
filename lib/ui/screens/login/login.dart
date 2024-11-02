import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/ui/screens/home/home.dart';
import 'package:todo_app/ui/screens/register/register.dart';
import 'package:todo_app/utils/app_colors.dart';
import 'package:todo_app/widgets/show_toast.dart';

import '../../../firebase_auth/firebase_auth_manager.dart';

class LoginScreen extends StatelessWidget {
  late ThemeData theme;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  static String routeName = "Login";

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Hello Again!",
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(
              height: 20,
            ),
            _buildTextFormField(
                controller: emailController,
                hintText: "Email",
                prefixIcon: Icons.email),
            const SizedBox(
              height: 30,
            ),
            _buildTextFormField(
                controller: passwordController,
                hintText: "Password",
                prefixIcon: Icons.password),
            _buildLoginButton(context),
            _buildRegisterButton(context),
          ],
        ),
      ),
    );
  }

  Container _buildLoginButton(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.7,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          onPressed: () async {
            await FirebaseAuthManager.login(
                email: emailController.text, password: passwordController.text);
            if (FirebaseAuth.instance.currentUser != null && context.mounted) {
              if (!FirebaseAuth.instance.currentUser!.emailVerified) {
                showToast(
                    msg: "please verify your email before logging in",
                    color: AppColors.deleteColor);
                Timer.periodic(
                  const Duration(seconds: 5),
                  (timer) {
                    FirebaseAuth.instance.currentUser!.reload();
                    if (FirebaseAuth.instance.currentUser!.emailVerified) {
                      Navigator.pushReplacementNamed(context, Home.routeName);
                      timer.cancel();
                    }
                  },
                );
              } else {
                Navigator.pushReplacementNamed(context, Home.routeName);
              }
            }
          },
          child: Text(
            "Login",
            style: theme.textTheme.titleLarge,
          )),
    );
  }

  TextFormField _buildTextFormField(
      {required TextEditingController controller,
      required String hintText,
      required IconData prefixIcon}) {
    return TextFormField(
      controller: controller,
      style: theme.textTheme.titleMedium,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        labelText: hintText,
        labelStyle: theme.textTheme.labelMedium,
        floatingLabelStyle: theme.textTheme.labelMedium,
        floatingLabelAlignment: FloatingLabelAlignment.start,
        prefixIcon: Icon(
          prefixIcon,
          color: theme.primaryColorDark,
        ),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.7,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: AppColors.black),
                  borderRadius: BorderRadius.circular(15))),
          onPressed: () {
            Navigator.pushReplacementNamed(context, RegisterScreen.routeName);
          },
          child: Text(
            "Sign Up",
            style: theme.textTheme.titleLarge,
          )),
    );
  }
}
