import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/errors/exception.dart';
import '../models/product_model.dart';
import 'product_remote_data_source.dart';

const _baseUrl = 'https://g5-flutter-learning-path-be.onrender.com';
const _jsonHeaders = {'Content-Type': 'application/json'};


class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSourceImpl({required this.client});

  dynamic _decodeResponse(http.Response response, int expectedStatusCode) {
    if (response.statusCode == expectedStatusCode) {
      return json.decode(response.body);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final url = Uri.parse('$_baseUrl/products');
    final response = await client.get(url, headers: _jsonHeaders);
    final List<dynamic> jsonList = _decodeResponse(response, 200);
    return jsonList.map((json) => ProductModel.fromJson(json)).toList();
  }

 @override
  Future<ProductModel> getProductById(String id) async {
    final url = Uri.parse('$_baseUrl/products/$id');
    final response = await client.get(url, headers: _jsonHeaders);
    final jsonMap = _decodeResponse(response, 200);
    return ProductModel.fromJson(jsonMap);
  }

@override
  Future<ProductModel> createProduct({required ProductModel product}) async {
    final url = Uri.parse('$_baseUrl/products');
    final response = await client.post(
      url,
      headers: _jsonHeaders,
      body: json.encode(product.toJson()),
    );
    final jsonMap = _decodeResponse(response, 201);
    return ProductModel.fromJson(jsonMap);
  }

 @override
  Future<ProductModel> updateProduct({required ProductModel product}) async {
    final url = Uri.parse('$_baseUrl/products/${product.id}');
    final response = await client.put(
      url,
      headers: _jsonHeaders,
      body: json.encode(product.toJson()),
    );
    final jsonMap = _decodeResponse(response, 200);
    return ProductModel.fromJson(jsonMap);
  }



  @override
  Future<void> deleteProduct(String id) async {
    final url = Uri.parse('$_baseUrl/products/$id');
    final response = await client.delete(url, headers: _jsonHeaders);

    if (response.statusCode != 204) {
      throw ServerException();
    }
  }

}
