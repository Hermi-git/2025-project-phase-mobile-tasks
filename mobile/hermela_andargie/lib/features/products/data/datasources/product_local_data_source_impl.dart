import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';


import '../../../../core/errors/exception.dart';
import '../models/product_model.dart';
import 'product_local_data_source.dart';

const CACHED_PRODUCTS = 'CACHED_PRODUCTS';

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProductLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheProductList(List<ProductModel> products) {
    final jsonString = json.encode(
      products.map((product) => product.toJson()).toList(),
    );
    return sharedPreferences.setString(CACHED_PRODUCTS, jsonString);
  }

  @override
  Future<List<ProductModel>> getLastCachedProductList() {
    final jsonString = sharedPreferences.getString(CACHED_PRODUCTS);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return Future.value(
        jsonList.map((jsonItem) => ProductModel.fromJson(jsonItem)).toList(),
      );
    } else {
      throw CacheException();
    }
  }
}
