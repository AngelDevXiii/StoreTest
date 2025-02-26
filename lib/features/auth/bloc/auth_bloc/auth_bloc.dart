import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/features/auth/models/profile/profile_model.dart';
import 'package:store_app/features/auth/models/user/user_model.dart';
import 'package:store_app/features/auth/repository/authentication_repository/authentication_repository.dart';

part "auth_event.dart";
part "auth_state.dart";

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthenticationRepository authenticationRepository})
    : _authenticationRepository = authenticationRepository,
      super(Unauthenticated()) {
    on<AuthUserSubscriptionRequested>(_onUserSubscriptionRequested);
    on<AuthLogoutPressed>(_onLogoutPressed);
  }

  final AuthenticationRepository _authenticationRepository;

  Future<void> _onUserSubscriptionRequested(
    AuthUserSubscriptionRequested event,
    Emitter<AuthState> emit,
  ) {
    return emit.onEach(
      _authenticationRepository.user,
      onData: (user) {
        if (user.id == '') {
          emit(Unauthenticated());
        } else {
          emit(Authenticated(user: user));
        }
      },
      onError: addError,
    );
  }

  void _onLogoutPressed(AuthLogoutPressed event, Emitter<AuthState> emit) {
    _authenticationRepository.logOut();
    emit(Unauthenticated());
  }
}
