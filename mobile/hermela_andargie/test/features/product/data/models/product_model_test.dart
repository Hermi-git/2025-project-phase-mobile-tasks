import 'package:flutter_test/flutter_test.dart';
import 'package:hermela_andargie/features/products/data/models/product_model.dart';
import 'package:hermela_andargie/features/products/domain/entities/product.dart';


void main() {
  // Arrange: sample test product model
  const tProductModel = ProductModel(
    id: 'p1',
    name: 'Test Product',
    description: 'A test product',
    imageUrl: 'https://example.com/product.jpg',
    price: 19.99,
  );

  test('should be a subclass of Product entity', () {
    // Assert: check inheritance
    expect(tProductModel, isA<Product>());
  });

  group('fromJson', () {
    test('should return a valid ProductModel from JSON map', () {
      // Arrange: JSON map mimicking API response
      final jsonMap = {
        'id': 'p1',
        'name': 'Test Product',
        'description': 'A test product',
        'imageUrl': 'https://example.com/product.jpg',
        'price': 19.99,
      };

      // Act: decode json into model
      final result = ProductModel.fromJson(jsonMap);

      // Assert: model matches expected
      expect(result, tProductModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map with correct values', () {
      // Act: convert model to json
      final result = tProductModel.toJson();

      // Assert: json map contains correct data
      final expectedMap = {
        'id': 'p1',
        'name': 'Test Product',
        'description': 'A test product',
        'imageUrl': 'https://example.com/product.jpg',
        'price': 19.99,
      };
      expect(result, expectedMap);
    });
  });
}
