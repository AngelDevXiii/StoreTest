import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';
import 'package:store_app/features/auth/datasources/remote/authentication_service/authentication_service_errors.dart';
import 'package:store_app/features/auth/form/email_input_form.dart';
import 'package:store_app/features/auth/form/password_validation_form.dart';
import 'package:store_app/features/auth/repository/authentication_repository/authentication_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required this.authenticationRepository})
    : super(const LoginState()) {
    on<LoginEmailChanged>(emailChanged);
    on<LoginPasswordChanged>(passwordChanged);
    on<LoginWithCredentialsPressed>(logInWithCredentials);
    on<LoginWithGooglePressed>(logInWithGoogle);
  }

  final AuthenticationRepository authenticationRepository;

  void emailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    final email = Email.dirty(event.email);

    emit(
      state.copyWith(
        email: email,
        status: FormzSubmissionStatus.initial,
        isValid: Formz.validate([email, state.password]),
      ),
    );
  }

  void passwordChanged(LoginPasswordChanged event, Emitter<LoginState> emit) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        status: FormzSubmissionStatus.initial,
        isValid: Formz.validate([state.email, password]),
      ),
    );
  }

  Future<void> logInWithCredentials(
    LoginWithCredentialsPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    final email = state.email.value;
    final password = state.password.value;

    try {
      await authenticationRepository.logInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on LogInWithEmailAndPasswordFailure catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message,
          status: FormzSubmissionStatus.failure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }

  Future<void> logInWithGoogle(
    LoginWithGooglePressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await authenticationRepository.logInWithGoogle();
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on LogInWithGoogleFailure catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message,
          status: FormzSubmissionStatus.failure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
