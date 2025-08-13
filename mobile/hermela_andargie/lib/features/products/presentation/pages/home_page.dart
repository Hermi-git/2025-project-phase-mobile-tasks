import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/custom_route.dart';
import '../../domain/entities/product.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';
import '../widgets/app_button.dart';
import '../widgets/product_card.dart';
import 'add_update_page.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductBloc>().add(LoadAllProductsEvent());
    });
  }

  void _navigateToAddProduct() async {
    final result = await Navigator.of(
      context,
    ).push(createFadeRoute(const AddUpdatePage()));

    if (result is Product) {
      context.read<ProductBloc>().add(CreateProductEvent(result));
    }
  }

  void _navigateToDetails(Product product) async {
    final result = await Navigator.of(
      context,
    ).push(createFadeRoute(DetailedPage(product: product)));

    if (result == 'delete') {
      context.read<ProductBloc>().add(DeleteProductEvent(product.id));
    } else if (result is Product) {
      context.read<ProductBloc>().add(UpdateProductEvent(result));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3F8),
      floatingActionButton: AppButton(
        label: 'Add Product',
        onPressed: _navigateToAddProduct,
        color: Colors.deepPurple,
        isFullWidth: false, // Small floating style
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: BlocListener<ProductBloc, ProductState>(
            listenWhen:
                (prev, curr) =>
                    curr is LoadedSingleProductState ||
                    (prev is! ProductInitialState &&
                        curr is ProductInitialState),
            listener: (context, state) {
              if (state is LoadedSingleProductState ||
                  state is ProductInitialState) {
                context.read<ProductBloc>().add(LoadAllProductsEvent());
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'July 20, 2025',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              'Hello, Yohannes',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.notifications_none,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Title + Search
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Available Products',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.search, color: Colors.grey),
                  ],
                ),

                const SizedBox(height: 16),

                // Product List
                Expanded(
                  child: BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      if (state is ProductLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is LoadedAllProductsState) {
                        final products = state.products;
                        if (products.isEmpty) {
                          return const Center(
                            child: Text('No products available.'),
                          );
                        }

                        return ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return ProductCard(
                              product: product,
                              onTap: () => _navigateToDetails(product),
                              onEdit: () => _navigateToDetails(product),
                              onDelete: () {
                                context.read<ProductBloc>().add(
                                  DeleteProductEvent(product.id),
                                );
                              },
                            );
                          },
                        );
                      } else if (state is ProductErrorState) {
                        return Center(child: Text(state.message));
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
