import 'package:flutter_test/flutter_test.dart';
import 'package:hermela_andargie/core/errors/exception.dart';
import 'package:hermela_andargie/features/products/data/models/product_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'package:hermela_andargie/core/errors/failures.dart';
import 'package:hermela_andargie/features/products/data/datasources/product_local_data_source.dart';
import 'package:hermela_andargie/features/products/data/datasources/product_remote_data_source.dart';
import 'package:hermela_andargie/core/platform/network_info.dart';
import 'package:hermela_andargie/features/products/data/repositories/product_repository_impl.dart';
import 'package:hermela_andargie/features/products/domain/entities/product.dart';

import 'product_repository_impl_test.mocks.dart';
@GenerateMocks([
  ProductLocalDataSource, ProductRemoteDataSource, NetworkInfo
])
void main() {
  late ProductRepositoryImpl repository;
  late MockProductRemoteDataSource mockRemoteDataSource;
  late MockProductLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockProductRemoteDataSource();
    mockLocalDataSource = MockProductLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ProductRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getAllProducts', () {
    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockRemoteDataSource.getAllProducts(),
      ).thenAnswer((_) async => <ProductModel>[]); 
      // act
      await repository.getAllProducts();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

        final tProductModels = [
          const ProductModel(
            id: '1',
            name: 'Test Product 1',
            description: 'Desc 1',
            imageUrl: 'https://example.com/1.jpg',
            price: 19.99,
          ),
          const ProductModel(
            id: '2',
            name: 'Test Product 2',
            description: 'Desc 2',
            imageUrl: 'https://example.com/2.jpg',
            price: 29.99,
          ),
        ];
        final List<Product> tProducts = tProductModels;

        when(
          mockRemoteDataSource.getAllProducts(),
        ).thenAnswer((_) async => tProductModels);

        // act
        final result = await repository.getAllProducts();

        // assert
        verify(mockRemoteDataSource.getAllProducts());
        expect(result, equals(Right(tProducts)));
      },
    );

    test(
      'should cache the data locally when the call to remote data source is successful',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

        final tProductModels = [
          const ProductModel(
            id: '1',
            name: 'Test Product 1',
            description: 'Desc 1',
            imageUrl: 'https://example.com/1.jpg',
            price: 19.99,
          ),
          const ProductModel(
            id: '2',
            name: 'Test Product 2',
            description: 'Desc 2',
            imageUrl: 'https://example.com/2.jpg',
            price: 29.99,
          ),
        ];

        when(
          mockRemoteDataSource.getAllProducts(),
        ).thenAnswer((_) async => tProductModels);

        // act
        await repository.getAllProducts();

        // assert
        verify(mockRemoteDataSource.getAllProducts());
        verify(
          mockLocalDataSource.cacheProductList(tProductModels),
        ); 
      },
    );

  });

  group('device is offline', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });

    test('should return last locally cached data when present', () async {
      // arrange
      final tProductModels = [
        const ProductModel(
          id: '1',
          name: 'Cached Product',
          description: 'Cached Desc',
          imageUrl: 'https://example.com/img.jpg',
          price: 15.0,
        ),
      ];
      when(
        mockLocalDataSource.getLastCachedProductList(),
      ).thenAnswer((_) async => tProductModels);

      // act
      final result = await repository.getAllProducts();

      // assert
      verifyZeroInteractions(mockRemoteDataSource);
      verify(mockLocalDataSource.getLastCachedProductList());
      expect(result, equals(Right(tProductModels)));
    });

    test('should return CacheFailure when there is no cached data', () async {
      // arrange
      when(
        mockLocalDataSource.getLastCachedProductList(),
      ).thenThrow(CacheException());

      // act
      final result = await repository.getAllProducts();

      // assert
      verifyZeroInteractions(mockRemoteDataSource);
      verify(mockLocalDataSource.getLastCachedProductList());
      expect(result, equals(Left(CacheFailure())));
    });
  });

   group('getProductById', () {
    const tId = '123';
    const tProductModel = ProductModel(
      id: tId,
      name: 'Test Product',
      description: 'Test Description',
      imageUrl: 'https://example.com/image.jpg',
      price: 9.99,
    );
    const Product tProduct = tProductModel;

    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockRemoteDataSource.getProductById(tId),
      ).thenAnswer((_) async => tProductModel);

      // act
      await repository.getProductById(tId);

      // assert
      verify(mockNetworkInfo.isConnected);
    });

    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        const tId = '123';
        const tProductModel = ProductModel(
          id: tId,
          name: 'Test Product',
          description: 'Test Desc',
          imageUrl: 'https://example.com/img.jpg',
          price: 49.99,
        );
        const Product tProduct = tProductModel;

        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          mockRemoteDataSource.getProductById(tId),
        ).thenAnswer((_) async => tProductModel);

        // act
        final result = await repository.getProductById(tId);

        // assert
        verify(mockRemoteDataSource.getProductById(tId));
        expect(result, equals(Right(tProduct)));
      },
    );

    test('should return ServerFailure when remote call fails', () async {
      // arrange
      const tId = '123';
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockRemoteDataSource.getProductById(tId),
      ).thenThrow(ServerException());

      // act
      final result = await repository.getProductById(tId);

      // assert
      verify(mockRemoteDataSource.getProductById(tId));
      expect(result, equals(Left(ServerFailure())));
    });

    test('should return CacheFailure when device is offline', () async {
      // arrange
      const tId = '123';
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // act
      final result = await repository.getProductById(tId);

      // assert
      verifyNever(mockRemoteDataSource.getProductById(any));
      expect(result, equals(Left(CacheFailure())));
    });

  });

  group('createProduct', () {
    final tProductModel = const ProductModel(
      id: '123',
      name: 'Test Product',
      description: 'Test Description',
      imageUrl: 'https://example.com/image.png',
      price: 10.0,
    );

    final ProductModel tProduct = tProductModel;


    test('should check if device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockRemoteDataSource.createProduct(product: anyNamed('product')),
      ).thenAnswer((_) async => tProductModel);

      // act
      await repository.createProduct(product: tProduct);

      // assert
      verify(mockNetworkInfo.isConnected);
    });

    test(
      'should return remote data when call to remote data source is successful',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          mockRemoteDataSource.createProduct(product: anyNamed('product')),
        ).thenAnswer((_) async => tProductModel);

        // act
        final result = await repository.createProduct(product: tProduct);

        // assert
        verify(mockRemoteDataSource.createProduct(product: tProduct));
        expect(result, equals(Right(tProduct)));
      },
    );

    test(
      'should return ServerFailure when call to remote data source throws ServerException',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          mockRemoteDataSource.createProduct(product: anyNamed('product')),
        ).thenThrow(ServerException());

        // act
        final result = await repository.createProduct(product: tProduct);

        // assert
        verify(mockRemoteDataSource.createProduct(product: tProduct));
        expect(result, equals(Left(ServerFailure())));
      },
    );

    test('should return CacheFailure when device is offline', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // act
      final result = await repository.createProduct(product: tProduct);

      // assert
      verifyNever(mockRemoteDataSource.createProduct(product: tProduct));
      expect(result, equals(Left(CacheFailure())));
    });
  });
   
   group('updateProduct', () {
    final tProductModel = const ProductModel(
      id: '123',
      name: 'Updated Product',
      description: 'Updated Description',
      imageUrl: 'https://example.com/image.png',
      price: 20.0,
    );

    final ProductModel tProduct = tProductModel;

    test('should check if device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockRemoteDataSource.updateProduct(product: anyNamed('product')),
      ).thenAnswer((_) async => tProductModel);

      // act
      await repository.updateProduct(product: tProduct);

      // assert
      verify(mockNetworkInfo.isConnected);
    });

    test(
      'should return remote data when call to remote data source is successful',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          mockRemoteDataSource.updateProduct(product: anyNamed('product')),
        ).thenAnswer((_) async => tProductModel);

        // act
        final result = await repository.updateProduct(product: tProduct);

        // assert
        verify(mockRemoteDataSource.updateProduct(product: tProduct));
        expect(result, equals(Right(tProduct)));
      },
    );

    test(
      'should return ServerFailure when call to remote data source throws ServerException',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          mockRemoteDataSource.updateProduct(product: anyNamed('product')),
        ).thenThrow(ServerException());

        // act
        final result = await repository.updateProduct(product: tProduct);

        // assert
        verify(mockRemoteDataSource.updateProduct(product: tProduct));
        expect(result, equals(Left(ServerFailure())));
      },
    );

    test('should return CacheFailure when device is offline', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // act
      final result = await repository.updateProduct(product: tProduct);

      // assert
      verifyNever(mockRemoteDataSource.updateProduct(product: tProduct));
      expect(result, equals(Left(CacheFailure())));
    });
  });

  group('deleteProduct', () {
    const tId = '123';

    test('should check if device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockRemoteDataSource.deleteProduct(tId),
      ).thenAnswer((_) async => Future.value());

      // act
      await repository.deleteProduct(tId);

      // assert
      verify(mockNetworkInfo.isConnected);
    });

    test(
      'should return void when call to remote data source is successful',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          mockRemoteDataSource.deleteProduct(tId),
        ).thenAnswer((_) async => Future.value());

        // act
        final result = await repository.deleteProduct(tId);

        // assert
        verify(mockRemoteDataSource.deleteProduct(tId));
        expect(result, equals(const Right(null)));
      },
    );

    test(
      'should return ServerFailure when call to remote data source throws ServerException',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          mockRemoteDataSource.deleteProduct(tId),
        ).thenThrow(ServerException());

        // act
        final result = await repository.deleteProduct(tId);

        // assert
        verify(mockRemoteDataSource.deleteProduct(tId));
        expect(result, equals(Left(ServerFailure())));
      },
    );

    test('should return CacheFailure when device is offline', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // act
      final result = await repository.deleteProduct(tId);

      // assert
      verifyNever(mockRemoteDataSource.deleteProduct(tId));
      expect(result, equals(Left(CacheFailure())));
    });
  });


}

