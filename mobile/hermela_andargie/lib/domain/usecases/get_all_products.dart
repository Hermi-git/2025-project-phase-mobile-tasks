import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetAllProductsUseCase {
  final ProductRepository repository;

  GetAllProductsUseCase(this.repository);

  Future<List<Product>> call() {
    return repository.getAllProducts();
  }
}
