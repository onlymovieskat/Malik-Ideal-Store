import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/order.dart' as my_models;

class ManageOrdersScreen extends StatefulWidget {
  @override
  _ManageOrdersScreenState createState() => _ManageOrdersScreenState();
}

class _ManageOrdersScreenState extends State<ManageOrdersScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<my_models.Order>> fetchOrders() async {
    final snapshot = await _db.collection('orders').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return my_models.Order.fromJson(data);
    }).toList();
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    await _db.collection('orders').doc(orderId).update({'status': newStatus});
    setState(() {}); // Refresh UI
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'shipped':
        return Colors.orange;
      case 'delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Orders'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: FutureBuilder<List<my_models.Order>>(
        future: fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No orders found"));
          }

          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (_, index) {
              final order = orders[index];
              return Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                  childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Order #${order.orderId}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Chip(
                        label: Text(order.status),
                        backgroundColor:
                            _statusColor(order.status).withOpacity(0.1),
                        labelStyle: TextStyle(
                            color: _statusColor(order.status),
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text('Customer: ${order.customerName}'),
                  ),
                  children: [
                    ...order.items.map((product) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(product.name),
                          trailing:
                              Text('\$${product.cost.toStringAsFixed(2)}'),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Total: \$${order.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.local_shipping),
                          label: const Text('Shipped'),
                          onPressed: () =>
                              updateOrderStatus(order.orderId, 'Shipped'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade300,
                          ),
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.check_circle),
                          label: const Text('Delivered'),
                          onPressed: () =>
                              updateOrderStatus(order.orderId, 'Delivered'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
