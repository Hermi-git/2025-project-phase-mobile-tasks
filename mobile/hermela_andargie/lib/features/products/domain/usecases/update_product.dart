import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class UpdateProductUseCase extends UseCase<Product, UpdateProductParams> {
  final ProductRepository repository;

  UpdateProductUseCase(this.repository);

  @override
  Future<Either<Failure, Product>> call(UpdateProductParams params) {
    return repository.updateProduct(product: params.product);
  }
}

class UpdateProductParams {
  final Product product;

  UpdateProductParams({required this.product});
}
