import 'package:objectbox/objectbox.dart';

@Entity()
class CachedCartItem {
  @Id()
  int id = 0;
  final String uid;
  final String name;
  final double price;
  final String cartItemId;
  final String? imageUrl;
  double discount = 0;
  int quantity = 0;

  CachedCartItem({
    required this.uid,
    required this.name,
    required this.price,
    required this.cartItemId,
    required this.quantity,
    this.imageUrl,
    this.discount = 0,
  });
}
