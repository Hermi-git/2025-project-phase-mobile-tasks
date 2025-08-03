import 'dart:convert';
import 'package:http/http.dart' as http;


import '../../../../core/errors/exception.dart';
import '../models/product_model.dart';
import 'product_remote_data_source.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final url = Uri.parse(
      'https://g5-flutter-learning-path-be.onrender.com/products',
    );
    final response = await client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      final products =
          jsonList.map((json) => ProductModel.fromJson(json)).toList();
      return products;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final url = Uri.parse(
      'https://g5-flutter-learning-path-be.onrender.com/products/$id',
    );
    final response = await client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return ProductModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

@override
  Future<ProductModel> createProduct({required ProductModel product}) async {
    final url = Uri.parse(
      'https://g5-flutter-learning-path-be.onrender.com/products',
    );
    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );

    if (response.statusCode == 201) {
      return ProductModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }


 @override
  Future<ProductModel> updateProduct({required ProductModel product}) async {
    final url = Uri.parse(
      'https://g5-flutter-learning-path-be.onrender.com/products/${product.id}',
    );
    final response = await client.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );

    if (response.statusCode == 200) {
      return ProductModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }


  @override
  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
      'https://g5-flutter-learning-path-be.onrender.com/products/$id',
    );
    final response = await client.delete(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 204) {
      throw ServerException();
    }
  }

}
