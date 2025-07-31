import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final List<Product> _products = [];

  @override
  Future<List<Product>> getAllProducts() async {
    return _products;
  }

  @override
  Future<Product> getProduct(String id) async {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (_) {
      throw Exception('Product not found');
    }
  }

  @override
  Future<void> insertProduct(Product product) async {
    // Check if product with same id already exists
    final exists = _products.any((p) => p.id == product.id);
    if (exists) {
      throw Exception('Product with id "${product.id}" already exists.');
    }
    _products.add(product);
  }

  @override
  Future<void> updateProduct(Product updatedProduct) async {
    final index = _products.indexWhere((p) => p.id == updatedProduct.id);
    if (index == -1) {
      throw Exception('Product not found');
    }
    _products[index] = updatedProduct;
  }

  @override
  Future<void> deleteProduct(String id) async {
    final initialLength = _products.length;
    _products.removeWhere((product) => product.id == id);
    if (_products.length == initialLength) {
      throw Exception('Product not found');
    }
  }

}
