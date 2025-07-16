import 'package:firebase_auth/firebase_auth.dart';
import 'package:tp_flutter/core/repositories/auth/auth_data_source.dart';

class AuthDataSourceImpl extends AuthDataSource {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }

  @override
  Future<UserCredential> signUpWithMailAndPassword(String mail, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: mail,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        try {
          return await _auth.signInWithEmailAndPassword(
            email: mail,
            password: password,
          );
        } on FirebaseAuthException catch (signInError) {
          if (signInError.code == 'wrong-password') {
            throw FirebaseAuthException(
              code: 'wrong-password',
              message: 'Mot de passe incorrect',
            );
          }
          rethrow;
        }
      }
      rethrow;
    }
  }

}