import 'dart:convert';

class MenuItem {
  final int id;
  final String name;
  final int price;
  final String type;
  final int quantity;

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.type,
    required this.quantity,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      type: json['type'],
      quantity: json['quantity'],
    );
  }
}

class RestaurantModel {
  final List<MenuItem> restaurant;
  final List<MenuItem> iceCream;
  final List<MenuItem> sweet;
  final List<MenuItem> other;
  final int card;
  final int box;
  RestaurantModel(
      {required this.restaurant,
      required this.iceCream,
      required this.sweet,
      required this.other,
      required this.box,
      required this.card});

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      restaurant: (json['Restaurant'] as List)
          .map((item) => MenuItem.fromJson(item))
          .toList(),
      iceCream: (json['IceCream'] as List)
          .map((item) => MenuItem.fromJson(item))
          .toList(),
      sweet: (json['Sweet'] as List)
          .map((item) => MenuItem.fromJson(item))
          .toList(),
      other: (json['Other'] as List)
          .map((item) => MenuItem.fromJson(item))
          .toList(),
      card: json['card'], // Agregado el campo 'card' desde el JSON
      box: json['box'],
    );
  }
}
