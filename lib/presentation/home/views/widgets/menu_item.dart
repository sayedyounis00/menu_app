import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/presentation/home/menu/menu_cubit.dart';
import 'package:menu_app/presentation/home/data/menu_object.dart';
import 'package:menu_app/presentation/home/views/widgets/custum_text.dart';
import 'package:menu_app/presentation/home/views/widgets/order_count.dart';

class MenuItem extends StatelessWidget {
  final MenuObject menuItem;
  const MenuItem({super.key, required this.menuItem});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              alignment: Alignment.topRight,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Fixed height container for image
                    SizedBox(
                      height: constraints.maxWidth * 0.6, // Aspect ratio ~1:1.4
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: menuItem.image,
                          width: double.infinity,
                          // fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: theme.colorScheme.surface,
                            child: const Center(
                                child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: theme.colorScheme.errorContainer,
                            child: const Icon(Icons.fastfood, size: 40),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Item name and price
                    CustumText(
                      text: menuItem.name,
                      size: 15,
                      fontWeight: FontWeight.bold,
                      // maxLines: 1,
                      // overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    CustumText(
                      text: "${menuItem.price}\$",
                      size: 16,
                      // color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    // Add to cart button
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        onPressed: () {
                          BlocProvider.of<MenuCubit>(context)
                              .addToCartAndUpdateCount(menuItem);
                        },
                        icon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Order count badge
                BlocBuilder<MenuCubit, MenuState>(
                  builder: (context, state) {
                    return OrderCount(count: menuItem.count);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
