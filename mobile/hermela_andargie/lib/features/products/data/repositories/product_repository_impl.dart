import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final List<Product> _products = [];

  @override
  Future<Either<Failure, List<Product>>> getAllProducts() async {
    try {
      return Right(_products);
    } catch (e) {
      return Left(ServerFailure()); 
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(String id) async {
    try {
      final product = _products.firstWhere((product) => product.id == id);
      return Right(product);
    } catch (e) {
      return Left(NotFoundFailure('Product not found'));
    }
  }

  @override
  Future<Either<Failure, Product>> createProduct({
    required Product product,
  }) async {
    try {
      final exists = _products.any((p) => p.id == product.id);
      if (exists) {
        return Left(
          DuplicateFailure('Product with id "${product.id}" already exists.'),
        );
      }
      _products.add(product);
      return Right(product);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Product>> updateProduct({
    required Product product,
  }) async {
    try {
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index == -1) {
        return Left(NotFoundFailure('Product not found'));
      }
      _products[index] = product;
      return Right(product);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    try {
      final initialLength = _products.length;
      _products.removeWhere((product) => product.id == id);
      if (_products.length == initialLength) {
        return Left(NotFoundFailure('Product not found'));
      }
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
