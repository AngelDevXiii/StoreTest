import 'package:objectbox/objectbox.dart';

@Entity()
class CachedProduct {
  @Id()
  int id = 0;
  final String uid;
  final String name;
  final double price;
  final String productId;
  final String? imageUrl;
  String? description;
  double discount = 0;
  int quantity = 0;
  double stars = 0;
  int reviews = 0;
  bool isAvailable = true;

  @Property(type: PropertyType.date)
  DateTime createdAt;

  @Property(type: PropertyType.date)
  DateTime updatedAt;

  void updateTimestamp() {
    updatedAt = DateTime.now();
  }

  CachedProduct({
    required this.uid,
    required this.name,
    required this.price,
    required this.productId,
    this.imageUrl,
    this.description,
    this.discount = 0,
    this.stars = 0,
    this.reviews = 0,
    this.isAvailable = true,
  }) : createdAt = DateTime.now(),
       updatedAt = DateTime.now();
}
