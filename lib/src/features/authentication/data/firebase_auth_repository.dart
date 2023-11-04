import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_auth_repository.g.dart';

class AuthRepository {
  const AuthRepository(this._auth);
  final FirebaseAuth _auth;

  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  Stream<User?> userChanges() {
    return _auth.userChanges();
  }

  User? get currentUser {
    return _auth.currentUser;
  }

  Future<void> signInAnonymously() {
    return _auth.signInAnonymously();
  }
}

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) {
  return FirebaseAuth.instance;
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(ref.watch(firebaseAuthProvider));
}

@riverpod
Stream<User?> authStateChanges(AuthStateChangesRef ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
}

@riverpod
Stream<User?> userChanges(UserChangesRef ref) {
  return ref.watch(authRepositoryProvider).userChanges();
}

@riverpod
Stream<User> emailVerificationStateChanges(
    EmailVerificationStateChangesRef ref) async* {
  final authRepository = ref.watch(authRepositoryProvider);
  User? currentUser = authRepository.currentUser;

  if (currentUser == null ||
      currentUser.isAnonymous ||
      currentUser.emailVerified) {
    return;
  }

  while (currentUser != null && !currentUser.emailVerified) {
    await Future.delayed(const Duration(seconds: 1));
    await currentUser.reload();
    currentUser = authRepository.currentUser;

    if (currentUser != null && currentUser.emailVerified) {
      yield currentUser;
    }
  }
}
