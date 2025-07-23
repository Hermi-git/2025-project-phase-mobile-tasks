import 'package:flutter/material.dart';
import 'package:hermela_andargie/models/product.dart';

class AddUpdatePage extends StatefulWidget {
  final Product? product; // nullable – if null, we're adding

  const AddUpdatePage({super.key, this.product});

  @override
  State<AddUpdatePage> createState() => _AddUpdatePageState();
}

class _AddUpdatePageState extends State<AddUpdatePage> {
  late TextEditingController nameController;
  late TextEditingController categoryController;
  late TextEditingController priceController;
  late TextEditingController ratingController;
  late TextEditingController imagePathController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product?.name ?? '');
    categoryController = TextEditingController(
      text: widget.product?.category ?? '',
    );
    priceController = TextEditingController(
      text: widget.product != null ? widget.product!.price.toString() : '',
    );
    ratingController = TextEditingController(
      text: widget.product != null ? widget.product!.rating.toString() : '',
    );
    imagePathController = TextEditingController(
      text: widget.product?.image ?? '',
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    categoryController.dispose();
    priceController.dispose();
    ratingController.dispose();
    imagePathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F3F8),
      appBar: AppBar(
        title: Text(isEditing ? "Update Product" : "Add Product"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// Image Upload Placeholder
              GestureDetector(
                onTap: () {
                  // Optional: image picker logic
                },
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.add_photo_alternate,
                      size: 50,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              /// Input Fields
              _buildTextField(
                label: "Product Name",
                controller: nameController,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Category",
                controller: categoryController,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Price",
                controller: priceController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Rating",
                controller: ratingController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Image Path",
                controller: imagePathController,
              ),
              const SizedBox(height: 32),

              /// Save Button
              ElevatedButton(
                onPressed: () {
                  final newProduct = Product(
                    name: nameController.text,
                    category: categoryController.text,
                    price: double.tryParse(priceController.text) ?? 0.0,
                    rating: double.tryParse(ratingController.text) ?? 0.0,
                    image: imagePathController.text,
                  );

                  Navigator.pop(context, newProduct);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  isEditing ? "UPDATE" : "ADD",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),

              /// Delete Button (only in edit mode)
              if (isEditing)
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context, 'delete'); // send delete signal
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    "DELETE",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.deepPurple),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
