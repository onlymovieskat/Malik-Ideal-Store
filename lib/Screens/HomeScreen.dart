import 'package:flutter/material.dart';
import 'package:malik_store/Screens/view_order_screen.dart';
import '../../screens/Admin/admin_home_screen.dart';
import '../../services/firestore_service.dart';
import '../../widgets/product_card.dart';
import '../../widgets/category_dropdown.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _service = FirestoreService();
  List<dynamic> _products = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';

  void fetchProducts() async {
    List<dynamic> results;
    if (_searchQuery.isNotEmpty) {
      // If search query is not empty, search products
      results = await _service.searchProducts(_searchQuery);
    } else {
      // Otherwise, get products by category
      results = await _service.getProducts(category: _selectedCategory);
    }
    setState(() {
      _products = results;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Malik Store',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings, color: Colors.black),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => AdminHomeScreen()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Field
            TextField(
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
              onChanged: (val) {
                _searchQuery = val;
                fetchProducts();
              },
            ),
            const SizedBox(height: 12),
            // Category and View Orders Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CategoryDropdown(
                    onChanged: (value) {
                      _selectedCategory = value;
                      fetchProducts();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ViewOrdersScreen()),
                    );
                  },
                  icon: const Icon(Icons.shopping_bag),
                  label: const Text('My Orders'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Product Grid
            Expanded(
              child: _products.isEmpty
                  ? Center(
                      child: Text(
                        "No products found.",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.only(bottom: 16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            MediaQuery.of(context).size.width > 600 ? 3 : 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: _products.length,
                      itemBuilder: (_, index) =>
                          ProductCard(product: _products[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
