import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class InsertProductUseCase extends UseCase<Product, InsertProductParams> {
  final ProductRepository repository;

  InsertProductUseCase(this.repository);

  @override
  Future<Either<Failure, Product>> call(InsertProductParams params) {
    return repository.createProduct(product: params.product);
  }
}


class InsertProductParams extends Equatable {
  final Product product;

  const InsertProductParams({required this.product});

  @override
  List<Object?> get props => [product];
}
