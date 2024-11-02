import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/firebase_auth/firebase_auth_manager.dart';
import 'package:todo_app/ui/screens/login/login.dart';
import 'package:todo_app/utils/app_colors.dart';
import 'package:todo_app/utils/app_text_styles.dart';
import 'package:todo_app/widgets/show_toast.dart';

class RegisterScreen extends StatefulWidget {
  static String routeName = "Register";

  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late ThemeData theme;

  TextEditingController userNameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    final GlobalKey<FormState> userNameKey = GlobalKey();
    final GlobalKey<FormState> emailKey = GlobalKey();
    final GlobalKey<FormState> passwordKey = GlobalKey();
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Padding(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 40, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Sign Up",
              style: theme.textTheme.titleLarge!.copyWith(fontSize: 40),
            ),
            Text(
              "Please enter your details",
              style: theme.textTheme.labelMedium,
            ),
            _buildTextField(
                key: userNameKey,
                title: "Name",
                hintText: "username",
                validator: (value) {
                  if (value == null || value.isEmpty) return "Cannot be empty";
                  if (value.length < 4) {
                    return "username should be at least 4 characters";
                  }
                  return null;
                },
                controller: userNameController),
            _buildTextField(
                key: emailKey,
                title: "Email",
                hintText: "Example@gmail.com",
                validator: (value) {
                  if (value == null || value.isEmpty) return "Cannot be empty";
                  return null;
                },
                controller: emailController),
            _buildTextField(
                key: passwordKey,
                title: "Password",
                hintText: "At least 8 characters",
                validator: (value) {
                  if (value == null || value.isEmpty) return "Cannot be empty";
                  if (value.length < 8) {
                    return "Password should be at least 8 characters";
                  }
                  return null;
                },
                controller: passwordController),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () async {
                if (userNameKey.currentState!.validate() &&
                    emailKey.currentState!.validate() &&
                    passwordKey.currentState!.validate()) {
                  await FirebaseAuthManager.register(
                      userName: userNameController.text,
                      email: emailController.text,
                      password: passwordController.text);
                  if (FirebaseAuth.instance.currentUser != null &&
                      context.mounted) {
                    await FirebaseAuthManager.sendEmailVerificationLink();
                    showToast(
                        msg:
                            "A verification link has been sent to your email please check it and verify your email before logging in",
                        color: AppColors.doneColor);
                    Timer timer = Timer.periodic(
                      const Duration(seconds: 5),
                      (timer) {
                        FirebaseAuth.instance.currentUser!.reload();
                        if (FirebaseAuth.instance.currentUser!.emailVerified) {
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.routeName);
                          timer.cancel();
                        }
                      },
                    );
                  }
                }
              },
              child: Text(
                "Sign Up",
                style: AppTextStyles.intermediate.copyWith(
                  color: AppColors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            _buildLoginButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required String title,
      required String hintText,
      required TextEditingController controller,
      required FormFieldValidator<String> validator,
      required Key key}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(
            height: 10,
          ),
          Form(
            key: key,
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: controller,
              validator: validator,
              style: theme.textTheme.titleMedium,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: theme.textTheme.labelMedium,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.7,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: theme.primaryColorDark),
                  borderRadius: BorderRadius.circular(15))),
          onPressed: () {
            Navigator.pushReplacementNamed(context, LoginScreen.routeName);
          },
          child: Text(
            "Login",
            style: theme.textTheme.titleLarge,
          )),
    );
  }
}
