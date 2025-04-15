import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/presentation/cubit/menu_cubit.dart';
import 'package:menu_app/presentation/data/menu_item.dart';
import 'package:menu_app/presentation/views/widgets/custum_text.dart';

class CarttItem extends StatelessWidget {
  final MenuObject cartItem;
  final int index;
  const CarttItem({super.key, required this.index, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 145, 73, 1),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Image.asset(
              cartItem.image,
              height: size.height * .1,
              width: size.width * .3,
            ),
            const Spacer(),
            Row(
              children: [
                Column(
                  children: [
                    CustumText(
                      text: cartItem.name,
                      size: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    CustumText(
                      text: "${cartItem.count}",
                      size: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      BlocProvider.of<MenuCubit>(context)
                          .removeFromCart(index, cartItem);
                    },
                    icon: const Icon(
                      Icons.remove_circle_outline,
                      size: 40,
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
