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
      quantity: json['quantiti'],
    );
  }
}

class MenuCategory {
  final List<MenuItem> card;
  final List<MenuItem> effective;

  MenuCategory({
    required this.card,
    required this.effective,
  });

  factory MenuCategory.fromJson(Map<String, dynamic> json) {
    return MenuCategory(
      card: (json['card'] as List)
          .map((item) => MenuItem.fromJson(item))
          .toList(),
      effective: (json['Efective'] as List)
          .map((item) => MenuItem.fromJson(item))
          .toList(),
    );
  }
}

class RestaurantModel {
  final MenuCategory restaurant;
  final MenuCategory iceCream;
  final MenuCategory sweet;
  final MenuCategory other;

  RestaurantModel({
    required this.restaurant,
    required this.iceCream,
    required this.sweet,
    required this.other,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      restaurant: MenuCategory.fromJson(json['Restaurant']),
      iceCream: MenuCategory.fromJson(json['IceCream']),
      sweet: MenuCategory.fromJson(json['Sweet']),
      other: MenuCategory.fromJson(json['Other']),
    );
  }
}
