part of 'sign_up_bloc.dart';

@immutable
sealed class SignUpEvent {
  const SignUpEvent();
}

final class SignUpEmailChanged extends SignUpEvent {
  const SignUpEmailChanged(this.email);

  final String email;
}

final class SignUpPasswordChanged extends SignUpEvent {
  const SignUpPasswordChanged(this.password);

  final String password;
}

final class SignUpPasswordConfirmChanged extends SignUpEvent {
  const SignUpPasswordConfirmChanged(this.password);

  final String password;
}

final class SignUpPressed extends SignUpEvent {
  const SignUpPressed();
}
