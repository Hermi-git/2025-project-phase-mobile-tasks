import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermela_andargie/core/errors/failures.dart';
import 'package:hermela_andargie/features/products/domain/entities/product.dart';
import 'package:hermela_andargie/features/products/domain/repositories/product_repository.dart';
import 'package:hermela_andargie/features/products/domain/usecases/insert_product.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'create_product_test.mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  late InsertProductUseCase usecase;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
    usecase = InsertProductUseCase(mockProductRepository);
  });

  const tProduct = Product(
    id: '1',
    name: 'Generic Product',
    description: 'Generic Description',
    imageUrl: 'https://example.com/image.png',
    price: 99.99,
  );

  final params = InsertProductParams(product: tProduct);

  test('should create a product through the repository', () async {
    // arrange
    when(
      mockProductRepository.createProduct(product: tProduct),
    ).thenAnswer((_) async => Right(tProduct));

    // act
    final result = await usecase(params);

    // assert
    expect(result, Right(tProduct));
    verify(mockProductRepository.createProduct(product: tProduct)).called(1);
    verifyNoMoreInteractions(mockProductRepository);
  });

  test('should return ServerFailure when repository fails', () async {
    // arrange
    when(
      mockProductRepository.createProduct(product: tProduct),
    ).thenAnswer((_) async => Left(ServerFailure()));

    // act
    final result = await usecase(params);

    // assert
    expect(result, Left(ServerFailure()));
    verify(mockProductRepository.createProduct(product: tProduct)).called(1);
    verifyNoMoreInteractions(mockProductRepository);
  });
}
