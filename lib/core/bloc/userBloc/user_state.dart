import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../enums/AuthStatus.dart';

class UserState {
  final AuthStatus authStatus;
  final User? user;
  final DocumentSnapshot? userDoc;
  final Exception? error;

  const UserState({
    this.authStatus = AuthStatus.disconnected,
    this.user,
    this.userDoc,
    this.error
  });

  UserState copyWith({
    AuthStatus? authStatus,
    User? user,
    DocumentSnapshot? userDoc,
    Exception? error
  }) {
    return UserState(
      authStatus: authStatus ?? this.authStatus,
      user: user ?? this.user,
      userDoc: userDoc ?? this.userDoc,
      error: error ?? this.error
    );
  }
}