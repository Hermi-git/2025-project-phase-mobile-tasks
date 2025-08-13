import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/custom_route.dart';
import '../../domain/entities/product.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../widgets/product_card.dart';
import 'add_update_page.dart';

class DetailedPage extends StatelessWidget {
  final Product product;

  const DetailedPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3F8),
      body: SafeArea(
        child: Column(
          children: [
            // Reusable product card
            ProductCard(
              product: product,
              onEdit: () async {
                final result = await Navigator.of(
                  context,
                ).push(createFadeRoute(AddUpdatePage(product: product)));

                if (result is Product) {
                  context.read<ProductBloc>().add(UpdateProductEvent(result));
                  Navigator.pop(context, result);
                }
              },
              onDelete: () {
                context.read<ProductBloc>().add(DeleteProductEvent(product.id));
                Navigator.pop(context, 'delete');
              },
            ),

            const Spacer(),

            // Bottom Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        context.read<ProductBloc>().add(
                          DeleteProductEvent(product.id),
                        );
                        Navigator.pop(context, 'delete');
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('DELETE'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.of(context).push(
                          createFadeRoute(AddUpdatePage(product: product)),
                        );

                        if (result is Product) {
                          context.read<ProductBloc>().add(
                            UpdateProductEvent(result),
                          );
                          Navigator.pop(context, result);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('UPDATE'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
