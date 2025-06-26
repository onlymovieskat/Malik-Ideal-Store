import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:malik_store/Models/Product.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Future<List<Product>> getProducts({String category = 'All'}) async {
    QuerySnapshot snapshot;
    if (category == 'All') {
      snapshot = await _db.collection('products').get();
    } else {
      snapshot = await _db
          .collection('products')
          .where('category', isEqualTo: category)
          .get();
    }
    return snapshot.docs
        .map((doc) => Product.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> addProduct(Product product) async {
    final doc = _db.collection('products').doc();
    await doc.set(product.toJson()..['id'] = doc.id);
  }

  Future<List<Product>> searchProducts(String query) async {
    final snapshot = await _db.collection('products').get();
    return snapshot.docs
        .map((e) => Product.fromJson(e.data()))
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
