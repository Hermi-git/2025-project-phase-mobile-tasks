import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/platform/network_info.dart';
import '../../../../core/errors/exception.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';
import '../models/product_model.dart';


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
  if (await networkInfo.isConnected) {
    final remoteProducts = await remoteDataSource.getAllProducts();
    localDataSource.cacheProductList(remoteProducts);
    return Right(remoteProducts);
  } else {
    try {
      final localProducts = await localDataSource.getLastCachedProductList();
      return Right(localProducts);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}

 @override
  Future<Either<Failure, Product>> getProductById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final product = await remoteDataSource.getProductById(id);
        return Right(product);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }

 @override
  Future<Either<Failure, Product>> createProduct({
    required Product product,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final createdProduct = await remoteDataSource.createProduct(
          product:
              product as dynamic, 
        );
        return Right(createdProduct);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoConnectionFailure()); 
    }
  }

 @override
  Future<Either<Failure, Product>> updateProduct({
    required Product product,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final updatedProduct = await remoteDataSource.updateProduct(
          product: product as ProductModel,
        );
        return Right(updatedProduct);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return  Left(NoConnectionFailure());
    
    }
  }


  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteProduct(id);
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }

}
