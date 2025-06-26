import 'package:flutter/material.dart';
import 'package:malik_store/Services/firestore_service.dart';
import 'package:malik_store/models/product.dart';
import 'package:malik_store/Widgets/product_card.dart';

class SearchScreen extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Product> searchResults = [];

    return Scaffold(
      appBar: AppBar(title: Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(labelText: 'Search products'),
              onChanged: (query) async {
                searchResults = (await FirestoreService().searchProducts(query))
                    .cast<Product>();
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (_, i) => ProductCard(product: searchResults[i]),
            ),
          ),
        ],
      ),
    );
  }
}
