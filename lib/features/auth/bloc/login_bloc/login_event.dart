part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {
  const LoginEvent();
}

final class LoginEmailChanged extends LoginEvent {
  const LoginEmailChanged(this.email);

  final String email;
}

final class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged(this.password);

  final String password;
}

final class LoginWithCredentialsPressed extends LoginEvent {
  const LoginWithCredentialsPressed();
}

final class LoginWithGooglePressed extends LoginEvent {
  const LoginWithGooglePressed();
}
