import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  /// Fetches all products from the remote API.
  ///
  /// Throws a [ServerException] for any error responses.
  Future<List<ProductModel>> getAllProducts();

  /// Fetches a single product by ID from the remote API.
  ///
  /// Throws a [ServerException] for any error responses.
  Future<ProductModel> getProductById(String id);

  /// Sends a POST request to create a new product on the server.
  ///
  /// Throws a [ServerException] for any error responses.
  Future<ProductModel> createProduct({required ProductModel product});

  /// Sends a PUT/PATCH request to update an existing product.
  ///
  /// Throws a [ServerException] for any error responses.
  Future<ProductModel> updateProduct({required ProductModel product});

  /// Sends a DELETE request to remove a product by ID.
  ///
  /// Throws a [ServerException] for any error responses.
  Future<void> deleteProduct(String id);
}
