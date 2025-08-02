import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermela_andargie/core/errors/failures.dart';
import 'package:hermela_andargie/features/products/domain/entities/product.dart';
import 'package:hermela_andargie/features/products/domain/repositories/product_repository.dart';
import 'package:hermela_andargie/features/products/domain/usecases/update_product.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'update_product_test.mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  late UpdateProductUseCase usecase;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
    usecase = UpdateProductUseCase(mockProductRepository);
  });

  const tProduct = Product(
    id: '1',
    name: 'Updated Product',
    description: 'Updated Description',
    imageUrl: 'https://example.com/updated.png',
    price: 123.45,
  );

  final params = UpdateProductParams(product: tProduct);

  test('should update the product through the repository', () async {
    // arrange
    when(
      mockProductRepository.updateProduct(product: tProduct),
    ).thenAnswer((_) async => Right(tProduct));

    // act
    final result = await usecase(params);

    // assert
    expect(result, Right(tProduct));
    verify(mockProductRepository.updateProduct(product: tProduct)).called(1);
    verifyNoMoreInteractions(mockProductRepository);
  });

  test('should return ServerFailure when repository fails', () async {
    // arrange
    when(
      mockProductRepository.updateProduct(product: tProduct),
    ).thenAnswer((_) async => Left(ServerFailure()));

    // act
    final result = await usecase(params);

    // assert
    expect(result, Left(ServerFailure()));
    verify(mockProductRepository.updateProduct(product: tProduct)).called(1);
    verifyNoMoreInteractions(mockProductRepository);
  });
}
