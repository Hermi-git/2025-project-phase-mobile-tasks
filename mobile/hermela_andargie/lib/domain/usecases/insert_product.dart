import '../entities/product.dart';
import '../repositories/product_repository.dart';

class InsertProductUseCase {
  final ProductRepository repository;

  InsertProductUseCase(this.repository);

  Future<void> call(Product product) {
    return repository.insertProduct(product);
  }
}
