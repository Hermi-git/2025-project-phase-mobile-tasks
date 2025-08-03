import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  /// Returns the most recently cached list of [ProductModel]s.
  ///
  /// Throws a [CacheException] if no cached data is available.
  Future<List<ProductModel>> getLastCachedProductList();

  /// Caches a full list of [ProductModel]s locally.
  ///
  /// Overwrites any previously cached data.
  Future<void> cacheProductList(List<ProductModel> products);
}
