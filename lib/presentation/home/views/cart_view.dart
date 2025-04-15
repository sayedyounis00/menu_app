import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/presentation/home/cubit/menu_cubit.dart';
import 'package:menu_app/presentation/home/views/widgets/cartt_item.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = BlocProvider.of<MenuCubit>(context).cartItems;

    return Scaffold(
      body: BlocBuilder<MenuCubit, MenuState>(
        builder: (context, state) {
          return GridView.builder(
              itemCount: cart.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) =>
                  CarttItem(cartItem: cart[index], index: index),
            );
        },
      ),
    );
  }
}
