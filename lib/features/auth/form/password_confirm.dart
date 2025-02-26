import 'package:formz/formz.dart';

enum PasswordConfirmValidationError { invalid, mismatch }

class PasswordConfirm
    extends FormzInput<String, PasswordConfirmValidationError> {
  final String password;

  const PasswordConfirm.pure({this.password = ''}) : super.pure('');

  const PasswordConfirm.dirty({required this.password, String value = ''})
    : super.dirty(value);

  @override
  PasswordConfirmValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return PasswordConfirmValidationError.invalid;
    }
    return password == value ? null : PasswordConfirmValidationError.mismatch;
  }
}
