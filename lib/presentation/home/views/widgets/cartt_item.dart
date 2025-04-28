import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/presentation/home/cart/cart_cubit.dart';
import 'package:menu_app/presentation/home/data/menu_object.dart';
import 'package:menu_app/presentation/home/views/widgets/custum_text.dart';

class CartItem extends StatelessWidget {
  final MenuObject cartItem;
  final int index;
  const CartItem({super.key, required this.index, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: size.height * 0.094,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: cartItem.image,
                    width: double.infinity,
                    placeholder: (context, url) => Container(
                      color: theme.colorScheme.surface,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: theme.colorScheme.errorContainer,
                      child: const Icon(Icons.fastfood, size: 40),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Item name and quantity
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustumText(
                          text: cartItem.name,
                          size: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 4),
                        CustumText(
                          fontWeight: FontWeight.bold,
                          text: "Quantity: ${cartItem.count}",
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                  // Remove button
                  IconButton(
                    onPressed: () {
                      BlocProvider.of<CartCubit>(context)
                          .removeFromCartAndUpdateCount(cartItem.id, cartItem);
                    },
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.remove,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
              // Price information
              Align(
                alignment: Alignment.centerRight,
                child: CustumText(
                  text: "${cartItem.price}DB",
                  size: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
