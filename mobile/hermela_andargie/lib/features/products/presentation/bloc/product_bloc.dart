import 'package:bloc/bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/get_all_products.dart';
import '../../domain/usecases/get_product.dart';
import '../../domain/usecases/insert_product.dart';
import '../../domain/usecases/update_product.dart';
import 'product_event.dart';
import 'product_state.dart'; 

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetAllProductsUseCase getAllProducts;
  final GetProductUseCase getProduct;
  final InsertProductUseCase insertProduct;
  final UpdateProductUseCase updateProduct;
  final DeleteProductUseCase deleteProduct;

  ProductBloc({
    required this.getAllProducts,
    required this.getProduct,
    required this.insertProduct,
    required this.updateProduct,
    required this.deleteProduct,
  }) : super(ProductInitialState()) {
    // Handle LoadAllProductsEvent
    on<LoadAllProductsEvent>((event, emit) async {
      emit(ProductLoadingState());

      final result = await getAllProducts(NoParams());

      result.fold(
        (failure) => emit(ProductErrorState(_mapFailureToMessage(failure))),
        (products) => emit(LoadedAllProductsState(products)),
      );
    });

    on<GetSingleProductEvent>((event, emit) async {
      emit(ProductLoadingState());

      final result = await getProduct.call(GetProductParams(id: event.id));

      result.fold(
        (failure) => emit(const ProductErrorState('Failed to load product')),
        (product) => emit(LoadedSingleProductState(product)),
      );
    });

    on<CreateProductEvent>((event, emit) async {
      emit(ProductLoadingState());

      final result = await insertProduct(
        InsertProductParams(product: event.product),
      );

      result.fold(
        (failure) => emit(ProductErrorState(failure.toString())),
        (product) => emit(LoadedSingleProductState(product)),
      );
    });

    on<UpdateProductEvent>((event, emit) async {
      emit(ProductLoadingState());
      final result = await updateProduct(
        UpdateProductParams(product: event.product),
      );
      result.fold(
        (failure) => emit(ProductErrorState(failure.toString())),
        (product) => emit(LoadedSingleProductState(product)),
      );
    });

    on<DeleteProductEvent>((event, emit) async {
      emit(ProductLoadingState());
      final result = await deleteProduct(DeleteProductParams(id: event.id));
      result.fold(
        (failure) => emit(ProductErrorState(failure.toString())),
        (_) => emit(ProductInitialState()),
      );
    });



  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) return 'Server failure';
    if (failure is CacheFailure) return 'Cache failure';
    if (failure is NoConnectionFailure) return 'No internet connection';
    if (failure is NotFoundFailure) return failure.message;
    if (failure is DuplicateFailure) return failure.message;
    return 'Unexpected error';
  }
}
