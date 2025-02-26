import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class User with _$User {
  const User._();

  const factory User({
    required String id,
    @Default('') String? profileId,
    @Default('') String? email,
    @Default('') String? name,
    @Default('') String? photoUrl,
  }) = _User;

  factory User.empty() =>
      User(id: '', email: '', name: '', photoUrl: '', profileId: '');

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}
