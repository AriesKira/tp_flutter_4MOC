import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tp_flutter/core/bloc/userBloc/user_event.dart';
import 'package:tp_flutter/core/bloc/userBloc/user_state.dart';
import 'package:tp_flutter/core/repositories/auth/auth_repository.dart';

import '../../enums/AuthStatus.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final AuthRepository authRepository;

  UserBloc({required this.authRepository}) : super(UserState()) {
    on<SignUpWithEmailAndPassword>(_signUpWithEmailAndPassword);
    on<Logout>(_logout);
  }

  void _signUpWithEmailAndPassword(
      SignUpWithEmailAndPassword event,
      Emitter<UserState> emit,
      ) async {
    emit(state.copyWith(authStatus: AuthStatus.loading, error: null));

    try {
      final UserCredential userCredential = await authRepository
          .signUpWithEmailAndPassword(event.email, event.password);

      if (userCredential.user != null) {
        emit(state.copyWith(
          authStatus: AuthStatus.connected,
          user: userCredential.user!,
        ));
      } else {
        emit(state.copyWith(
          authStatus: AuthStatus.error,
          error: Exception('L\'utilisateur n\'a pas pu être authentifié.'),
        ));
        emit(state.copyWith(authStatus: AuthStatus.disconnected));
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'wrong-password':
          errorMessage = 'Mot de passe incorrect';
          break;
        case 'invalid-credential':
          errorMessage = 'Identifiants invalides';
          break;
        case 'email-already-in-use':
          errorMessage = 'Cet email est déjà utilisé';
          break;
        default:
          errorMessage = e.message ?? 'Erreur d\'authentification';
      }

      emit(state.copyWith(authStatus: AuthStatus.error, error: Exception(errorMessage)));
      emit(state.copyWith(authStatus: AuthStatus.disconnected));
    } catch (error) {
      emit(state.copyWith(
        authStatus: AuthStatus.error,
        error: Exception('Erreur inattendue'),
      ));
      emit(state.copyWith(authStatus: AuthStatus.disconnected));
    }
  }

  void _logout(Logout event, Emitter<UserState> emit) async {
    emit(state.copyWith(authStatus: AuthStatus.loading));
    try {
      await authRepository.logout();
      emit(state.copyWith(authStatus: AuthStatus.disconnected));
    } on Exception catch (error) {
      emit(state.copyWith(authStatus: AuthStatus.error, error: error));
    }
  }
}
