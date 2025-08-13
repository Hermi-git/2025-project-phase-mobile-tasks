import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';
import '../widgets/product_card.dart';
import '../widgets/app_button.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  double _priceValue = 50;
  String _searchQuery = '';
  String _category = '';

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadAllProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top Bar
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Search Product',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              /// Search Input + Filter Icon
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() => _searchQuery = value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.filter_list, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              /// Products from Bloc
              BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is LoadedAllProductsState) {
                    final filteredProducts =
                        state.products.where((p) {
                          final matchesSearch = p.name.toLowerCase().contains(
                            _searchQuery.toLowerCase(),
                          );
                          final matchesPrice = p.price <= _priceValue;
                          final matchesCategory =
                              _category.isEmpty ||
                              p.description.toLowerCase().contains(
                                _category.toLowerCase(),
                              );
                          return matchesSearch &&
                              matchesPrice &&
                              matchesCategory;
                        }).toList();

                    if (filteredProducts.isEmpty) {
                      return const Center(child: Text('No products found.'));
                    }

                    return Column(
                      children:
                          filteredProducts.map((p) {
                            return ProductCard(
                              imageUrl: p.imageUrl,
                              name: p.name,
                              category: p.description,
                              price: p.price,
                            );
                          }).toList(),
                    );
                  } else if (state is ProductErrorState) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return const SizedBox.shrink();
                },
              ),

              const SizedBox(height: 24),

              /// Filter Form
              TextField(
                onChanged: (value) => setState(() => _category = value),
                decoration: const InputDecoration(
                  labelText: 'Category',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Price'),
              Slider(
                value: _priceValue,
                onChanged: (value) => setState(() => _priceValue = value),
                min: 0,
                max: 200,
                activeColor: Colors.deepPurple,
                inactiveColor: Colors.grey.shade300,
              ),
              const SizedBox(height: 16),
              AppButton(
                label: 'APPLY',
                onPressed: () {
                  // filtering is handled above via setState
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
