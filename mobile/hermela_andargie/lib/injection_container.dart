import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/platform/network_info.dart';
import 'core/storage/secure_storage.dart';
import 'core/storage/secure_storage_impl.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/check_authstatus_usecase.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/sign_up_usecase.dart';
import 'features/auth/facad/auth_facade.dart';
import 'features/auth/facad/auth_facade_impl.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/products/data/datasources/product_local_data_source.dart';
import 'features/products/data/datasources/product_local_data_source_impl.dart';
import 'features/products/data/datasources/product_remote_data_source.dart';
import 'features/products/data/datasources/product_remote_data_source_impl.dart';
import 'features/products/data/repositories/product_repository_impl.dart';
import 'features/products/domain/repositories/product_repository.dart';
import 'features/products/domain/usecases/delete_product.dart';
import 'features/products/domain/usecases/get_all_products.dart';
import 'features/products/domain/usecases/get_product.dart';
import 'features/products/domain/usecases/insert_product.dart';
import 'features/products/domain/usecases/update_product.dart';
import 'features/products/presentation/bloc/product_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! External dependencies first
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  sl.registerLazySingleton<http.Client>(() => http.Client());

  sl.registerLazySingleton<InternetConnectionChecker>(
    () => InternetConnectionChecker.createInstance(),
  );

  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! Features - Auth
  // Register SecuredStorage abstraction with implementation (depends on FlutterSecureStorage)
  sl.registerLazySingleton<SecuredStorage>(
    () => SecuredStorageImpl(storage: sl()),
  );

  // Data Sources (depend on http.Client, SharedPreferences, SecuredStorage)
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      client: sl<http.Client>(), // specify type explicitly
      baseUrl: 'https://g5-flutter-learning-path-be.onrender.com/api/v2',
    ),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      securedStorage: sl<SecuredStorage>(),
      sharedPreferences: sl<SharedPreferences>(),
    ),
  );

  // Repository (depends on data sources)
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LogoutUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignUpUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl<AuthRepository>()));

  // Facade
  sl.registerLazySingleton<AuthFacade>(
    () => AuthFacadeImpl(
      loginUseCase: sl<LoginUseCase>(),
      signUpUseCase: sl<SignUpUseCase>(),
      logoutUseCase: sl<LogoutUseCase>(),
      hasTokenUseCase:
          sl<CheckAuthStatusUseCase>(), 
      getUserUseCase: sl<GetCurrentUserUseCase>(),
    ),
  );

  // Bloc
  sl.registerFactory(() => AuthBloc(authFacade: sl<AuthFacade>()));

  //! Features - Product
  // Data Sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(client: sl<http.Client>()),
  );

  sl.registerLazySingleton<ProductLocalDataSource>(
    () =>
        ProductLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl<ProductRemoteDataSource>(),
      localDataSource: sl<ProductLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(
    () => GetAllProductsUseCase(sl<ProductRepository>()),
  );
  sl.registerLazySingleton(() => GetProductUseCase(sl<ProductRepository>()));
  sl.registerLazySingleton(() => InsertProductUseCase(sl<ProductRepository>()));
  sl.registerLazySingleton(() => UpdateProductUseCase(sl<ProductRepository>()));
  sl.registerLazySingleton(() => DeleteProductUseCase(sl<ProductRepository>()));

  // Bloc
  sl.registerFactory(
    () => ProductBloc(
      getAllProducts: sl<GetAllProductsUseCase>(),
      getProduct: sl<GetProductUseCase>(),
      insertProduct: sl<InsertProductUseCase>(),
      updateProduct: sl<UpdateProductUseCase>(),
      deleteProduct: sl<DeleteProductUseCase>(),
    ),
  );
}
