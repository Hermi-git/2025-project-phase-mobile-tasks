import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermela_andargie/core/errors/failures.dart';
import 'package:hermela_andargie/features/products/domain/repositories/product_repository.dart';
import 'package:hermela_andargie/features/products/domain/usecases/delete_product.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'delete_product_test.mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  late DeleteProductUseCase usecase;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
    usecase = DeleteProductUseCase(mockProductRepository);
  });

  const tId = '123';

  final params = DeleteProductParams(id: tId);

  test('should delete the product via repository', () async {
    // arrange
    when(
      mockProductRepository.deleteProduct(tId),
    ).thenAnswer((_) async => const Right(null));

    // act
    final result = await usecase(params);

    // assert
    expect(result, const Right(null));
    verify(mockProductRepository.deleteProduct(tId)).called(1);
    verifyNoMoreInteractions(mockProductRepository);
  });

  test('should return ServerFailure when deletion fails', () async {
    // arrange
    when(
      mockProductRepository.deleteProduct(tId),
    ).thenAnswer((_) async => Left(ServerFailure()));

    // act
    final result = await usecase(params);

    // assert
    expect(result, Left(ServerFailure()));
    verify(mockProductRepository.deleteProduct(tId)).called(1);
    verifyNoMoreInteractions(mockProductRepository);
  });
}
