import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/products/data/models/product_model.dart';
import 'features/products/presentation/bloc/product_bloc.dart';
import 'features/products/presentation/pages/add_update_page.dart';
import 'features/products/presentation/pages/detail_page.dart';
import 'features/products/presentation/pages/home_page.dart';
import 'features/products/presentation/pages/search_page.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider<ProductBloc>(create: (_) => sl<ProductBloc>())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Commerce App',
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        initialRoute: "/",
        routes: {
          "/": (context) => const HomePage(),
          "/searchPage": (context) => const SearchPage(),
        },
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/details':
              final product = settings.arguments as ProductModel;
              return MaterialPageRoute(
                builder: (_) => DetailedPage(product: product),
              );

            case '/addUpdatePage':
              final args = settings.arguments;
              if (args is Map<String, dynamic>) {
                return MaterialPageRoute(
                  builder:
                      (_) => AddUpdatePage(
                        product: args['product'],
                      ),
                );
              }
              return MaterialPageRoute(
                builder:
                    (_) => const Scaffold(
                      body: Center(child: Text('Invalid or missing arguments')),
                    ),
              );

            default:
              return null;
          }
        },
      ),
    );
  }
}
