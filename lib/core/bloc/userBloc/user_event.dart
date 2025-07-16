abstract class UserEvent {
  const UserEvent();
}

final class SignUpWithEmailAndPassword extends UserEvent {
  final String email;
  final String password;

  const SignUpWithEmailAndPassword(this.email, this.password);
}

final class Logout extends UserEvent {
  const Logout();
}