import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:flutter/material.dart';
import '../models/order.dart';

class ViewOrdersScreen extends StatefulWidget {
  @override
  _ViewOrdersScreenState createState() => _ViewOrdersScreenState();
}

class _ViewOrdersScreenState extends State<ViewOrdersScreen> {
  final TextEditingController _emailController = TextEditingController();
  List<Order> _orders = [];
  bool _loading = false;

  Future<void> _fetchOrders() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid email')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('customerEmail', isEqualTo: email)
          .orderBy('orderId', descending: true)
          .get();

      final orders = snapshot.docs.map((doc) {
        final data = doc.data();
        return Order.fromJson(data);
      }).toList();

      setState(() {
        _orders = orders;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching orders')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Orders')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Enter your email',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _fetchOrders,
                ),
              ),
            ),
            SizedBox(height: 20),
            _loading
                ? Center(child: CircularProgressIndicator())
                : _orders.isEmpty
                    ? Text('No orders found.')
                    : Expanded(
                        child: ListView.builder(
                          itemCount: _orders.length,
                          itemBuilder: (_, index) {
                            final order = _orders[index];
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Order ID: ${order.orderId}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text('Status: ${order.status}'),
                                    Text(
                                        'Total: \$${order.totalAmount.toStringAsFixed(2)}'),
                                    SizedBox(height: 10),
                                    Text('Products:'),
                                    ...order.items.map((p) =>
                                        Text('- ${p.name} (\$${p.cost})')),
                                    SizedBox(height: 10),
                                    Text('Address: ${order.customerAddress}'),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
