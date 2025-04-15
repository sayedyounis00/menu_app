import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/presentation/home/cart/cart_cubit.dart';
import 'package:menu_app/presentation/home/views/widgets/cartt_item.dart';

class CartViewBody extends StatelessWidget {
  const CartViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state is CartItemLoaded) {
          log(state.cartItems.length.toString());
          return GridView.builder(
              itemCount: state.cartItems.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) =>
                  CarttItem(cartItem: state.cartItems[index], index: index));
        } else if (state is CartItemLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const Text("Error");
        }
      },
    );
  }
}
