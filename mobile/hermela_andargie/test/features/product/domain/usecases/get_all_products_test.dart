import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermela_andargie/core/errors/failures.dart';
import 'package:hermela_andargie/core/usecases/usecase.dart';
import 'package:hermela_andargie/features/products/domain/entities/product.dart';
import 'package:hermela_andargie/features/products/domain/repositories/product_repository.dart';
import 'package:hermela_andargie/features/products/domain/usecases/get_all_products.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_all_products_test.mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  late GetAllProductsUseCase usecase;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
    usecase = GetAllProductsUseCase(mockProductRepository);
  });

  final tProducts = [
    const Product(
      id: '1',
      name: 'Sample Product 1',
      description: 'Sample description 1',
      imageUrl: 'https://example.com/image1.png',
      price: 9.99,
    ),
    const Product(
      id: '2',
      name: 'Sample Product 2',
      description: 'Sample description 2',
      imageUrl: 'https://example.com/image2.png',
      price: 19.99,
    ),
  ];

  test('should return product list when call is successful', () async {
    // arrange
    when(
      mockProductRepository.getAllProducts(),
    ).thenAnswer((_) async => Right(tProducts));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, Right(tProducts));
    verify(mockProductRepository.getAllProducts()).called(1);
    verifyNoMoreInteractions(mockProductRepository);
  });

  test('should return ServerFailure when repository throws', () async {
    // arrange
    when(
      mockProductRepository.getAllProducts(),
    ).thenAnswer((_) async => Left(ServerFailure()));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, Left(ServerFailure()));
    verify(mockProductRepository.getAllProducts()).called(1);
    verifyNoMoreInteractions(mockProductRepository);
  });
}
