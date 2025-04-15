import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/presentation/cubit/menu_cubit.dart';
import 'package:menu_app/presentation/views/widgets/menu_item.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final menu = BlocProvider.of<MenuCubit>(context).menu;
    return Scaffold(
      body: GridView.builder(
        itemCount: menu.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) => MenuItem(
          menuItem: menu[index],
        ),
      ),
    );
  }
}
