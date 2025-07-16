import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthDataSource {
  Future<UserCredential> signUpWithMailAndPassword(String mail, String password);
  Future<void> logout();
}