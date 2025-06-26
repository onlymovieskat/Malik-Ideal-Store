import 'package:malik_store/models/product.dart'; // ✅ Use lowercase folder name

class Order {
  final String orderId; // Firestore document ID
  final List<Product> items; // List of purchased items
  final double totalAmount; // Total order cost
  final String customerName;
  final String customerAddress;
  final String customerEmail;
  final String customerPhone; // ✅ included now
  final String status; // e.g., pending, shipped, delivered

  Order({
    required this.orderId,
    required this.items,
    required this.totalAmount,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.customerAddress,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        orderId: json['orderId'],
        items: (json['items'] as List)
            .map((item) => Product.fromJson(item))
            .toList(),
        totalAmount: (json['totalAmount'] as num).toDouble(),
        customerName: json['customerName'],
        customerAddress: json['customerAddress'],
        status: json['status'],
        customerEmail: json['customerEmail'],
        customerPhone: json['customerPhone'], // ✅ added
      );

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'items': items.map((e) => e.toJson()).toList(),
        'totalAmount': totalAmount,
        'customerName': customerName,
        'customerAddress': customerAddress,
        'status': status,
        'customerEmail': customerEmail,
        'customerPhone': customerPhone, // ✅ added
      };
}
