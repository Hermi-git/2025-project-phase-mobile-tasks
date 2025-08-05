import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermela_andargie/features/products/domain/entities/product.dart';
import 'package:hermela_andargie/features/products/domain/usecases/delete_product.dart';
import 'package:hermela_andargie/features/products/domain/usecases/get_all_products.dart';
import 'package:hermela_andargie/features/products/domain/usecases/get_product.dart';
import 'package:hermela_andargie/features/products/domain/usecases/insert_product.dart';
import 'package:hermela_andargie/features/products/domain/usecases/update_product.dart';
import 'package:hermela_andargie/features/products/presentation/bloc/product_bloc.dart';
import 'package:hermela_andargie/features/products/presentation/bloc/product_event.dart';
import 'package:hermela_andargie/features/products/presentation/bloc/product_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'product_bloc_test.mocks.dart';

@GenerateMocks([
  GetAllProductsUseCase,
  GetProductUseCase,
  InsertProductUseCase,
  UpdateProductUseCase,
  DeleteProductUseCase,
])


late MockGetAllProductsUseCase mockGetAllProducts;
late MockGetProductUseCase mockGetProduct;
late MockInsertProductUseCase mockInsertProduct;
late MockUpdateProductUseCase mockUpdateProduct;
late MockDeleteProductUseCase mockDeleteProduct;


void main() {
  late ProductBloc bloc;

  final tProduct = const Product(
    id: '1',
    name: 'Test Product',
    description: 'A test product',
    imageUrl: 'http://example.com/image.jpg',
    price: 99.99,
  );

  final tProducts = [tProduct]; 

  setUp(() {
    mockGetAllProducts = MockGetAllProductsUseCase();
    mockGetProduct = MockGetProductUseCase();
    mockInsertProduct = MockInsertProductUseCase();
    mockUpdateProduct = MockUpdateProductUseCase();
    mockDeleteProduct = MockDeleteProductUseCase();

    bloc = ProductBloc(
      getAllProducts: mockGetAllProducts,
      getProduct: mockGetProduct,
      insertProduct: mockInsertProduct,
      updateProduct: mockUpdateProduct,
      deleteProduct: mockDeleteProduct,
    );
  });

  blocTest<ProductBloc, ProductState>(
    'emits [ProductLoadingState, LoadedAllProductsState] when LoadAllProductsEvent is added and useCase succeeds',
    build: () {
      when(mockGetAllProducts(any)).thenAnswer((_) async => Right(tProducts));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadAllProductsEvent()),
    expect: () => [ProductLoadingState(), LoadedAllProductsState(tProducts)],
    verify: (_) {
      verify(mockGetAllProducts(any)).called(1);
    },
  );

    group('GetSingleProductEvent', () {
   
    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoadingState, LoadedSingleProductState] when GetSingleProductEvent is added and useCase succeeds',
      build: () {
        when(mockGetProduct.call(any)).thenAnswer((_) async => Right(tProduct));
        return bloc;
      },
      act: (bloc) => bloc.add(const GetSingleProductEvent('1')),
      expect: () => [ProductLoadingState(), LoadedSingleProductState(tProduct)],
      verify: (_) {
        verify(mockGetProduct.call(const GetProductParams(id: '1'))).called(1);
      },
    );
  });

  blocTest<ProductBloc, ProductState>(
    'emits [ProductLoadingState, LoadedSingleProductState] when CreateProductEvent is added and useCase succeeds',
    build: () {
      when(mockInsertProduct(any)).thenAnswer((_) async => Right(tProduct));
      return bloc;
    },
    act: (bloc) => bloc.add(CreateProductEvent(tProduct)),
    expect: () => [ProductLoadingState(), LoadedSingleProductState(tProduct)],
    verify: (_) {
      verify(
        mockInsertProduct(InsertProductParams(product: tProduct)),
      ).called(1);
    },
  );

  blocTest<ProductBloc, ProductState>(
    'emits [ProductLoadingState, LoadedSingleProductState] when UpdateProductEvent is added and useCase succeeds',
    build: () {
      when(mockUpdateProduct(any)).thenAnswer((_) async => Right(tProduct));
      return bloc;
    },
    act: (bloc) => bloc.add(UpdateProductEvent(tProduct)),
    expect: () => [ProductLoadingState(), LoadedSingleProductState(tProduct)],
    verify: (_) {
      verify(
        mockUpdateProduct(UpdateProductParams(product: tProduct)),
      ).called(1);
    },
  );

  blocTest<ProductBloc, ProductState>(
    'emits [ProductLoadingState, ProductInitialState] when DeleteProductEvent is added and usecase succeeds',
    build: () {
      when(mockDeleteProduct(any)).thenAnswer((_) async => const Right(null));
      return bloc;
    },
    act: (bloc) => bloc.add(const DeleteProductEvent('1')),
    expect: () => [ProductLoadingState(), ProductInitialState()],
    verify: (_) {
      verify(mockDeleteProduct(DeleteProductParams(id: '1'))).called(1);
    },
  );


}
