part of 'auth_bloc.dart';

@immutable
sealed class AuthState extends Equatable {}

class Unauthenticated extends AuthState {
  final User user = User.empty();

  @override
  List<Object> get props => [user];
}

class Authenticated extends AuthState {
  final User user;
  final Profile? profile;

  Authenticated({required this.user, this.profile});

  @override
  List<Object?> get props => [user, profile];
}
