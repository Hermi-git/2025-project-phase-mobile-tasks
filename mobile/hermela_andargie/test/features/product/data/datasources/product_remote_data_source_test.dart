import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermela_andargie/core/errors/exception.dart';
import 'package:hermela_andargie/features/products/data/datasources/product_remote_data_source_impl.dart';
import 'package:hermela_andargie/features/products/data/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'product_remote_data_source_test.mocks.dart';

void main() {
  late ProductRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = ProductRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('getAllProducts', () {
    final tProductList = [
      const ProductModel(
        id: 'p1',
        name: 'Test Product',
        description: 'A test product',
        imageUrl: 'https://example.com/product.jpg',
        price: 19.99,
      ),
    ];

    test(
      'should perform a GET request on /products with application/json header',
      () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse(
              'https://g5-flutter-learning-path-be.onrender.com/products',
            ),
            headers: anyNamed('headers'),
          ),
        ).thenAnswer(
          (_) async => http.Response(fixture('product_cached.json'), 200),
        );

        // act
        await dataSource.getAllProducts();

        // assert
        verify(
          mockHttpClient.get(
            Uri.parse(
              'https://g5-flutter-learning-path-be.onrender.com/products',
            ),
            headers: {'Content-Type': 'application/json'},
          ),
        );
      },
    );

    test(
      'should return List<ProductModel> when response code is 200 (success)',
      () async {
        // arrange
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(fixture('product_cached.json'), 200),
        );

        // act
        final result = await dataSource.getAllProducts();

        // assert
        expect(result, equals(tProductList));
      },
    );

    test(
      'should throw ServerException when response code is not 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response('Something went wrong', 404));

        // act
        final call = dataSource.getAllProducts;

        // assert
        expect(() => call(), throwsA(isA<ServerException>()));
      },
    );
  });

  group('getProductById', () {
    final tId = 'p1';
    final tProductModel = ProductModel.fromJson(
      json.decode(fixture('product_cached.json'))[0],
    );

    test(
      'should perform a GET request on /products/{id} with application/json header',
      () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse(
              'https://g5-flutter-learning-path-be.onrender.com/products/$tId',
            ),
            headers: anyNamed('headers'),
          ),
        ).thenAnswer(
          (_) async => http.Response(fixture('product_single.json'), 200),
        );

        // act
        await dataSource.getProductById(tId);

        // assert
        verify(
          mockHttpClient.get(
            Uri.parse(
              'https://g5-flutter-learning-path-be.onrender.com/products/$tId',
            ),
            headers: {'Content-Type': 'application/json'},
          ),
        );
      },
    );

    test(
      'should return ProductModel when response code is 200 (success)',
      () async {
        // arrange
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(fixture('product_single.json'), 200),
        );

        // act
        final result = await dataSource.getProductById(tId);

        // assert
        expect(result, equals(tProductModel));
      },
    );

    test(
      'should throw ServerException when response code is not 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response('Something went wrong', 404));

        // act
        final call = dataSource.getProductById;

        // assert
        expect(() => call(tId), throwsA(isA<ServerException>()));
      },
    );
  });

  group('createProduct', () {
    final tProductModel = ProductModel.fromJson(
      json.decode(fixture('product_single.json')),
    );

    test(
      'should perform a POST request with product JSON to /products and application/json header',
      () async {
        // arrange
        when(
          mockHttpClient.post(
            Uri.parse(
              'https://g5-flutter-learning-path-be.onrender.com/products',
            ),
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer(
          (_) async => http.Response(fixture('product_single.json'), 201),
        );

        // act
        await dataSource.createProduct(product: tProductModel);

        // assert
        verify(
          mockHttpClient.post(
            Uri.parse(
              'https://g5-flutter-learning-path-be.onrender.com/products',
            ),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(tProductModel.toJson()),
          ),
        );
      },
    );

    test(
      'should return ProductModel when response code is 201 (created)',
      () async {
        // arrange
        when(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer(
          (_) async => http.Response(fixture('product_single.json'), 201),
        );

        // act
        final result = await dataSource.createProduct(product: tProductModel);

        // assert
        expect(result, equals(tProductModel));
      },
    );

    test(
      'should throw ServerException when response code is not 201',
      () async {
        // arrange
        when(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer((_) async => http.Response('Error', 400));

        // act
        final call = dataSource.createProduct;

        // assert
        expect(
          () => call(product: tProductModel),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });
  group('updateProduct', () {
    final tProductModel = ProductModel.fromJson(
      json.decode(fixture('product_single.json')),
    );
    final tId = tProductModel.id;

    test(
      'should perform a PUT request with product JSON to /products/{id} and application/json header',
      () async {
        // arrange
        when(
          mockHttpClient.put(
            Uri.parse(
              'https://g5-flutter-learning-path-be.onrender.com/products/$tId',
            ),
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer(
          (_) async => http.Response(fixture('product_single.json'), 200),
        );

        // act
        await dataSource.updateProduct(product: tProductModel);

        // assert
        verify(
          mockHttpClient.put(
            Uri.parse(
              'https://g5-flutter-learning-path-be.onrender.com/products/$tId',
            ),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(tProductModel.toJson()),
          ),
        );
      },
    );

    test(
      'should return ProductModel when response code is 200 (success)',
      () async {
        // arrange
        when(
          mockHttpClient.put(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer(
          (_) async => http.Response(fixture('product_single.json'), 200),
        );

        // act
        final result = await dataSource.updateProduct(product: tProductModel);

        // assert
        expect(result, equals(tProductModel));
      },
    );

    test(
      'should throw ServerException when response code is not 200',
      () async {
        // arrange
        when(
          mockHttpClient.put(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer((_) async => http.Response('Error', 400));

        // act
        final call = dataSource.updateProduct;

        // assert
        expect(
          () => call(product: tProductModel),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });

  group('deleteProduct', () {
    final tId = 'p1';

    test(
      'should perform a DELETE request on /products/{id} with application/json header',
      () async {
        // arrange
        when(
          mockHttpClient.delete(
            Uri.parse(
              'https://g5-flutter-learning-path-be.onrender.com/products/$tId',
            ),
            headers: anyNamed('headers'),
          ),
        ).thenAnswer((_) async => http.Response('', 204));

        // act
        await dataSource.deleteProduct(tId);

        // assert
        verify(
          mockHttpClient.delete(
            Uri.parse(
              'https://g5-flutter-learning-path-be.onrender.com/products/$tId',
            ),
            headers: {'Content-Type': 'application/json'},
          ),
        );
      },
    );

    test(
      'should throw ServerException when response code is not 204',
      () async {
        // arrange
        when(
          mockHttpClient.delete(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response('Error', 404));

        // act
        final call = dataSource.deleteProduct;

        // assert
        expect(() => call(tId), throwsA(isA<ServerException>()));
      },
    );
  });

}
