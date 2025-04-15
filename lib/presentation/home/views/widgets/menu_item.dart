import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/presentation/home/cubit/menu_cubit.dart';
import 'package:menu_app/presentation/home/data/menu_item.dart';
import 'package:menu_app/presentation/home/views/widgets/custum_text.dart';
import 'package:menu_app/presentation/home/views/widgets/order_count.dart';

class MenuItem extends StatelessWidget {
  final MenuObject menuItem;
  const MenuItem({super.key, required this.menuItem});

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
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Column(
              children: [
                Image.asset(
                  menuItem.image,
                  height: size.height * .1,
                  width: size.width * .3,
                ),
                const Spacer(),
                Row(
                  children: [
                    Column(
                      children: [
                        CustumText(
                          text: menuItem.name,
                          size: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        CustumText(
                          text: menuItem.price + r" $",
                          size: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          BlocProvider.of<MenuCubit>(context)
                              .addToCart(menuItem);
                        },
                        icon: const Icon(
                          Icons.shopping_cart,
                          size: 40,
                        ))
                  ],
                ),
              ],
            ),
            BlocBuilder<MenuCubit, MenuState>(
              builder: (context, state) {
                return OrderCount(
                  count: menuItem.count,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
