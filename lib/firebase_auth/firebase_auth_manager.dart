import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/models/user_model.dart';
import 'package:todo_app/utils/app_colors.dart';
import 'package:todo_app/widgets/show_toast.dart';

class FirebaseAuthManager {
  static late UserModel currentUser;

  static Future<void> register(
      {required userName,
      required String email,
      required String password}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      DocumentReference userDoc = FirebaseFirestore.instance
          .collection(UserModel.collectionName)
          .doc(credential.user!.uid);
      await userDoc.set(UserModel(
              userName: userName, userId: credential.user!.uid, email: email)
          .toJson());
    } on FirebaseAuthException catch (e) {
      String? errorMsg = e.message;
      showToast(
          msg: errorMsg ?? "Something went wrong",
          color: AppColors.deleteColor);
    }
  }

  static Future<void> login(
      {required String email, required String password}) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      String? errorMsg = e.message;
      showToast(
          msg: errorMsg ?? "Something went wrong",
          color: AppColors.deleteColor);
    }
  }

  static Future<void> sendEmailVerificationLink() async {
    await FirebaseAuth.instance.currentUser!.sendEmailVerification();
  }
}
