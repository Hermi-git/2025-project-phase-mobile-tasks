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

  // Helper method to safely convert Product to ProductModel
  ProductModel _toModel(Product product) {
    if (product is ProductModel) return product;
    return ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      imageUrl: product.imageUrl,
      price: product.price,
    );
  }

  // Generic helper method to handle remote calls with network check and error handling
  Future<Either<Failure, T>> _callRemote<T>(
    Future<T> Function() remoteCall,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteCall();
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getAllProducts() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProducts = await remoteDataSource.getAllProducts();
        await localDataSource.cacheProductList(remoteProducts);
        return Right(remoteProducts);
      } on ServerException {
        return Left(ServerFailure());
      }
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
    return _callRemote(() => remoteDataSource.getProductById(id));
  }

  @override
  Future<Either<Failure, Product>> createProduct({required Product product}) {
    final productModel = _toModel(product);
    return _callRemote(
      () => remoteDataSource.createProduct(product: productModel),
    );
  }

  @override
  Future<Either<Failure, Product>> updateProduct({required Product product}) {
    final productModel = _toModel(product);
    return _callRemote(
      () => remoteDataSource.updateProduct(product: productModel),
    );
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    return _callRemote(() => remoteDataSource.deleteProduct(id));
  }
}
