import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/platform/network_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';


class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Product>>> getAllProducts() async {
    // TODO: Implement using remote/local sources
    return Left(UnimplementedFailure());
  }

  @override
  Future<Either<Failure, Product>> getProductById(String id) async {
    // TODO: Implement using remote/local sources
    return Left(UnimplementedFailure());
  }

  @override
  Future<Either<Failure, Product>> createProduct({
    required Product product,
  }) async {
    // TODO: Implement using remote API
    return Left(UnimplementedFailure());
  }

  @override
  Future<Either<Failure, Product>> updateProduct({
    required Product product,
  }) async {
    // TODO: Implement using remote API
    return Left(UnimplementedFailure());
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    // TODO: Implement using remote API
    return Left(UnimplementedFailure());
  }
}
