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

    return Column(
      children: [
        Expanded(
          child: GridView.builder(
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
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                'Total: ${BlocProvider.of<CartCubit>(context).totalPrice} DB',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => _showPaymentOptions(context),
                child: const Text('Checkout'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_cart_outlined,
              size: 64, color: Colors.grey),
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

  void _showPaymentOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Payment Method'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.money),
                  title: const Text('CASH'),
                  onTap: () {
                    Navigator.pop(context); // Close selection dialog
                    _showPaymentSuccess(context, 'CASH');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.account_balance),
                  title: const Text('BENFIT'),
                  onTap: () {
                    Navigator.pop(context); // Close selection dialog
                    _showPaymentSuccess(context, 'BENFIT');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.credit_card),
                  title: const Text('VISA'),
                  onTap: () {
                    Navigator.pop(context); // Close selection dialog
                    _showPaymentSuccess(context, 'VISA');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPaymentSuccess(BuildContext context, String method) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context); // Auto-close after 2 seconds
          // Add any post-payment logic here
        });

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Payment Successful!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Paid via $method',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
