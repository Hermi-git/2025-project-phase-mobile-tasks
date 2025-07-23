import 'package:flutter/material.dart';
import 'package:hermela_andargie/models/product.dart';
import 'package:hermela_andargie/screens/add_update_page.dart';
import 'package:hermela_andargie/screens/detailed_page.dart';
import 'screens/home_page.dart';

//named routes
const String homeRoute = '/';
const String addUpdateRoute = '/add-update';
const String detailRoute = '/detail';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Commerce App',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      initialRoute: homeRoute,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case homeRoute:
            return MaterialPageRoute(builder: (_) => const HomePage());
          case addUpdateRoute:
            return MaterialPageRoute(builder: (_) => const AddUpdatePage());
          case detailRoute:
            final product = settings.arguments as Product;
            return MaterialPageRoute(
              builder: (_) => DetailedPage(product: product),
            );
          default:
            return null;
        }
      },
    );
  }
}
