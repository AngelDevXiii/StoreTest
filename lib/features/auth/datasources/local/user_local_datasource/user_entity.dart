import 'package:objectbox/objectbox.dart';

@Entity()
class CachedUser {
  @Id()
  int id = 0;
  final String uid;
  final String? name;
  final String? email;
  final String? photoUrl;

  CachedUser({required this.uid, this.name, this.email, this.photoUrl});
}
