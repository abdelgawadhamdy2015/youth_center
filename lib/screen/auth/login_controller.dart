import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final loginControllerProvider = StateNotifierProvider<LoginController, AsyncValue<void>>(
  (ref) => LoginController(),
);

class LoginController extends StateNotifier<AsyncValue<void>> {
  LoginController() : super(const AsyncData(null));

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      state = const AsyncData(null);
    } on FirebaseAuthException catch (e) {
      state = AsyncError(e.message ?? "Unknown error", StackTrace.current);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }
}
