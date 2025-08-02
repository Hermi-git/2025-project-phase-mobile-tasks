import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermela_andargie/core/errors/failures.dart';
import 'package:hermela_andargie/features/products/domain/entities/product.dart';
import 'package:hermela_andargie/features/products/domain/repositories/product_repository.dart';
import 'package:hermela_andargie/features/products/domain/usecases/get_product.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_product_test.mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  late GetProductUseCase usecase;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
    usecase = GetProductUseCase(mockProductRepository);
  });

  const tProduct = Product(
    id: '1',
    name: 'Test Product',
    description: 'Test Description',
    imageUrl: 'https://example.com/test.png',
    price: 15.0,
  );

  var tParams = GetProductParams(id: '1');

  test('should get a product by id from the repository', () async {
    // arrange
    when(
      mockProductRepository.getProductById(any),
    ).thenAnswer((_) async => const Right(tProduct));

    // act
    final result = await usecase(tParams);

    // assert
    expect(result, const Right(tProduct));
    verify(mockProductRepository.getProductById(tParams.id)).called(1);
    verifyNoMoreInteractions(mockProductRepository);
  });

  test('should return ServerFailure when repository fails', () async {
    // arrange
    when(
      mockProductRepository.getProductById(any),
    ).thenAnswer((_) async => Left(ServerFailure()));

    // act
    final result = await usecase(tParams);

    // assert
    expect(result, Left(ServerFailure()));
    verify(mockProductRepository.getProductById(tParams.id)).called(1);
    verifyNoMoreInteractions(mockProductRepository);
  });
}
