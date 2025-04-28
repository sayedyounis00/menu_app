// auth_state.dart
abstract class AuthnticationState {
  const AuthnticationState();
}

class AuthInitial extends AuthnticationState {
  const AuthInitial();
}

class AuthLoading extends AuthnticationState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthnticationState {}

class AuthUnauthenticated extends AuthnticationState {
  const AuthUnauthenticated();
}

class EmailVerified extends AuthnticationState {
  const EmailVerified();
}

class AuthFailure extends AuthnticationState {
  final String message;
  const AuthFailure(this.message);
}

//confirmation
class ConfirmationCodeSent extends AuthnticationState {
  const ConfirmationCodeSent();
}

class ConfirmationCodeSuccess extends AuthnticationState {
  const ConfirmationCodeSuccess();
}

class ConfirmationCodeFails extends AuthnticationState {
  const ConfirmationCodeFails();
}

class ConfirmationLoading extends AuthnticationState {
  const ConfirmationLoading();
}

