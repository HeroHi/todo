import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/ui/screens/home/home.dart';
import 'package:todo_app/ui/screens/register/register.dart';
import 'package:todo_app/utils/app_colors.dart';
import 'package:todo_app/widgets/login_reg_field.dart';
import 'package:todo_app/widgets/show_toast.dart';

import '../../../firebase/auth/firebase_auth_manager.dart';

class LoginScreen extends StatelessWidget {
  late ThemeData theme;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> emailKey = GlobalKey();
  final GlobalKey<FormState> passwordKey = GlobalKey();
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
              context.tr("helloAgain"),
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(
              height: 20,
            ),
            LoginRegField(
                formKey: emailKey,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return context.tr("required");
                  return null;
                },
                controller: emailController,
                hintText: context.tr("email"),
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: theme.primaryColorDark,
                )),
            const SizedBox(
              height: 30,
            ),
            LoginRegField(
                formKey: passwordKey,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return context.tr("required");
                  return null;
                },
                isPassField: true,
                controller: passwordController,
                hintText: context.tr("password"),
                prefixIcon: Icon(
                  Icons.password,
                  color: theme.primaryColorDark,
                )),
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
            if (passwordKey.currentState!.validate() &&
                emailKey.currentState!.validate()) {
              await FirebaseAuthManager.login(
                  email: emailController.text,
                  password: passwordController.text);
              if (FirebaseAuth.instance.currentUser != null &&
                  context.mounted) {
                if (!FirebaseAuth.instance.currentUser!.emailVerified) {
                  showToast(
                      msg: context.tr("plsVerifyEmail"),
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
            }
          },
          child: Text(
            context.tr("login"),
            style: theme.textTheme.titleLarge,
          )),
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
            context.tr("signUp"),
            style: theme.textTheme.titleLarge,
          )),
    );
  }
}
