import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getAllProducts();
  Future<Either<Failure, Product>> getProductById(String id);
  Future<Either<Failure, Product>> createProduct({required Product product});
  Future<Either<Failure, Product>> updateProduct({required Product product});
  Future<Either<Failure, void>> deleteProduct(String id);
}
