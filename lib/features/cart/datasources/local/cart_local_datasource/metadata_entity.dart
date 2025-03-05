import 'package:objectbox/objectbox.dart';

@Entity()
class Metadata {
  int id = 0;
  @Property(type: PropertyType.date)
  DateTime cartLastUpdated;

  Metadata({required this.cartLastUpdated});
}
