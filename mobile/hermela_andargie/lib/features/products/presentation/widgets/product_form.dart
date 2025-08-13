
import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import 'app_button.dart';

class ProductForm extends StatefulWidget {
  final Product? initialProduct;
  final void Function(
    String name,
    double price,
    String description,
    String imageUrl,
  )
  onSubmit;

  const ProductForm({super.key, this.initialProduct, required this.onSubmit});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialProduct?.name ?? '',
    );
    _priceController = TextEditingController(
      text:
          widget.initialProduct != null
              ? widget.initialProduct!.price.toString()
              : '',
    );
    _descriptionController = TextEditingController(
      text: widget.initialProduct?.description ?? '',
    );
    _imageUrlController = TextEditingController(
      text: widget.initialProduct?.imageUrl ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        _nameController.text,
        double.tryParse(_priceController.text) ?? 0.0,
        _descriptionController.text,
        _imageUrlController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Product Name'),
            validator:
                (value) =>
                    value == null || value.isEmpty
                        ? 'Enter product name'
                        : null,
          ),
          TextFormField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Price'),
            validator:
                (value) =>
                    value == null || double.tryParse(value) == null
                        ? 'Enter valid price'
                        : null,
          ),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
            maxLines: 3,
          ),
          TextFormField(
            controller: _imageUrlController,
            decoration: const InputDecoration(labelText: 'Image URL'),
          ),
          const SizedBox(height: 20),
          AppButton(
            label:
                widget.initialProduct == null
                    ? 'Add Product'
                    : 'Update Product',
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
