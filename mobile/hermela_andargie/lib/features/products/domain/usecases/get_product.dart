import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductUseCase extends UseCase<Product, GetProductParams> {
  final ProductRepository repository;

  GetProductUseCase(this.repository);

  @override
  Future<Either<Failure, Product>> call(GetProductParams params) {
    return repository.getProductById(params.id);
  }
}

class GetProductParams {
  final String id;

  GetProductParams({required this.id});
}
