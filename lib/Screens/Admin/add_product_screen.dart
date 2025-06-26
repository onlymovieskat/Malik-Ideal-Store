import 'package:flutter/material.dart';
import 'package:malik_store/Models/Product.dart';
import 'package:malik_store/Services/firestore_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final costController = TextEditingController();
  final urlController = TextEditingController();
  final categoryController = TextEditingController();

  bool _isSaving = false;

  Future<void> saveProduct() async {
    setState(() => _isSaving = true);

    final product = Product(
      id: '',
      name: nameController.text.trim(),
      cost: double.tryParse(costController.text.trim()) ?? 0.0,
      photoUrl: urlController.text.trim(),
      description: descController.text.trim(),
      category: categoryController.text.trim(),
      idX: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    await FirestoreService().addProduct(product);
    setState(() => _isSaving = false);

    // Optional: show feedback
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product added successfully!")),
      );
      Navigator.pop(context);
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration:
                      _inputDecoration("Product Name", Icons.text_fields),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descController,
                  decoration:
                      _inputDecoration("Description", Icons.description),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: costController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration("Cost", Icons.attach_money),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: categoryController,
                  decoration: _inputDecoration("Category", Icons.category),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: urlController,
                  decoration: _inputDecoration("Image URL", Icons.image),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    icon: _isSaving
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.save),
                    label: Text(_isSaving ? "Saving..." : "Save Product"),
                    onPressed: _isSaving ? null : saveProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
