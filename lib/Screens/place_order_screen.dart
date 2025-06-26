import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../models/order.dart';

class PlaceOrderScreen extends StatefulWidget {
  final Product product;

  PlaceOrderScreen({required this.product});

  @override
  _PlaceOrderScreenState createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController(); // ✅ NEW
  final _addressController = TextEditingController();

  bool _isPlacing = false;

  void placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isPlacing = true);

    final order = Order(
      orderId: '', // Firestore will assign this
      items: [widget.product],
      totalAmount: widget.product.cost,
      customerName: _nameController.text.trim(),
      customerEmail: _emailController.text.trim(),
      customerPhone: _phoneController.text.trim(), // ✅ NEW
      customerAddress: _addressController.text.trim(),
      status: 'Pending',
    );

    final docRef = FirebaseFirestore.instance.collection('orders').doc();
    await docRef.set(order.toJson()..['orderId'] = docRef.id);

    setState(() => _isPlacing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order placed!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(title: Text('Place Order')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              leading: Image.network(product.photoUrl, width: 60, height: 60),
              title: Text(product.name),
              subtitle: Text('\$${product.cost.toStringAsFixed(2)}'),
            ),
            Divider(),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Full Name'),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Enter your name' : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (val) => val == null || !val.contains('@')
                        ? 'Enter valid email'
                        : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: 'Phone Number'),
                    keyboardType: TextInputType.phone,
                    validator: (val) => val == null || val.isEmpty
                        ? 'Enter phone number'
                        : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(labelText: 'Address'),
                    maxLines: 2,
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Enter address' : null,
                  ),
                  SizedBox(height: 20),
                  _isPlacing
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: placeOrder,
                          child: Text('Place Order'),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
