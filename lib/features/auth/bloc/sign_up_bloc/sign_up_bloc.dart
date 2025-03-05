import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';
import 'package:store_app/features/auth/datasources/remote/authentication_service/authentication_service_errors.dart';
import 'package:store_app/features/auth/form/email_input_form.dart';
import 'package:store_app/features/auth/form/password_confirm.dart';
import 'package:store_app/features/auth/form/password_validation_form.dart';
import 'package:store_app/features/auth/repository/authentication_repository/authentication_repository.dart';

part 'sign_up_events.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({required this.authenticationRepository})
    : super(const SignUpState()) {
    on<SignUpEmailChanged>(emailChanged);
    on<SignUpPasswordChanged>(passwordChanged);
    on<SignUpPasswordConfirmChanged>(passwordConfirmChanged);
    on<SignUpPressed>(signUpPressed);
  }

  final AuthenticationRepository authenticationRepository;

  void emailChanged(SignUpEmailChanged event, Emitter<SignUpState> emit) {
    final email = Email.dirty(event.email);

    emit(
      state.copyWith(
        email: email,
        status: FormzSubmissionStatus.initial,
        isValid: Formz.validate([email, state.password, state.passwordConfirm]),
      ),
    );
  }

  void passwordChanged(SignUpPasswordChanged event, Emitter<SignUpState> emit) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        status: FormzSubmissionStatus.initial,
        isValid: Formz.validate([state.email, password, state.passwordConfirm]),
      ),
    );
  }

  void passwordConfirmChanged(
    SignUpPasswordConfirmChanged event,
    Emitter<SignUpState> emit,
  ) {
    final passwordConfirm = PasswordConfirm.dirty(
      password: state.password.value,
      value: event.password,
    );

    emit(
      state.copyWith(
        passwordConfirm: passwordConfirm,
        status: FormzSubmissionStatus.initial,
        isValid: Formz.validate([state.email, state.password, passwordConfirm]),
      ),
    );
  }

  Future<void> signUpPressed(
    SignUpPressed event,
    Emitter<SignUpState> emit,
  ) async {
    if (!state.isValid) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      await authenticationRepository.signUp(
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on SignUpWithEmailAndPasswordFailure catch (e) {
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
