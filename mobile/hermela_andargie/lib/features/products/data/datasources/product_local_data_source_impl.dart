import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exception.dart';
import '../models/product_model.dart';
import 'product_local_data_source.dart';

const CACHED_PRODUCTS = 'CACHED_PRODUCTS';

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;


  ProductLocalDataSourceImpl({required this.sharedPreferences});

  // Helper: encode list of products to JSON string
  String _encodeProductList(List<ProductModel> products) {
    final productListJson =
        products.map((product) => product.toJson()).toList();
    return json.encode(productListJson);
  }

  // Helper: decode JSON string to list of products
  List<ProductModel> _decodeProductList(String jsonString) {
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((jsonItem) => ProductModel.fromJson(jsonItem)).toList();
  }

    @override
  Future<void> cacheProductList(List<ProductModel> products) async {
    final jsonString = _encodeProductList(products);
    await sharedPreferences.setString(CACHED_PRODUCTS, jsonString);
  }

  @override
  Future<List<ProductModel>> getLastCachedProductList() async {
    final jsonString = sharedPreferences.getString(CACHED_PRODUCTS);

    if (jsonString != null) {
      final productList = _decodeProductList(jsonString);
      return productList;
    } else {
      throw CacheException();
    }
  }

}
