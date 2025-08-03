import 'dart:convert';


import 'package:flutter_test/flutter_test.dart';
import 'package:hermela_andargie/core/errors/exception.dart';
import 'package:hermela_andargie/features/products/data/datasources/product_local_data_source_impl.dart';
import 'package:hermela_andargie/features/products/data/models/product_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../fixtures/fixture_reader.dart';

@GenerateMocks([SharedPreferences])
import 'product_local_data_source_test.mocks.dart';

void main() {
  late ProductLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = ProductLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  // Load JSON string from fixture file
  final tProductListJsonString = fixture('product_cached.json');

  // Decode JSON list to List<ProductModel>
  final List<dynamic> jsonList = json.decode(tProductListJsonString);
  final tProductModelList =
      jsonList.map((jsonItem) => ProductModel.fromJson(jsonItem)).toList();

  group('getLastCachedProductList', () {
    test(
      'should return List<ProductModel> from SharedPreferences when cached data exists',
      () async {
        // Arrange
        when(
          mockSharedPreferences.getString(any),
        ).thenReturn(tProductListJsonString);

        // Act
        final result = await dataSource.getLastCachedProductList();

        // Assert
        verify(mockSharedPreferences.getString(CACHED_PRODUCTS));
        expect(result, equals(tProductModelList));
      },
    );

    test('should throw CacheException when there is no cached data', () async {
      // Arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      // Act
      final call = dataSource.getLastCachedProductList;

      // Assert
      expect(() => call(), throwsA(isA<CacheException>()));
    });
  });

  group('cacheProductList', () {
    test(
      'should call SharedPreferences to cache the list of products',
      () async {
        // Arrange
        when(
          mockSharedPreferences.setString(any, any),
        ).thenAnswer((_) async => true);

        // Act
        await dataSource.cacheProductList(tProductModelList);

        // Assert
        final expectedJsonString = json.encode(
          tProductModelList.map((product) => product.toJson()).toList(),
        );
        verify(
          mockSharedPreferences.setString(CACHED_PRODUCTS, expectedJsonString),
        );
      },
    );
  });
}
