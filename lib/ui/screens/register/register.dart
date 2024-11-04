import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/ui/screens/login/login.dart';
import 'package:todo_app/utils/app_colors.dart';
import 'package:todo_app/utils/app_text_styles.dart';
import 'package:todo_app/widgets/login_reg_field.dart';
import 'package:todo_app/widgets/my_loader.dart';
import 'package:todo_app/widgets/show_toast.dart';

import '../../../firebase/auth/firebase_auth_manager.dart';

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
      body: Padding(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 40, bottom: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.tr("signUp"),
                style: theme.textTheme.titleLarge!.copyWith(fontSize: 40),
              ),
              Text(
                context.tr("plsEnterYourDetails"),
                style: theme.textTheme.labelMedium,
              ),
              _buildTextField(
                  prefixIcon: Icon(
                    Icons.person,
                    color: theme.primaryColorDark,
                  ),
                  key: userNameKey,
                  title: context.tr("name"),
                  hintText: context.tr("userName"),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return context.tr("required");
                    if (value.length < 4) {
                      return "username should be at least 4 characters";
                    }
                    return null;
                  },
                  controller: userNameController),
              _buildTextField(
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: theme.primaryColorDark,
                  ),
                  key: emailKey,
                  title: context.tr("email"),
                  hintText: "Example@gmail.com",
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return context.tr("required");
                    return null;
                  },
                  controller: emailController),
              _buildTextField(
                  prefixIcon: Icon(
                    Icons.password,
                    color: theme.primaryColorDark,
                  ),
                  isPassField: true,
                  key: passwordKey,
                  title: context.tr("password"),
                  hintText: context.tr("atLeast8Char"),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return context.tr("required");
                    if (value.length < 8) {
                      return context.tr("atLeast8Char");
                    }
                    return null;
                  },
                  controller: passwordController),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (userNameKey.currentState!.validate() &&
                      emailKey.currentState!.validate() &&
                      passwordKey.currentState!.validate()) {
                    showLoading(context);
                    await FirebaseAuthManager.register(
                        userName: userNameController.text,
                        email: emailController.text,
                        password: passwordController.text);
                    hideLoading(context);
                    if (FirebaseAuth.instance.currentUser != null &&
                        context.mounted) {
                      await FirebaseAuthManager.sendEmailVerificationLink();
                      showToast(
                          msg: context.tr("verifyEmailSent"),
                          color: AppColors.doneColor);
                      Timer.periodic(
                        const Duration(seconds: 5),
                        (timer) {
                          FirebaseAuth.instance.currentUser!.reload();
                          if (FirebaseAuth
                              .instance.currentUser!.emailVerified) {
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
                  context.tr("signUp"),
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
      ),
    );
  }

  Widget _buildTextField(
      {required String title,
      required String hintText,
      required TextEditingController controller,
      required FormFieldValidator<String> validator,
      required Icon prefixIcon,
      bool isPassField = false,
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
          LoginRegField(
              prefixIcon: prefixIcon,
              isPassField: isPassField,
              formKey: key,
              controller: controller,
              validator: validator,
              hintText: hintText),
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
            context.tr("login"),
            style: theme.textTheme.titleLarge,
          )),
    );
  }
}
