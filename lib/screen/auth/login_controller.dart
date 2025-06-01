import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youth_center/core/service/data_base_service.dart';
import 'package:youth_center/models/user_model.dart';

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
  Future<void> signOut() async {
    state = const AsyncLoading();
    try {
      await FirebaseAuth.instance.signOut();
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }
  Future<void> resetPassword(String email) async {
    state = const AsyncLoading();
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
      state = const AsyncData(null);
    } on FirebaseAuthException catch (e) {
      state = AsyncError(e.message ?? "Unknown error", StackTrace.current);
    }
    catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }
  Future<void> signUp(String email, String password) async {
    state = const AsyncLoading();
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
  Future<void> updateProfile(CenterUser centerUser) async {
    state = const AsyncLoading();
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
         DataBaseService().updateCenter(
        centerUser
      );
        // To update the phone number, you must first verify the phone and obtain a PhoneAuthCredential.
        // Example: await user.updatePhoneNumber(phoneAuthCredential);
        // For now, skipping phone number update as it requires verification flow.
      }
      user = FirebaseAuth.instance.currentUser; // Refresh user data
     
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }
  Future<void> deleteAccount() async {
    state = const AsyncLoading();
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete();
      }
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }
}