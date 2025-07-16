import 'package:firebase_auth/firebase_auth.dart';
import 'package:tp_flutter/core/repositories/auth/auth_data_source.dart';

class AuthRepository {
  final AuthDataSource authDataSource;

  const AuthRepository({required this.authDataSource});

  Future<UserCredential> signUpWithEmailAndPassword(String email, String password) async {
    try {
      return await authDataSource.signUpWithMailAndPassword(email, password);
    }catch (error) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await authDataSource.logout();
    }catch (error) {
      rethrow;
    }
  }
}