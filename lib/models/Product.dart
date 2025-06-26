class Product {
  final String id;
  final String name;
  final double cost;
  final String photoUrl;
  final String description;
  final String category;
  final String idX;

  Product({
    required this.id,
    required this.name,
    required this.cost,
    required this.photoUrl,
    required this.description,
    required this.category,
    required this.idX,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        name: json['name'],
        cost: json['cost'],
        photoUrl: json['photoUrl'],
        description: json['description'],
        category: json['category'],
        idX: json['idX'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'cost': cost,
        'photoUrl': photoUrl,
        'description': description,
        'category': category,
        'idX': idX,
      };
}
