import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/presentation/admin_panel/view/widgets/failure_screen.dart';
import 'package:menu_app/presentation/home/cart/cart_cubit.dart';
import 'package:menu_app/presentation/home/data/menu_object.dart';
import 'package:menu_app/presentation/home/views/widgets/cartt_item.dart';

class CartViewBody extends StatefulWidget {
  const CartViewBody({super.key});

  @override
  State<CartViewBody> createState() => _CartViewBodyState();
}

class _CartViewBodyState extends State<CartViewBody> {
  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    await BlocProvider.of<CartCubit>(context).getAllCartItems();
  }

  Future<void> _refreshCart() async {
    await BlocProvider.of<CartCubit>(context).getAllCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartCubit, CartState>(
      listener: (context, state) {
        if (state is CartError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errMessage),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      child: RefreshIndicator(
        onRefresh: _refreshCart,
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            return _buildContent(state);
          },
        ),
      ),
    );
  }

  Widget _buildContent(CartState state) {
    if (state is CartLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is CartLoaded) {
      return _buildCartContent(state.cartItems);
    } else if (state is CartError) {
      return FailureScreen(
        errorMessage: state.errMessage,
        onRetry: _refreshCart,
      );
    } else if (state is CartEmpty) {
      return _buildEmptyState();
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildCartContent(List<MenuObject> cartItems) {
    if (cartItems.isEmpty) {
      return _buildEmptyState();
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: cartItems.length,
      itemBuilder: (context, index) => CartItem(
        cartItem: cartItems[index],
        index: index,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Add some delicious items to get started',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _refreshCart,
            child: const Text('Refresh Cart'),
          ),
        ],
      ),
    );
  }
}