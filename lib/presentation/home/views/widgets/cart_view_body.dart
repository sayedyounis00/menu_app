import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/presentation/admin_panel/view/widgets/failure_screen.dart';
import 'package:menu_app/presentation/home/cart/cart_cubit.dart';
import 'package:menu_app/presentation/home/views/widgets/cartt_item.dart';

class CartViewBody extends StatelessWidget {
  const CartViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        BlocProvider.of<CartCubit>(context).getAllCartItems();
        return Future.delayed(const Duration(seconds: 1));
      },
      child: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartItemLoaded) {
            return GridView.builder(
                itemCount: state.cartItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) =>
                    CarttItem(cartItem: state.cartItems[index], index: index));
          } else if (state is CartError) {
            return FailureScreen(onPressed: () {
              BlocProvider.of<CartCubit>(context).getAllCartItems();
            });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
