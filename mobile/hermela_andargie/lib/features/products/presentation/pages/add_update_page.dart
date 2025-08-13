import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/product.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../widgets/app_button.dart';
import '../widgets/product_form.dart';

class AddUpdatePage extends StatelessWidget {
  final Product? product; // null → adding new

  const AddUpdatePage({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    final isEditing = product != null;

    void handleSubmit(
      String name,
      double price,
      String description,
      String imageUrl,
    ) {
      final newProduct = Product(
        id: product?.id ?? '',
        name: name.trim(),
        description: description.trim(),
        price: price,
        imageUrl: imageUrl.trim(),
      );

      if (isEditing) {
        context.read<ProductBloc>().add(UpdateProductEvent(newProduct));
      } else {
        context.read<ProductBloc>().add(CreateProductEvent(newProduct));
      }

      Navigator.pop(context);
    }

    void handleDelete() {
      if (product != null) {
        context.read<ProductBloc>().add(DeleteProductEvent(product!.id));
      }
      Navigator.pop(context);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F3F8),
      appBar: AppBar(
        title: Text(isEditing ? 'Update Product' : 'Add Product'),
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
              // Image Upload Placeholder
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

              // Reusable Product Form
              ProductForm(initialProduct: product, onSubmit: handleSubmit),
              const SizedBox(height: 16),

              // Delete Button (only for edit mode)
              if (isEditing)
                AppButton(
                  label: 'DELETE',
                  onPressed: handleDelete,
                  color: Colors.red,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
