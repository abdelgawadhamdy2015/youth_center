import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';
import '../../core/helper/my_constants.dart';

final signUpControllerProvider = StateNotifierProvider<SignUpController, AsyncValue<void>>(
  (ref) => SignUpController(),
);

class SignUpController extends StateNotifier<AsyncValue<void>> {
  SignUpController() : super(const AsyncData(null));

  Future<void> signUp(CenterUser user) async {
    state = const AsyncLoading();

    try {
      final authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email.trim(),
        password: user.password!.trim(), // Add password to CenterUser if not already
      );

      await FirebaseFirestore.instance
          .collection(MyConstants.userCollection)
          .doc(authResult.user!.uid)
          .set(user.toJson());

      state = const AsyncData(null);
    } on FirebaseAuthException catch (e) {
      state = AsyncError(e.message ?? "Unknown error", StackTrace.current);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }
}
