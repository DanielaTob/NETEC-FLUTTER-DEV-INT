import 'package:auth_firebase_app/providers/auth_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authenticationServiceProvider = Provider<AuthenticationService>((ref) {
  return AuthenticationService(ref);
});

class AuthenticationService {
  final Ref ref;
  AuthenticationService(this.ref);
  Future<void> signIn({required String email, required String password}) async {
    try {
      final res = await ref
          .read(firebaseAuthProvider)
          .signInWithEmailAndPassword(email: email, password: password);
      debugPrint('User: $res');
    } on FirebaseAuthException catch (e) {
      debugPrint(e.code);
    } catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    try {
      await ref
          .read(firebaseAuthProvider)
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      debugPrint(e.code);
    } catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> signOut() async {
    await ref.read(firebaseAuthProvider).signOut();
  }
}